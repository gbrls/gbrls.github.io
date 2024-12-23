---
title: "umdctf2024 - Donations Fixed"
date: 2024-04-28T19:18:00-03:00
draft: false
description: ""
tags: ["web", "umdctf"]
---


This is the harder version of [donations](/writeups/umdctf-2024-donations-fixed), it's the same challenge, but you can't donate negative amounts this time.

After playing with it for a while, I realized that the solution was probably to find a way to donate money to your user, bypassing that Jeff Bezos check. So I tested adding more user id's in the `to` parameter and the money went to them.

So the solution was to create users, and donate all of their money to a user which will retrieve the flag.

```http
POST /api/donate HTTP/2
Host: donations2-api.challs.umdctf.io
Cookie: session=...
Content-Length: 36
Content-Type: application/x-www-form-urlencoded

to=lisanalgaib&to=gbrls&currency=999
```
