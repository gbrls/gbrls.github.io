#import "lib.typ": entries, separator

#let entry-to-html(entry) = {
  let path = entry.file.replace(".typ", ".html")
  let pad = "." * 28

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


#html.elem("head")[
  #html.elem("meta", attrs: (charset: "UTF-8"))
  #html.elem("title")[0x4200.cafe]
  #html.elem("link", attrs: (rel: "stylesheet", href: "style.css"))
]

#html.frame()[
  #separator(16)
]

#list(..entries.map(it => entry-to-html(it)))
