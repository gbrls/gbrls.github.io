---

title: Psychedelic Programming Languages
slug: Psychedelic-Programming-Languages
date: 2022-09-09
publish: true 

---

# A bit of background 

I started programming to make simple webpages and Flash games. To me it was
about interacting with those systems, adding automation to them. Not long after
that I started coding robots with Arduino and it was still just that,
automating turning on a led, reading a value, writing something to a terminal,
etc.

It started to change when I discovered [The Coding
Train](https://www.youtube.com/c/TheCodingTrain), through that I started to
see, actually _see_ how complex and amazing could be the things you did with
code. It was then that I started  to get concerned with abstractions, my code
grew bigger and everything was so messy! I needed some help. Processing is
_based_ on Java which means the tools that I used to handle that complexity
were Functions, Classes and Methods, it was actually fun.


At the same time, I was part of a team making Arduino robots to compete. I
quickly applied the tools that I learnt with Processing to Arduino, afterall
they're similar. I had no notion of state machines and agents, so the code was
a mess and it didn't work well. But, you know, all was good, I felt in control
of the code, still very fun.


During that time I met with some people that blew my mind my showing me how
_"real programmign"_ was like with C# and machine learning. I felt like I
needed to learn some real programming... and I wanted to code my own _Dwarf
Fortress_. I searched online, Dwarf Fortress was made in C++, Arduino was
_based_ on C++ so it shouldn't be that hard, right? Right??  Well, I printed a
C++ book, _Jumping into C++_ and ate it; it taught the basics of pointers,
structs, methods, classes and templates, it's a nice book.

## Making games

Armed with my fresh new C++ knowledge and the amazing [LazyFoo's SDL
tutorials](https://lazyfoo.net/tutorials/SDL/), I was ready to tackle any 2D
game that I could think of.
What is the game called you ask? [2dGame](https://github.com/gbrls/2dGame) of
course, why not? If you know something about C++, you already know that it
didn't work as I expected. Even though I grasped the language's syntax and
basic abstractions, _even though I KNEW pointers_ there was some giant beast
that destroyed me, the *_RUNTIME_*.


There were _segmentation faults_ all around, some predictable, some very
unpredictable. The issue was that before my code interacted with a small domain
(The flash engine, A small embedded system with Arduino helping me, the JVM
with Processing helping me) and now it interacted directly with the whole
computer system, _"real programming"_, or in fact, Systems Programming (I wish
I knew that back then). Classes and methods didn't help me if I dont't
understand the stack or the heap.


## Having fun with Gophers

I moved on to other things: Web programming in Go. When I discovered Go I felt
the same thing that I did when I started coding Processing. It was novel, fun,
and powerful. Some things struck me as essential to Go's joy:

- How simple it was.
- Easy parallelism.
- **How easy it was to use other peoples' code together with mine**.

Due to those things I was making games easily, and interacting with the web 
with joy. I learnt a lot of things and had a great time, thanks Go.


One of the things was semantic versioning of dependencies. I love immutable
things, Go was creating some sort of global registry for all of those different
versions and I got involved in some open source project related to it. It was
very little but it still felt nice.

## A lot of Systems Programming

I can't recall why or how, but I started going back to Systems Programming, I
learnt _the basics_ of Rust and understood why programming C++ was so hard back
then.
I was making steady progress learning about systems and programming in C. I'd
say that was the most formative time for me in terms of how much effort I
investest learning about programming and computers in general.

I don't know why but I started reading _Land of Lisp_ and it really did fuck me up.


# Psychedelic Programming Languages

## My first trip

Common Lisp is a psychedelic programming language, and _Land of Lisp_ really
did show that. 


![image](https://www.lisperati.com/different.jpg)


It's an
amazing book and it opened up my mind with Lisp. It presented itself in a very
"Look how amazing, cool, and different Lisp is!!" it clicked for me. Now the
walls seemed to breathe and I love parenthesis man! It also opened up my mind
to functional programming, that for a long time seemed to be only
reserved to academics obsessed with _proofs, purity and elegance(?)_.


This experience changed how I programmed and thought about programming. But I
still felt like the same Gabriel that breathed Systems Programming... but this
time a lot more confident in my programming skills. I decided to code a
minecraft clone from scratch using only C++, SDL, and OpenGL. This time, I want
to show the old Gabriel how good of a programmer I am now, how much I can do. I
still had some issues with the runtime, specially related to performance and
allocations, but this time I was able to [succeed
somewhat](https://github.com/gbrls/myncraft).


## My second trip

My second psychedelic programming experience was not given by a book or
something made by nature, but by this fella named [Dan
Grossman](https://www.coursera.org/instructor/~873260). He has a three part
course in Coursera named, you guessed it, _Programming Languages_. He's like
a Programming Languages god and taught ML, Scheme, and Ruby in an amazing way.


ML is a psychedelic language. It opened my eyes to what a good type system is
capable of. Fuck C's,  C++'s fuck Java's and fuck Java. ML has a **REAL** type
system. To me this really shows how powerful this experience was, when after it
you are fuck this fuck that I know better, fuck you. And ML gave me that.

I guess I could've had that same experience from learning Haskell, but I never
was able to get into it, I guess it was just too... uptight, too square, too
self conscious.

That course also taught me a lot of vocabulary and mechanisms to compare
programming languages fairly. It made me look Rust with new eyes, like dude, it
has _Sum Types_, **good** _Type Inference_ and all of those goodies. This time
I fell in love for Rust, for real (that's funny because the course had nothing
to do with it).


I felt blessed by the Programming Languages teaching, I was watching long
theoretical Programming Languages youtube videos, reading papers, writing
compilers, oh boy. That second trip really got me well, it changed me deeply.
Heck I even went to a conference (By luck that was 2020 and many important
conferences were being conducted remotely, even for free) and got to ask
questions to important people related to Programming Languages history. I was
in the same slack channel as Rich Hickey! isn't it crazy?


With some time my interests shifted a little from Systems Programming, those
languages that by the time were already my old friends like C++ and Rust became
too heavy, I'm not thinking about performance nor memory that much, so why are
you getting in the way?

# Finding your home

## My third trip

This one wasn't as crazy as the other ones, it felt like searching and finding
for my own home. I came across the book [Data Oriented
Programming](https://www.manning.com/books/data-oriented-programming) by
Yehonathan Sharvit, it talked about the style of programming that's commonly
adopted by Clojure programmers, they tend to focus on the data and
transformations to it.

    Things should be simpler, data organized only as plain data. Arrays, maps,
    tuples. Functions transform data (never mutate it) and worry about the
    runtime later.

That's Clojure's way (it even has two differents runtimes) and I feel like
that's also the Data Oriented Programming way. Elixir also fit in this niche
pretty nicely. So this time it's not even a just Programming Language, it's a
mix of a Programming Paradigm, a Language, and a Runtime.


I even feel somewhat disconnected from that old Systems Programmer Gabriel,
we're not the same person. My head is so tuned to programming this way now.
Clojure is a psychedelic programming language . Of course I still face some
problems, but they're different and better now.


# Final thoughts

That's what I wanted to say with this blogpost, how some experiences with
Programming feel so much _Psyschedelic_. They change the way
you think permanently, that they may feel even religious, they're powerful.

Programming Languages, ideas about Programming in general can be crazy, very
philosophical, and practical at the same time. I think most of them should be
given a chance, they may change you.


Thanks for reading. Hope you had a good time.
