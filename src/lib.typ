#import "@preview/cetz:0.4.2": canvas, draw
#import "mocha.typ": mocha

#let entries = (
  (file: "./index.typ", name: "Index"),
  (
    file: "./genuary-2026.typ",
    name: "Genuary 2026",
    date: 2026,
  ),
  (
    file: "./corctf-2025.typ",
    name: "COR CTF 2025",
    date: 2025,
  ),
  (
    file: "./googlectf-2025.typ",
    name: "Google CTF 2025",
    date: 2025,
  ),
  (
    file: "./midnightsunctf-2025.typ",
    name: "MidnightSun CTF 2025",
    date: 2025,
  ),
  (
    file: "./wolvctf-2025.typ",
    name: "Wolv CTF 2025",
    date: 2025,
  ),
  (
    file: "./irisctf-2025.typ",
    name: "Iris CTF 2025",
    date: 2025,
  ),
  (
    file: "./tfc-2024.typ",
    name: "TFC CTF 2024",
    date: 2024,
  ),
  (
    file: "./building-a-freeburp-collaborator-with-cloudflare-workers.typ",
    name: "Building a free Burp Collaborator with Cloudflare Workers",
    date: 2023,
  ),
  (
    file: "./router-command-injection.typ",
    name: "Finding a command injection in a router",
    date: 2023,
  ),
  (
    file: "./oswe-some-thoughts.typ",
    name: "OSWE - Some thoughts",
    date: 2023,
  ),
  (
    file: "./the-inevitability-of-getting-pwned.typ",
    name: "The Inevitability of Getting Pwned",
    date: 2023,
  ),
  (
    file: "./psychedelic-programming-languages.typ",
    name: "Psychedelic Programming Languages",
    date: 2022,
  ),
  (file: "./binbin-tree.typ", name: "Binary Binary Tree", date: 2021),
  (
    file: "./mk-lisp-1.typ",
    name: "Making a Lisp - 1",
    date: 2020,
  ),
  (
    file: "./mk-lisp-0.typ",
    name: "Making a Lisp - 0",
    date: 2020,
  ),
  (
    file: "./obi2018-baldes.typ",
    name: "OBI 2018 - Baldes",
    date: 2020,
  ),
  (
    file: "./obi2018-bolas.typ",
    name: "OBI 2018 - Bolas",
    date: 2020,
  ),
  (
    file: "./obi2018-cinco.typ",
    name: "OBI 2018 - Cinco",
    date: 2020,
  ),
  (
    file: "./obi2018-muro.typ",
    name: "OBI 2018 - Muro",
    date: 2020,
  ),
  (
    file: "./obi2018-maximin.typ",
    name: "OBI 2018 - MaxiMin",
    date: 2020,
  ),
)

#let rightbox(content) = {
  html.elem("div", attrs: (class: "flex font-meta text-sm text-justify"))[
    #html.elem("div", attrs: (class: "flex p-8"))[  ]
    #html.elem("div", attrs: (class: "flex p-8"))[  ]
    #html.elem("div", attrs: (
      class: "flex bg-mantle p-4 flex-auto rounded-s-xl",
    ))[
      #content
    ]
  ]
}

#let centerbox(content) = {
  html.elem("div", attrs: (class: "flex font-meta text-sm text-justify m-4"))[
    #html.elem("div", attrs: (
      class: "flex bg-mantle p-4 flex-auto rounded-s-xl place-content-around",
    ))[
      #content
    ]
  ]
}

#let textbox(content) = {
  html.elem("div", attrs: (
    class: "p-4 bg-surface0 rounded-xl font-display text-xs font-bold",
  ))[
    #content
  ]
}

#let separator(n) = {
  html.elem("div", attrs: (class: "mt-4 mb-4"))[
    #html.frame()[
      #canvas({
        draw.fill(blue)
        draw.stroke(none)

        let w = 0.7

        for i in range(n) {
          if calc.rem(i, 2) == 0 {
            draw.fill(mocha.colors.blue.rgb)
            draw.rect((i * w, 0), ((i + 0.8) * w, 0.1))
          } else {
            draw.fill(mocha.colors.peach.rgb)
            draw.rect((i * w, 0), ((i + 0.8) * w, 0.1))
          }
        }
      })
    ]
  ]
}

#let svg_inline(contents) = {
  box()[#html.frame[#text(fill: white)[#contents]]]
}

#let flex(contents) = {
  html.elem("div", attrs: (style: "display: flex; align-items: baseline;"))[
    #contents
  ]
}

#let logos() = {
  html.frame()[#image("./logo3.svg", width: 8em)]
  html.frame()[#image("./logo2.svg", width: 8em)]
}
