#import "@preview/cetz:0.4.2"
#set page(fill: color.black, width: auto, height: auto)

#let day1 = {
  cetz.canvas({
    import cetz.draw: *

    set-style(stroke: color.white)
    let phi = 0.9
    let n = 8
    while phi < n {
      let i = 0
      while i < (n - phi) {
        let x = calc.sin(i)
        let y = calc.cos(i)
        circle((x, y + phi * 5), radius: phi)
        i = i + 0.5
      }
      phi = phi + 1
    }
  })
}

#day1
