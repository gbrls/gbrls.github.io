#import "@preview/cetz:0.4.2": canvas, draw

#let entries = (
  (file: "./index.typ", name: "Index"),
  (file: "./binbin-tree.typ", name: "Binary Binary Tree", date: 2021),
  (
    file: "./c-gems-homoiconicity-in-c.typ",
    name: "Homoiconicity in C",
    date: 2021,
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


#let separator(n) = {
  canvas({
    draw.fill(blue)
    draw.stroke(none)

    let w = 0.7

    for i in range(n) {
      if calc.rem(i, 2) == 0 {
        draw.fill(rgb("#7287fd"))
        draw.rect((i * w, 0), ((i + 1) * w, 0.1))
      } else {
        draw.fill(rgb("#dd7878"))
        // draw.rect((i, 0), (i + 1, 0.2))
      }
    }
  })
}

#let svg_inline(contents) = {
  box()[#html.frame[#text(fill: white)[#contents]]]
}

#let flex(contents) = {
  html.elem("div", attrs: (style: "display: flex; align-items: baseline;"))[
    #contents
  ]
}
