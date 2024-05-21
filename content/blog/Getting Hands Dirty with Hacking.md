---
title: Getting Hands Dirty with Hacking
date: 2022-11-03
publish: true
tags: []
---

# Intro & Motivation

For a a while now I have been thinking about writing this. Earlier I've written
about [getting into
Cybersecurity](https://medium.com/@gabrielschneider100/going-to-cybersecurity-as-a-software-engineer-intern-d416881ab2a2),
I was about a month into my internship and it was much more about my reaction
to: "You're going to Security now, good luck young one".

Now I'm five months in, and many things have changed. I'm still here (literally
here, I work from home), I'm still an intern, but still, things are very
different.

So, I'm writing this here because there were many times where I had to stop,
grab a piece of paper and just dump the new things that were clouding my head.
I still wrote almost daily markdown notes on the new things  that I was
learning, but still, it's different, sometimes all I need is a blank piece of
paper and a nice pen. The same way I write a lot to myself, it's not enough,
from time to time I feel the need to share what I've learned, so this is it.


## Processes & Techniques

In the start I was: "I want to get really good at hacking, so I'm going to
learn new techniques and get really good at them, SQL Injection, XSS, wait for
me I'm coming after you!". And while there's value to that, by itself,
practicing those techniques wasn't really going to help me that much. I was
trying to turn into a good fighter just by repeatedly punching a punch bag,
it's not going to work just by itself, I'm going to get my ass kicked this way.


The thing that was missing in my approach was actually deeper than I expected,
to be a hacker you have to think like one. For a very long time my mind was set
on building things and solving problems, I wanted to make robots, games, and
explore maths; that was basically it. Software Engineering was a straight path
ahead, it's different, but at the end it's just building things and solving
problems. That's not the case with Hacking, at all.


To think like a hacker honestly is like listening to your inner devil. When you
come across something, you want to take advantage of it, I want to learn about
it until you know enough to break it. It took a while, but I can feel the
effects of my _self corruption_, this inner evil voice is already talking _all
the fucking time_ in my head. 

On the Internet you see hackers doing stuff with Software and then doing
crazier stuff with Hardware, it didn't made much sense to me how those people
could change domains like that, now it does. It's like coding in Clojure and
then going to embedded C, the mindset is _basically_ the same, it's the
enviroment and the tools for it that changed.


## My first Big Project


When I started to notice a big improvement in my _Dark Arts_ fighting
techniques was when I stopped to think about my thought process and it write
down. A month ago I was faced with: "You have 4-5 weeks to test those websites
and write a report, good luck pal". I work in a _great_ team, but I felt like
they had put way too much faith in me at the time. For the first week I was
just testing with the techniques that I had learned, I was much better at those
than I was before, but still.

I had _one_ good finding and that was it. I had a motivation rush after finding
it, but soon it started to feel like I was trying to climb a huge wall with my
bare hands. It as then that I stopped, grabbed a piece of paper, a nice pen,
did some research about the _pentesting process_, read some checklists and
started building my own. The thought process was forming in my head from
working with my peers, from the things that I was learning from the internet,
my head was getting cloudy with it. Writing it down was like making those
clouds rain, condensating them to water and clearing up my mind.

The project is done now and it was a great success. This kind of _"process
organization"_ was very important to it's success.

![](https://www.myinstants.com/media/instants_images/boratgs.jpg)


## Things I've learned

So, Gabriel, you say; what do you have to show to us? You climbed that wall,
wrote some shit in some stone slabs, now share it with us!

So... I say; beware of the golden calfs out there in Security, there are many!

The first things that I liked is that **it feels like war**. There are clearly
two sides: We (usually a small team or single person) vs them (A company or a
specific product). Some of the processes we use for hacking are actually used
by military intelligence. Lo and behold these are my commandments:


---

The fist commandment is: **Information is Key**.

Let's say there's a Pizza shop which has their own delivery service. They hired
us to test its security. The first thing is that we need to do is to gather
information about it. 

- How does it work?
- Which features does it have?
- Can I order Pizza to my neighbour?
- Do they check if I'm the person I'm claiming to be?

And then you discover: Oh, if the delivery takes more than 30 minutes the pizza
is free. What happens if I order pizza from somewhere far away? Will  they
deliever to me? What if it's not that far away, but I keep making changes to
the order so it takes longer?

You can also find hidden things this way, i.e. They have lower prices if it's
your birthday, but they only change the price if you ask for it, they keep this
promotion hidden for some reason. Can I fake my ID to always get lower prices?


> You need to understand how it's supposed to work, its features and
> functionalities. So you know what to break and exploit.

---

The second commandment is: **Organization is Key**


We'll gather a lot of information, it will be needed for writing a report to
our Pizza shop client, to our attacks, and to share it with our team.

Also, for every domain that we are working there will be lots and lots of
information about the specific tools and processes for it. Better organization
means more efficient tests, the next time you do them, because information is
accessible and searchable. My setup is described
[here](https://gbrls.github.io/blog/current-organizational-structure/).

Organization is also important to keep track of the tests you've done, the time
you did them, and which tests are still left to do.

---

The third commandment is: **Know your domain**


Pizza Delivery Services is a very specific domain. Knowing well your domain
will greatly improve your chances of success in an attack. Think how having
worked on the phone in a Pizza Delivery Service would help you exploit another
Pizza delivery companies.

---

The forth commandment is: **Attack fast and with precision**


Many times you'll need to execute an attack as a proof of concept. The attack
should be well planned, precise and fast.


Most of the time you'll need to take care to not cause disruption to the
regular services. 

You'll need to be fast to not give enough time for them to
react to it.


You'll need to be **very** careful with [PII](https://www.cloudflare.com/en-gb/learning/privacy/what-is-pii/).

---

# Conclusion

Those commandments are maturing, I'm still very new at this and different
people have different styles. Despite those things, I hope they are helpful.

Security is very big and exciting. Have fun and take care.


# References

- [The Web Application Hacker's Handbook](https://www.amazon.com.br/Web-Application-Hackers-Handbook-Exploiting/dp/1118026470)
