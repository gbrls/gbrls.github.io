#import "html_elements.typ": post
#show: post

= The Inevitability of Getting Pwned

In this blog I'll show the connections between hacking and Computing Theory to
show how getting owned is inevitable.

== Basic definition of a turing machine

Let's start with a simple definition of a turing machine.
So, our basic turing machine has a few parts:

- A tape, which we can write any symbols we like.
- A head, which is fixed on the tape, can move left, right, read symbols from the tape, and write symbols in it.
- A decidor (_more formally, a state machine_) that decides what to do next after reading a symbol in the tape.

We say that computers can compute everything that a turing machine computes, and this is the basis for all the modern luxury that we have nowdays thanks to computers.
Computers are a complex digital beasts, but their beating heart is still something simple that is very similar to a turing machine, reading instructions, jumping, skipping instructions, writing to memory.

But why talk about turing machines here? Well, turing machines are *very robust*, and this is a very good feature for us hackers...

According to Michael Sipser in _Introduction to the Theory of Computation_ (which inspired me to write this):

_"We call this invariance to certain changes in the definition *robustness* [..] Turing machines have an astonishing degree of robustness."_

In other words: Computers are general beasts, and they are very resistant to change, *it's hard to make a computer stop being a computer*.

One example of this is that if we have a turing machine that has (for example) two tapes and two heads, it actually has the same power as a regular turing machine.

This is good for Engineers who build computers because, if you follow the basic ideas of a turing machine when building a computer, well, it'll be able to compute everything.

== Brainfuck

Brainfuck (depending who you ask) is the funniest programming language ever. It has a cool name, and it looks like this:

```brainfuck
>++++++++[<+++++++++>-]<.>++++[<+++++++>-]<+.+++++++..+++.>>++++++[<+++++++>-]<+ +.------------.>++++++[<+++++++++>-]<+.<.+++.------.--------.>>>++++[<++++++++>- ]<+.
```

This is a "Hello, world" in brainfuck. After reading it I think you understand where the name comes from.

Brainfuck is really simple, it only has the `> < + - , . ] [` symbols and it can do anything and any other (_good_) programming language can do; in fact, brainfuck can compute anything that's computable by a turing machine.

How do we prove that? To do so, we need to simulate a turing machine using brainfuck, we already know that turing machines have a very flexible (and simple!) definition, thus simulating a turing machine using brainfuck shouldn't be very hard to visualize.

When a language can compute anything that a computer can, we call it *turing complete*.

== Let's talk about hacking

It's thanks to these principles that we can run Doom on almost anything nowdays. But what about owning stuff?

The fundamental thing about computer security is that many systems accept arbitraty user input, and trying to make a computer *not do any computation* with the input that it receives is fundamentally against its nature.

Securing computers is mostly an exercise of restricting the general powers of computers, such as isolating networks, blocking access to regions of memory, and monitoring the computer for "unintended/suspicious behaviour".

So, the security in computer systems comes as a complexity on top of a simple and very hackable system. And we know that complexity is always fragile, it's prone to mishandle corner cases, miss attack vectors, and in general have unforseen consequences to the system.

Sooo... Computers are hackable by nature, hacking is unleashing their most basic functionality (Arbitrary Code Execution).

Happy Hacking!

