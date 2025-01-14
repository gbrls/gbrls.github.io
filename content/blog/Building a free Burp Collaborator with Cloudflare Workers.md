---
title: Building a free Burp Collaborator with Cloudflare Workers
date: 2023-11-02
publish: true
tags: ["web"]
---
Burp collaborator is the thing that I miss the most in the free _community
	version_, and after that is the search. The Burp Collaborator is a tool that generates a domain and any interaction with that domain via DNS, HTTP and SMTP (maybe others are available too).

Anyways, Burp Collaborator is really useful, but it's paid (I can't recommend it to everyone because of that) and it's made to work inside Burp Suite, which comes with a whole set of limitations.

The goal of this project was to create a tool that:
- Worked like Burp's collaborator (in the most part).
- Free to use.
- Didn't rely on shady people to host it (this happens a lot in the security space).

I think I've achieved those goals, there are some limitations (e.g: We only support HTTP, and the headers are a bit fucked), but there are also some unexpected benefits. I hope you enjoy this project and find this useful.

After the Discord and Cloudflare setup is done, here's what a message will look like:

![](https://github.com/gbrls/gbrls.github.io/blob/toadhacker/static/discord-bot.png?raw=true)
# Basic Architecture

We need an edge component, which is going to be triggered when a request is made for it, and a place where the request is displayed for us. 

I chose Discord for the latter, I really like the idea of connecting some of by projects to text messaging apps, and by creating a Discord sever for those projects I have a lot of flexibility on how I can do those things (it also has good lookin' emojis).

For the edge component, I chose Cloudflare workers. Some people were talking about it on the webs, and I really wanted to try using it for a project. They have a generous free tier, they run on Cloudflare's CDN (this is a very welcomed unexpected benefit), and they are really easy to setup and use.

# Discord Setup

The discord setup is pretty simple, you create a server, create a channel for the collaborator, and in that channel you create a webhook URL. That can be done as **Click on the Gear** next to the channel's name > **Integrations** > **Webhooks**. 

![](https://github.com/gbrls/gbrls.github.io/blob/toadhacker/static/discord-gear.png?raw=true)

We webhook is just an URL with a high entropy token somewhere in it. Take good care of it, because anyone can send messages to that channel with it, but just sending messages (AFAIK).

And that's it, the Discord setup is done.

# Cloudflare Workers

For this step you'll need to setup a Clouflare account. Once that's done you can go ahead and go to **Workers & Pages** in the left sidebar, and then **Create application**.

![](https://github.com/gbrls/gbrls.github.io/blob/toadhacker/static/cf-dash.png?raw=true)

This will take you to the worker creation screen, and there you can just select **Create Worker** and then **Deploy**, don't worry, we're still going to put the code there.
After it has been deployed there'll be a button **Edit Code**, and there you can past the code below.


```js
// TODO: search for maximum message size, to split the message in smaller ones.
async function callWebhook(content, env) {
    try {
        const response = await fetch(env.WEBHOOK_URL, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({
                content: content,
            }),
        });

        if (response.ok) {
            return new Response('blz valeu.', { status: 200 });
        } else {
            return new Response('deu bom.', { status: 500 });
        }
    } catch (error) {
        return new Response('deu ruim.', { status: 500 });
    }
}

function getFlag(request) {
    let country = request.headers.get('CF-IPCountry');
    return `:flag_${country?.toLowerCase()}:`;
}

function getVerb(request) {
    let verb = request.method;
    let msg = "";

    for (const char of verb.toLowerCase()) {
        msg += `:regional_indicator_${char}:`;
    }

    return msg;
}

function getURLPath(request) {
    const parts = request.url.split('/');
    if (parts.length >= 4) {
        return '/' + parts.slice(3).join('/');
    } else {
        return '';
    }
}

function getHeaders(request) {
    let ua = request.headers.get('user-agent') || '?';
    return ua;
}

function getReferer(request) {
    let referer = request.headers.get('referer') || '';
    if (referer.length === 0) {
        return referer;
    }

    return `\n:link: **Referer:** \`${referer}\``;
}

// Beware that this function will not always return the user's IP.
function getIP(request) {
    let ip = request.headers.get('cf-connecting-ip') || '';
    if (ip.length === 0) {
        return ip;
    }

    return `:globe_with_meridians: **IP:** \`${ip}\``;
}

export default {
    async fetch(request, env, ctx) {

        return callWebhook(`${getVerb(request)} ${getFlag(request)} :twisted_rightwards_arrows: \`${getURLPath(request)}\`` +
            `${getReferer(request)}`+
            `\n${getIP(request)}` +
            `\n:identification_card: **User Agent:**\`\`\`${getHeaders(request)}\`\`\``
            , env);
    },
}; 

```


After that, just **Save and Deploy**. You can replace the environment variable for the discord webhook via the **Settings** pane for the worker.


![](https://github.com/gbrls/gbrls.github.io/blob/toadhacker/static/cf-vars.png?raw=true)

There are a few limitations to this setup when comparing to the real Collaborator. The Cloudflare workers can only listen to HTTP requests, and Cloudflare messes a little bit with the HTTP headers.
# It's done

I really liked this setup and the results impressed me. It's beatifully simple, and yet it's crazy useful. You can use it like collaborator to exfiltrate data via the URL or the Body, pixel tracking, and track blind XSS when it triggers, and anything else you can think of.
