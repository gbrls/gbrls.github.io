#import "lib.typ": entries, separator
#import "@preview/cetz:0.4.2"


#let entry-to-html(entry) = {
  let path = entry.file.replace(".typ", ".html")
  let pad = "." * 80

  let end = ""
  if entry.at("date", default: 0) > 0 {
    end = box()[#html.frame()[#text(font: "mononoki", fill: rgb("#8c8fa1"), str(
          entry.date,
        ))]]
  } else {
    end = text("....")
  }

  text[

    #link(path)[#text(entry.name)]#text(pad.slice(entry.name.len()))#text(
      end,
    )
  ]
}

#let post(contents) = {
  html.elem("head")[
    #html.elem("meta", attrs: (charset: "UTF-8"))
    #html.elem("title")[0x4200.cafe]
    #html.elem("link", attrs: (rel: "stylesheet", href: "style_compiled.css"))
  ]

  // simple backticks like `0x4200`
  show raw.where(lang: none, block: false): it => [
    #html.elem("span", attrs: (
      class: "text-peach bg-crust p-1 rounded-md",
    ))[#it]
  ]

  show raw.where(block: true): it => [
    #html.elem("div", attrs: (
      class: "bg-mantle p-8 rounded-xl text-sm overflow-x-auto",
    ))[#it]
  ]

  show heading.where(level: 1): it => [
    #html.elem("div", attrs: (class: "text-3xl p-8"))[
      // #html.elem("div", attrs: (class: "text-mauve text-3xl p-8"))[
      #it
    ]
  ]

  show heading.where(level: 4): it => [
    #html.elem("div", attrs: (class: "text-yellow"))[
      #text(str(counter(heading).display()))
      #text(it.body)

      #html.elem("button", attrs: (
        onclick: "history.back()",
      ))[#sym.arrow.t]
    ]
  ]

  show link: it => [
    #html.elem("span", attrs: (class: "text-blue"))[#it]
  ]

  set raw(theme: "./mocha.tmTheme")

  // ========== body =======


  html.elem(
    "div",
    attrs: (
      class: "font-display bg-base min-h-screen min-w-fit text-text flex",
    ),
  )[

    #html.elem("div", attrs: (class: "flex-none bg-crust min-w-1/20"))[ ]
    #html.elem("div", attrs: (class: "flex-auto bg-crust"))[ ]

    #html.elem("div", attrs: (class: "flex-none p-8 min-w-fit"))[
      #html.elem(
        "article",
        attrs: (
          class: "max-w-[90ch] leading-relaxed [&>p]:p-2 break-words overflow-x-auto",
        ),
      )[
        #contents
      ]

      #separator(16)
      #list(..entries.map(it => entry-to-html(it)))
    ]

    // spacing
    #html.elem("div", attrs: (class: "flex-auto bg-crust"))[ ]
    #html.elem("div", attrs: (class: "flex-none bg-crust min-w-1/20"))[ ]
  ]
}


#let img(path) = {
  html.elem("img", attrs: (
    class: "max-w-xl block rounded-md p-4 mx-auto",
    src: path,
  ))[]
}
