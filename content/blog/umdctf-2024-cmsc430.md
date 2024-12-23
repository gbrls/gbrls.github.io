---
title: "umdctf2024 - cmsc430"
date: 2024-04-28T19:19:27-03:00
draft: false
description: ""
tags: ["rev", "umdctf"]
---

### Description

> This binary was compiled by an hand-crafted, artisan racket compiler, courtesy of UMD's very own CMSC430 class.

### Reversing

The attachment was an standard x64 ELF file. After opening it in my
decompiler, and going to the main function, everything seemed pretty
straight.

![](/img/umdctf2024-0.png)


Investigating this `sub_17e0` function we see that it has a lot of deep nested conditionals, where in each step it calls `read_byte()` and then compares it to a byte.


![](/img/umdctf2024-1.png)

To me this seemed like a pretty easy crack by using symbolic execution to find which input passess all of those conditionals. I tried using a simbolic execution engine inside Binary Ninja, but I never did it before and couldn't make it work.
So I ended up copying those bytes by hand and writing them to a python script to write them to a new file.

At first this didn't work because I didn't realize that the `read_byte()` function multiples by two the bytes that I reads, so I had to halve them.

### Flag

```python3
a = bytes([0xaa, 0x9a, 0x88, 0x86, 0xa8, 0x8c, 0xf6, 0xe6, 0xd0, 0xde, 0xea, 0xe8,
     0xbe, 0xde, 0xea, 0xe8, 0xbe, 0xe8, 0xde, 0xbe, 0xd4, 0xde, 0xe6, 0xca,
     0xfa])

# Added later
b = bytes([x // 2 for x in a])

with open('sol.bin', "wb") as file:
    file.write(b)

```

```console
└─$ hexdump sol.bin
00000000  55 4d 44 43 54 46 7b 73  68 6f 75 74 5f 6f 75 74  |UMDCTF{shout_out|
00000010  5f 74 6f 5f 6a 6f 73 65  7d                       |_to_jose}|
00000019
```
