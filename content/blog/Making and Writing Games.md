---
title: Making and Writing Games
date: 2022-10-17
publish: true
tags: []
---

# Making and Writing Games


## Background

Making games has been big part of my motivation to code since the start. One of
the first things that I did was to write games in ActionScript 2 in Flash, they
weren't good and I didn't even publish them, but it was an important stepping
stone for me.

I love writing _and_ programming, so the project to make a story driven game
has been for a long time in the back of my head. They're are also _easier_ to
make as a single person or small team.

### The Game's Story

The game's story is going to take place in Recife, the city where I was born
and currently live. It's going to be about doing errands around the city,
meeting weird and interesting characters, going to old abandoned places, etc.
It's going to be a way to distill and present expeciences that I've had here,
other people's expeciences, a tribute to Recife in game form.

- It may or may not be linear.
- It's going to political, it won't be a direct representation of reality
  though.
- I'll try to make it quirky and funny.
- It's going to be full of different characters and different places.
- It's going to take place in a _odd_ reality, maybe a bit scifi / cyberpunk.

### The Game's Gameplay

Uhhh... So... I don't know. It's going to be made in a pixel art style
(probably), maybe 2d or 3d.


## The Problem

So, I have this ideia of the game laid out, so I just have to start working on
it, right? The problem is that I did try to do just that, a few times, but
everytime that I plan to start the game my engineering brain just starts
screaming and I waste a few weeks just writing code that'll never end up in the
game.

I start trying to make the basic systems of the game and some basic graphics so
I can start working on the story, but it doesn't make sense. I don't know how
the gameplay'll be, I just want it to be simple, so the story is the game's
main element. This difference between wanting to write the story and going at
full speed to write the game's code breaks my motivation after a while and I
just stop and forget about it for a few months.


## Proposed Solution


Recently programming in Clojure and Elixir changed how I think about some things (more info [here](https://gbrls.github.io/blog/psychedelic-programming-languages/).
I'm giving more importance to data and the separation between data and
behaviour because of those languages, and I can apply this to this game
project.

Yes it's a big project, but the most important thing is the story and the art,
and that's just data. I can start making those already, writing simple
(probably disposable) systems to test them and later I'll figure out how those
things will get into the game.

For now I think I'll make those assets in Clojure, it makes very easy to change
between code and data, serialization happens for free. It's almost like JSON
files that are alive.
