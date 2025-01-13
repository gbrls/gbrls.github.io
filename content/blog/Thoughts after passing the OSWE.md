---
title: Thoughts after passing the OSWE
date: 2023-09-07
publish: true
tags: ["web"]
---

Last weekend I got this email:

> Dear Gabriel,
> We are happy to inform you that you have successfully completed the Advanced
> Web Attacks and Exploitation certification exam and have obtained your Offsec
> Web Expert (OSWE) certification.


There's something weird about opening those emails which contain the result of
something that I really wanted. Result in Rust's semantics, a Sum type, which
before opening it, I don't know if it worked or not.

I feel a little bit betrayed by those emails because even if it didn't work,
it'll start by saying something nice like: "It was very good to know you!", or:
"First of all, congratulations for doing this whole process"

Anyways, I read it all and was really happy and relieved. Here I'm going to
talk about my experience with it, review and tips.


## What is the OSWE

The field of information security has a thing for certificates that I've never
seen while I was working in software engineering, it's very common to see
people with a handful of certificates.

OSWE is made by _Offensive Security_, they're the company behind Kali Linux and
Metasploit. They have a lot of reputation in the industry and their
certificates are one of the most well regarded for Pentesting.

They have a coulple of different categories for certificates, the most famous
one is probably the OSCP (which teaches a lot of stuff about pentesting in
general in various different environments). The OSWE is completely focused on
Web Apps, i.e. stuff that talks HTTP and that poops Javascript.

One of the key things about this certificate is that it focus a lot on
white-box testing, this means that I spent a lot of time reading code, reading
debugging logs, etc. Doing white-box testing of course doesn't mean that you
can't black-box test it, but it's just way easier when you see the whole
picture.

Offensive Security offers a course, Web-300, which is all the necessary
material for the OSWE exam. They have labs, text, and video material.

When you have access to the course, you can schedule your OSWE exam, it takes
48 hours of hacking + 24 of reporting, it's tough.

## OSWE Review

I strongly believe that to understand something is a step in the direction of
hacking it. Every step of making a contribution of a software project, helps
you hack it, download the source code, understand the structure, download the
correct version of the toolchain, modify it, build it, test it. All of those
are part of it, and they really help in the hack's speed and success.

I think the white-box approach that was used in the course is really good for
those reasons. The certification is really good if know what it is about and
wish to learn what it teaches. 

It's not for everyone on every stage of the career, I disagree with the people
that try to gatekeep it and say that you need X years of experience before
attempting it. If your work is mainly in Web Applications pentesting, or you
really wish to work with that, then I recommend it. 

It builds on a foundation of basic Linux skills, basic pentesting (like how to
get a reverse shell), programming (you really got to know how to code), and web
applications, you need to know those things before it, but nothing else more.

I really liked it, the thing that I took away the most from it, is how to do
black-box testing more effectively. Yes, the course focuses on white-box
testing, but that perception that you get from looking at the code is turned
into an intuition about the working of web applications. I.e: Testing a Web
App, you'll try to guess how the backend implements the funcitonalities that
you're testing and that will help a lot.

## OSWE Prep

Before doing it, I recommend at least:

- Doing a few easy and medium boxes on Hack the Box.
- Program a simple a web application using a popular framework like Django or
  Spring.

  And that's pretty much it for the prep.
