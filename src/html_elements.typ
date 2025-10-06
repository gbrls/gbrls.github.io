#import "entries.typ": entries

#let entry-to-html(entry) = {
  let path = entry.file.replace(".typ", ".html")
  link(path)[#text(entry.name)]
}

#let page(contents) = {
  html.elem("head")[
    #html.elem("meta", attrs: (charset: "UTF-8"))
    #html.elem("title")[0x4200.cafe]
    #html.elem("link", attrs: (rel: "stylesheet", href: "style.css"))
  ]
  contents

  list(..entries.map(it => entry-to-html(it)))
}

