---
title: "When Things Are Too Smart"
date: 2021-04-14T15:28:33-03:00
---

## The Perpetrator 
This bad boy here, he's too smart.

![image](/gallery/powerbank.jpeg)

I bought it in Israel for about 70 NIS, it was a good deal.
 I was really happy with this purchase and it had served me well for a long time.
 I recently got back to the hobby of making hardware projects. I have a tiny power supply that has an USB port and this Power Bank would connect to it and power what is connected to the power supply. It would work really well because this powerbank has a capacity of 10,000mAh, _so I thought_.
 ## The issue

 The thing is, when connected to an Arduino Nano the powerbank works for about 10 seconds and then shuts off. Inicially I thought that it had to do with the power supply not handling the power output or something, but then after a [little research](https://arduino.stackexchange.com/questions/34865/power-bank-turns-off-spontaneously/34878) I realized what was going on.

 ## It's just too smart!
 It shuts off because it detects too little current, so it thinks _"Just 10mA? Well, my job here is done, I'll sleep now"_ and shuts off.

 So, I thought about doing a lobotomy and making it dumber, but c'mon, poor little guy, he's just trying to be helpful.

 ## The solution
The solution  is simple: Make it  work harder, this way it won't think it has fully charged something and will never sleep.

We want it to draw more current and not disturb the rest of the circuit, thus we connect a load in parallel from the GND to VCC. The additional current it'll draw will be `V/R`, where `V` is the power supply's voltage and `R` is the resistance of our load.

The least resistive resistor that I have is a `330Ohm` one, so a single Resistor in parallel would draw `5v/330Ohm = 15.1mA`. So through the methods of an advanced technique called trial and error I discoreved that four `330Ohm` resistors do the job.

Here is what it looks like.


![image](/gallery/dummy-load.jpeg)

## Conclusion
Maybe there's a moral to this story, like: 
> "_Tinkerers have to expect to tinker more than what they think they'll tinker_"

or like:

> "_Don't use stuff to do what it wasn't inteded to_"

But I can't find any. Have a nice day.