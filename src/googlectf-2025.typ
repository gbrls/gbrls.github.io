#import "./html_elements.typ": post

#show: post

// +++
// title = 'Googlectf 2025'
// date = 2025-06-30T17:45:28-03:00
// draft = false
// tags = ['rev', 'ctf']
// +++



= rev-multiarch-1 (126 points / 99 solves)

This challenge was solved by me and [Matt.](https://lobisomem.gay).

The challenge files were a Linux executable and a misterius `crackme.masm` file.

We worked together by him reversing the actual VM runtime and I was reversing
the binary file format and was writing some python code to interact with it.

In the first day we were actually sidetracked trying to solve `pwn-multiarch-2`,
it wasn't until the end of the day that then we realized that there's the
`rev-multiarch-1` and they're based on the same vm binary. It didn't change our
methodology to solve it, since we are still reversing it at that time, but this
time we had a valid program with the `crackme.masm`.

Below is the reversing of the main function, as you can see it's pretty straight
forward:

```c
__int64 __fastcall main(int a1, char **f, char **a3)
{
  char *segments; // rax
  __int64 v4; // rbp
  char *stuff; // rbx

  setbuf(stdin, 0);
  setbuf(stdout, 0);
  setbuf(stderr, 0);
  if ( a1 <= 1 )
  {
    fprintf(stderr, "[E] usage: %s [path to .masm file]\n", *f);
    return 2;
  }
  else
  {
    fwrite("[I] initializing multiarch emulator\n", 1u, 0x24u, stderr);
    segments = (char *)parse_bin(f[1]);
    v4 = (__int64)segments;
    if ( segments )
    {
      stuff = build_vm_state(segments);
      fwrite("[I] executing program\n", 1u, 0x16u, stderr);
      while ( (unsigned __int8)run_vm((__int64)stuff) )
        ;
      if ( stuff[48] )
      {
        fwrite("[E] execution failed\n", 1u, 0x15u, stderr);
        debug_print_vm((__int64)stuff, 1);
      }
      else
      {
        fwrite("[I] done!\n", 1u, 0xAu, stderr);
      }
      sub_555555555427(stuff);
      call_free(v4);
      return 0;
    }
    else
    {
      fwrite("[E] couldn't load multiarch program\n", 1u, 0x24u, stderr);
      return 1;
    }
  }
}
```

Note the `debug_print_vm` function, it was pretty useful to undestand the vm
state struct since it prints the stack and all four registers.

Below is the assembly code that prepares the arguments for the printf call,
note that all arguments are being read relative to `rdi`, which holds the
address of the vm state struct.

```asm
mov     ecx, [rdi+3Bh]
mov     edx, [rdi+37h]
mov     esi, [rdi+33h]
mov     eax, [rdi+47h]
push    rax
mov     r9d, [rdi+43h]
mov     r8d, [rdi+3Fh]
lea     rdi, debug_fmt_string ; "  ---[ PC=0x%08x SP=0x%08x | A=0x%08x B"...
mov     eax, 0
call    _printf
add     rsp, 10h
test    bpl, bpl
jnz     short loc_555555556A8F
```

At this point we had a good idea about the how the program worked, but we wanted
to understand what the `crackme.masm` does.

This is the hexdump of the whole file:

![image](/hexdump.svg)

Just seeing the strings we can get a pretty good idea of what it does:

- It has four bytes at the start, being the magic bytes for the MASM file.
- It seems like it consists of three seperate challenges, seeing the strings
near the end.


At this step what I'd do would be to debug it in `gdb` to see what's happening,
i.e. where it reads input we control, and how it's used when deciding if a
challenge step is correct or not. The issue is that since this is a VM, for
every instruction executed by it, in `gdb` we see a lot of code and function
calls related to the implementation of the VM itself, doing the fetch, decode
and execute cycle.

> Given the amount of solves this challenge had, I believe most
> people just solved this manually on `gdb`, but I *really* wanted to try a
> new tool...

= libdebug

This is where [libdebug](https://github.com/libdebug/libdebug) comes in, it's
basically a python library to automate `ptrace` debugging, it's pretty cool and
since I discovered it, I hadn't had the opportunity to use it yet.

With the script below I was able to debug the `crackme.masm` with an interactive
debugger, that I could even add breakpoints and single step instructions.


```python
from libdebug import debugger, libcontext
from pwn import u64, u32, u8

cur_vm = 'stackvm'
cur_cycle = 0

hit_vm_bp = False
vm_breakpoints = [
    #0
    #18, # challenge 1 ends
    #49
]
vm_ip_breakpoints = [
    # 0x131, # regvm loop cmp
    #0x5a, # chal1 cmp
    #0x7c,
    0x88, # chal2 cmp
    #0xcd, # chal3 cmp?
    0xdd, # chal3 actual cmp?
    0x10b, # chal3 actual actual idk?
    #0x12d, # xor r1 r3
]
prev_input_dbg = ''
vm_stop = []

STACKVM_MNEMONICS = {
    0xa0: 'S.SYSCALL',
    0x10: 'S.LDB',
    0x20: 'S.LDW',
    0x30: 'S.LDD',
    0x40: 'S.LDP',
    0x50: 'S.POP',
    0x60: 'S.ADD',
    0x61: 'S.SUB',
    0x62: 'S.XOR',
    0x63: 'S.AND',
    0x70: 'S.JMPI',
    0x71: 'S.JMPI.EQ?',
    0x72: 'S.JMPI.NE?',
    0x80: 'S.SCMP',
    0xff: 'S.HLT',
}


def stackvm_mnemonic(ins, is_ip=False):
    opcode = ins & 0xff
    dat = ins >> 8
    mnemonic = hex(opcode)
    if opcode in STACKVM_MNEMONICS:
        mnemonic = STACKVM_MNEMONICS[opcode]

    if (0x70 <= opcode <= 0x72) and is_ip:
        print('DIDJMP!!!!!!!!!!!')

    return f'{mnemonic} {hex(dat)}'

d = debugger(['./multiarch', './crackme.masm'], aslr=False)
io = d.run()

mem_access = d.breakpoint(0x00005555555554B3)
cycle_tick = d.breakpoint(0x0000555555556FFF)

d.cont()
io.sendline(b'2405061754')
io.sendline(b'\x46\x91')
io.sendline(f'{0x2b6043c}'.encode())

d.wait()

should_stop = False

def regvm_disasm(code_adr, ip):
  # a lot of boring code...
  # you can use your imagination for this function.

def stackvm_disasm(code_adr, ip):
    for i in range(ip, ip + (8 * 5), 5):
        ins = u64(d.memory.read(i + code_adr, 5).ljust(8, b'\x00'))
        if i == ip:
            print('>', end='')
        print(f'{i:08x}\t{stackvm_mnemonic(ins, i==ip)}\t{ins:05x}')

def disasm(off, ip, code_adr):
    if cur_vm == 'stackvm':
        stackvm_disasm(code_adr, ip)
    else:
        raw_instr = u64(d.memory.read(code_adr+ip, 8))
        print(f'raw: {raw_instr:016x}\n')
        acc = ip
        for i in range(0, 8):
            s, bytes_read = regvm_disasm(code_adr, acc)
            print(f'{acc:08x}\t{s}')
            acc += bytes_read
        print('')

def print_stack(sp, stack_adr):
    print('-------stack sp: ', hex(sp), hex(stack_adr))

    for i in range(sp - (4 * 5), sp + (4 * 5), 4):
        cur = u32(d.memory.read(stack_adr + i, 4))
        if i == sp:
            print('>', end='')
        print(f'{cur:08x}')

    print('')

def calc_mode(ip):
    i = ip >> 3
    mode_ptr = u64(d.memory.read(d.regs.rbx + 0x18, 8))
    mask = u8(d.memory.read(mode_ptr+i, 1))
    bit_idx = ip & 7
    return (mask >> bit_idx) & 1

while not should_stop:
    if hit_vm_bp:
        i = input('masmdbg> c/n/q: ')
        match i:
            case 'c':
                hit_vm_bp = False
            case 'n':
                vm_breakpoints.append(cur_cycle)
                hit_vm_bp = False
            case '':
                vm_breakpoints.append(cur_cycle)
                hit_vm_bp = False
            case 'q':
                vm_stop.append(cur_cycle)
                hit_vm_bp = False
            case _:
                continue
        prev_input_dbg = i

    if cycle_tick.hit_on(d):
        ip = u32(d.memory.read(d.regs.rbx + 0x33, 4)) - 0x1000
        if cur_cycle in vm_breakpoints or ip in vm_ip_breakpoints:
            mode = calc_mode(ip)
            if mode:
                cur_vm = 'regvm'
            else:
                cur_vm = 'stackvm'
            print(f'\n\n========masm debugger=== {cur_vm} {cur_cycle}\nip -> {ip:08x}')

            r0 = u32(d.memory.read(d.regs.rbx + 0x3b, 4))
            r1 = u32(d.memory.read(d.regs.rbx + 0x3f, 4))
            r2 = u32(d.memory.read(d.regs.rbx + 0x43, 4))
            r3 = u32(d.memory.read(d.regs.rbx + 0x47, 4))

            sp = u32(d.memory.read(d.regs.rbx + 0x37, 4)) - 0x8000

            code_adr_ptr = u64(d.memory.read(d.regs.rbx, 8))
            stack_adr_ptr = u64(d.memory.read(d.regs.rbx+0x10, 8))

            print(f'~~~ REGS\n\t{r0:08x}\n\t{r1:08x}\n\t{r2:08x}\n\t{r3:08x}\n~~~~~')
            disasm(0, ip, code_adr_ptr)
            print_stack(sp, stack_adr_ptr)
            print('========cycle ended=====\n\n')
            hit_vm_bp = True

        if cur_cycle in vm_stop:
            should_stop = True
            continue

        cur_cycle += 1
        d.cont()
        d.wait()

    elif mem_access.hit_on(d):
        pos = d.regs.rsi
        sz = d.regs.rdx
        d.cont()
        d.wait()

    elif not d.running:
        io.interactive()
        should_stop = True

```

Below is how it looks like in action:

```
masmdbg> c/n/q:


========masm debugger=== regvm 139
ip -> 000000bd
~~~ REGS
        88c0ffee
        7a213a1c
        00000000
        00000000
~~~~~
raw: 00631100ffffff10

000000bd        PUSHI 0x00ffffff
000000c2        PUSH REG(0)
000000c3        JMPI.NE 0x00000000
000000c8        SUB REG(13), REG(13)
000000ca        UNKNOWN(0xff)
000000cb        UNKNOWN(0xc0)
000000cc        NOP
000000cd        CMPI REG(0), 0x00000000

-------stack sp:  0xee0 0x7ffff7fbc000
00000000
00000000
f2f2f2f2
88c0ffee
000010bd
>00009146
00000000
00000000
00000000
00000000

========cycle ended=====

```

As you can see the disassembler wasn't 100% complete, but it was enough to
manually reverse the `masm` file and solve it.
