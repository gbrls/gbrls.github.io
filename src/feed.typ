#import "lib.typ": entries

#let base = "https://0x4200.cafe/"

#for e in entries {
  html.elem("item")[

    #html.elem("title")[
      #text(e.name)
    ]

    #html.elem("h1")[
      #text(base + e.file.replace(".typ", ".html").replace("./", ""))
    ]

  ]
}
