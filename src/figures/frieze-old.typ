#import "@preview/cetz:0.4.2"
#import cetz.draw: *

#show text: it => smallcaps(it)
#set page(width: auto, height: auto)

#let domain = {
  let tolerance = 0.05
  set-style(stroke: color.blue)
  line((tolerance, tolerance), (1.0 - tolerance, 1.0 - tolerance), stroke: 2pt)
  set-style(stroke: color.red)
  line((0.5, 0.8), (1.0 - tolerance, 1.0 - tolerance))
  set-style(stroke: color.black)
  line((0.8, 0.5), (1.0 - tolerance, 1.0 - tolerance))
}

#let frieze(n, start, mode, draw-grid: false, x-step: 1) = {
  cetz.canvas({
    set-style(stroke: color.blue)
    translate(start)
    if draw-grid {
      grid(
        (0, 0),
        (n, 1),
        stroke: red.transparentize(80%),
      )
    }

    let i = 0
    let angles = (0deg, 180deg)
    let transform = if mode == "hop" {
      ang => ()
    } else if mode == "sidle" {
      ang => (rotate(y: ang, origin: (0.5, 0.5)))
    } else if mode == "step" {
      ang => (rotate(x: ang, origin: (0.5, 0.5)))
    } else if mode == "spinning sidle" {
      ang => (rotate(y: ang, origin: (0.5, 0.5)))
    } else if mode == "spinning hop" {
      ang => (rotate(z: ang, origin: (0.5, 0.5)))
      // ang => {
      //   if ang == 180deg {
      //     translate(x: -1)
      //     rotate(z: ang, origin: (0.5, 0.0))
      //   } else {
      //     // translate(x: -0.5)
      //     rotate(z: ang, origin: (0.5, 0.0))
      //   }
      // }
    }

    while i < n {
      let ang = calc.rem(i, angles.len())

      transform(angles.at(ang))
      domain
      transform(angles.at(-ang))

      translate(x: x-step)

      i += 1
    }
  })
}


hop
#frieze(8, (0, 0), "hop")
spinning hop
// #frieze(16, (0, 4), "spinning hop", x-step: 0.5)
#frieze(8, (0, 4), "spinning hop")
step
#frieze(8, (0, 10), "step")
sidle
#frieze(8, (0, 2), "sidle")
spinning sidle
#frieze(8, (0, 2), "spinning sidle")

