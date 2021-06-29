---
title: "C Wizardry - Homoiconicity in C"
date: 2021-05-22T20:52:39-03:00
---

## C Wizardry intro
Sometimes I find some neat, crazy, cryptic features of the C programming
language.  As a Teaching Assistant for it, I believe I must become a C
wizard and scare the students with some esoteric magical spells. So, this is
going to be a series of posts about weird (and maybe useful) stuff in C.

## Homoiconicity
It's a word known by Lisp users and Programming Language nerds. It's a
really important feature of Lisp (I [talked a bit about it](/mk-lisp-0) in my Make a Lisp
Interpreter series). The basic idea is that you can use code as data and data as code,
e.g: In languages where you have an eval function, you can read a string and then
eval it, doing this you're using data as code, one way to use code as data are
macros, they manipulate code in compile time as data, though when talking about
homoiconicity it also means to manipulate code as data in the runtime.

## Homoiconicity in C
This week I was studying [JIT
Compilers](https://en.wikipedia.org/wiki/Just-in-time_compilation) and came
across [this
post](https://blog.reverberate.org/2012/12/hello-jit-world-joy-of-simple-jits.html),
<!---
Show here an example usage of mmap, "I encourage you to run this code and see
what it does" --->
The article shows this code, that demonstrates how to execute memory in C,
(**disclaimer:** This only works on Unix systems).

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>

int main(int argc, char *argv[]) {
  // Machine code for:
  //   mov eax, 0
  //   ret
  unsigned char code[] = {0xb8, 0x00, 0x00, 0x00, 0x00, 0xc3};

  if (argc < 2) {
    fprintf(stderr, "Usage: jit1 <integer>\n");
    return 1;
  }

  // Overwrite immediate value "0" in the instruction
  // with the user's value.  This will make our code:
  //   mov eax, <user's value>
  //   ret
  int num = atoi(argv[1]);
  memcpy(&code[1], &num, 4);

  // Allocate writable/executable memory.
  // Note: real programs should not map memory both writable
  // and executable because it is a security risk.
  void *mem = mmap(NULL, sizeof(code), PROT_WRITE | PROT_EXEC,
                   MAP_ANON | MAP_PRIVATE, -1, 0);
  memcpy(mem, code, sizeof(code));

  // The function will return the user's value.
  int (*func)() = mem;
  return func();
}
```

I encourage you to run this code to get a feeling of it, but what it means is
that **you can create an array, manipulate it as a regular array and then
execute it as code**!


Now, the other way around (manipulate code as data) it's also possible.
With the help of [this stack overflow thread](https://stackoverflow.com/questions/27581279/make-text-segment-writable-elf),
 I was able to get it working. The first thing that I did was to try to read a function's bytes:


```c
#include <stdio.h>
#include <string.h>

int f0() {
    return 42;
}

int main() {
    int padding[100];
    memset(padding, -1, sizeof(padding));

    char* p = f0;

    for(int i = 0; i < 16; i++) {
        printf("%x ", (int)(p[i] & 0xff));
    }

    putchar('\n');

    return 0;
}
```
And this is the output (on my my machine running 20.04 Ubuntu with `gcc`), I
highlighted the actual function code:

                           v--------------v
    f3 f 1e fa 55 48 89 e5 b8 2a 0 0 0 5d c3 f3

I was expecting `gcc` to optimize the function definition and discard the
[function's boilerplate
code](https://en.wikibooks.org/wiki/X86_Disassembly/Functions_and_Stack_Frames),
which is those bytes at the beginning and the `5d` before the `c3`.

So, now that we know where the `42` is in the 10th position in the binary code
(it's the `2a, 16 * 2 + 10 = 42`) then we can change it in our code.

**Disclaimer**: This code also only runs on Unix systems due to the way that we
allow the text segment to be writable.

You also have to compile with these flags.

    gcc --static -g -Wl,--omagic -o test test.c

```c
#include <stdio.h>
#include <string.h>

int f0() {
    return 42;
}

int main() {
    int padding[100];
    memset(padding, -1, sizeof(padding));

    int a = f0();

    char* p = f0;
    // changing the return value of the function
    p[9] = 16;
    for(int i = 0; i < 16; i++) {
        printf("%x ", (int)(p[i] & 0xff));
    }
    putchar('\n');

    int b = f0();

    printf("a = %d, b = %d\n", a, b);

    return 0;
}
```

And the output is:

    f3 f 1e fa 55 48 89 e5 b8 10 0 0 0 5d c3 f3
    a = 42, b = 16

Yay! Now we've used code as data completing the homoiconicity cycle.

