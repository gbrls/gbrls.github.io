#import "lib.typ": centerbox, entries, rightbox, separator, textbox
#import "@preview/cetz:0.4.2"


#let footer() = {
  let m(c) = { html.elem("div", attrs: (class: "text-xs font-bold"))[ #c ] }

  centerbox[
    #m[#link("/index.html")[`HOME`]]
    #m[#link("/index.xml")[`FEED`]]
    #m[#link("https://github.com/gbrls/gbrls.github.io")[`SOURCE`]]
    #m[#link("mailto:contact@0x4200.cafe")[`contact@0x4200.cafe`]]
  ]
}

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
    #html.elem("meta", attrs: (
      charset: "UTF-8",
      name: "viewport",
      content: "width=device-width, initial-scale=1.0",
    ))
    #html.elem("title")[0x4200.cafe]
    #html.elem("link", attrs: (rel: "stylesheet", href: "style_compiled.css"))
  ]

  // simple backticks like `0x4200`
  show raw.where(lang: none, block: false): it => [
    #html.elem("span", attrs: (
      class: "text-red",
    ))[#it]
  ]

  show raw.where(block: true): it => [
    #html.elem("div", attrs: (
      class: "bg-mantle p-8 m-8 rounded-xl text-md overflow-x-auto",
    ))[#it]
  ]

  show heading.where(level: 1): it => [
    #html.elem("div", attrs: (class: "text-2xl font-meta font-black p-8"))[
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
      class: "font-display bg-base min-h-screen w-full min-w-0 text-text flex text-justify",
    ),
  )[

    #html.elem("div", attrs: (class: "flex-none bg-base min-w-1/20"))[ ]
    #html.elem("div", attrs: (
      class: "hidden 2xl:block 2xl:flex-auto bg-base",
    ))[ ]

    #html.elem("div", attrs: (class: "flex-1 sm:p-8 min-w-0"))[

      #footer()

      #html.elem(
        "article",
        attrs: (
          class: "max-w-[90ch] leading-relaxed [&>p]:p-2 break-words overflow-x-auto",
        ),
      )[
        #contents
      ]

      #separator(16)
      #html.elem("div", attrs: (
        class: "flex-none p-2 min-w-fit font-mono text-xs font-bold",
      ))[
        #list(..entries.map(it => entry-to-html(it)))
      ]

      #linebreak()
      #linebreak()
      #footer()

    ]

    // spacing
    #html.elem("div", attrs: (
      class: "hidden 2xl:block 2xl:flex-auto bg-base",
    ))[ ]
    #html.elem("div", attrs: (class: "flex-none bg-base min-w-1/20"))[ ]
  ]
}


#let img(path) = {
  html.elem("img", attrs: (
    class: "max-w-xl block rounded-md p-4 mx-auto",
    src: path,
  ))[]
}
