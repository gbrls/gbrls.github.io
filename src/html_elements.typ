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

  show raw.where(lang: none): it => [
    #html.elem("span", attrs: (
      class: "text-peach bg-mantle p-1 rounded-md",
    ))[#it]
  ]

  show heading: it => [
    #html.elem("div", attrs: (class: "text-mauve text-3xl p-8"))[
      #it
    ]
  ]

  show link: it => [
    #html.elem("span", attrs: (class: "text-blue"))[#it]
  ]

  set raw(theme: "./mocha.tmTheme")

  // ========== body =======


  html.elem("div", attrs: (
    class: "font-display bg-base min-h-screen text-text flex flex-wrap",
  ))[

    #html.elem("div", attrs: (class: "flex-none bg-mantle min-w-1/20"))[ ]
    #html.elem("div", attrs: (class: "flex-auto bg-mantle"))[ ]

    #html.elem("div", attrs: (class: "flex-none p-4"))[
      #html.elem("article", attrs: (
        class: "max-w-[90ch] leading-relaxed [&>p]:p-2 break-words",
      ))[
        #contents
      ]

      #html.elem("div", attrs: (class: "mt-4 mb-4"))[
        #html.frame()[
          #separator(16)
        ]
      ]

      #list(..entries.map(it => entry-to-html(it)))
    ]

    // spacing
    #html.elem("div", attrs: (class: "flex-auto bg-mantle"))[ ]
    #html.elem("div", attrs: (class: "flex-none bg-mantle min-w-1/20"))[ ]
  ]
}


#let img(path) = {
  html.elem("img", attrs: (
    class: "max-w-xl block rounded-md p-4 mx-auto",
    src: path,
  ))[]
}
