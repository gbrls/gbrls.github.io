#import "@preview/cetz:0.4.2"
#set page(fill: color.black)

#cetz.canvas({
  import cetz.draw: *

  set-style(stroke: color.white)
  // set-style(fill: color.white)

  set-style(fill: color.white)
  arc((2, 0), start: 0deg, stop: 300deg, mode: "PIE", anchor: "origin")
  arc((6, 0), start: 240deg, stop: 540deg, mode: "PIE", anchor: "origin")
  arc((4, -3.14), start: 120deg, stop: 420deg, mode: "PIE", anchor: "origin")

  set-style(stroke: color.blue)
  line((4, 1), (3, -1))
})
