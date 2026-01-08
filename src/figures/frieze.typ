#import "@preview/cetz:0.4.2"
#import cetz.draw: *

#show text: it => smallcaps(it)
#set page(width: auto, height: auto)

#let fish = {
  let tolerance = 0.0
  set-style(stroke: color.red)
  line(
    (tolerance, tolerance),
    (1.0 - tolerance, 1.0 - tolerance),
    (0.75, 1.),
    (0.5, 0.9),
    fill: color.red,
    close: true,
  )
  set-style(stroke: color.blue)

  line(
    (tolerance, tolerance),
    (1.0 - tolerance, 1.0 - tolerance),
    (0.9, 0.5),
    stroke: 1pt,
    fill: color.blue,
    close: true,
  )
  circle(
    (.0 - tolerance, .0 - tolerance),
    radius: 0.05,
    fill: color.black,
    stroke: color.black,
  )
}

#let trig = {
  line((0.0, 0.2), (0.5, 1.0), (1.0, 0.2))
  line((0.0, 0.5), (0.5, 0.0), (1.0, 0.5), stroke: 2pt)
  circle((0.85, 0.0), radius: 0.12, stroke: 1.5pt + color.black)
}

#let domain = {
  set-style(stroke: color.rgb(180, 190, 254))
  line(
    // (0.0, 0.75),
    (0.0, 0.1),
    (0.25, 0.1),
    (0.25, 0.75),
    (0.75, 0.75),
    (0.75, 0.40),
    (0.55, 0.40),
    (0.55, 0.60),
    (0.35, 0.60),
    (0.35, 0.1),
    (0.35, 0.1),
    (1.0, 0.1),
    // (1.0, 0.75),
    stroke: 1.2pt,
  )
  circle(
    (0, 0.5),
    radius: 0.1,
    fill: color.rgb(235, 160, 172),
    stroke: color.rgb(235, 160, 172),
  )
  circle((1.0, 0.0), radius: 0.2, fill: color.rgb(180, 190, 254))
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
    let c = (0.5, 0.5)
    let transforms = (
      "hop": (i => (translate(x: x-step)),),
      "spinning hop": (
        i => {
          translate(x: x-step)
          rotate(z: i * 180deg, origin: c)
        },
        i => {
          translate(x: -x-step)
          rotate(z: i * 180deg, origin: c)
        },
      ),
      "step": (
        i => {
          rotate(x: i * 180deg, origin: c)
          translate(x: x-step)
        },
      ),
      "sidle": (
        i => {
          translate(x: x-step)
          rotate(y: i * 180deg, origin: c)
        },
        i => {
          translate(x: -x-step)
          rotate(y: i * 180deg, origin: c)
        },
      ),
      "spinning sidle": (
        i => {
          translate(x: x-step)
          rotate(y: i * 180deg, origin: c)
        },
        i => {
          translate(x: -x-step)
          rotate(z: i * 180deg, origin: c)
        },
        i => {
          translate(x: x-step)
          rotate(y: i * 180deg, origin: c)
        },
        i => {
          translate(x: -x-step)
          rotate(z: i * 180deg, origin: c)
        },
        // i => {
        //   translate(x: x-step)
        //   rotate(z: i * 180deg, origin: c)
        // },
        // i => {
        //   translate(x: x-step)
        //   rotate(x: i * 180deg, origin: c)
        // },
      ),
      "jump": (
        i => {
          translate(y: -x-step)
          rotate(x: i * 180deg, origin: c)
          translate(x: x-step)
        },
        i => {
          rotate(x: i * 180deg, origin: c)
          translate(y: x-step)
        },
      ),
      "spinning jump": (
        i => {
          translate(x: -x-step)
          rotate(y: i * 180deg, origin: c)
        },
        i => {
          rotate(x: i * 180deg, origin: c)
          translate(y: x-step)
        },
        i => {
          translate(y: -x-step)
          rotate(z: i * 180deg, origin: c)
          translate(x: -x-step)
        },
        i => {
          rotate(x: i * 180deg, origin: c)
          translate(y: x-step)
        },
      ),
    )

    while i < n {
      let it = calc.rem(i, transforms.at(mode).len())

      transforms.at(mode).at(it)(1)
      domain
      // translate(x: x-step)

      i += 1
    }
  })
}

#let n = 40

#frieze(n, (0, 0), "hop")
#frieze(n * 2, (0, 14), "spinning jump")
#frieze(n, (0, 4), "spinning hop")
#frieze(n, (0, 10), "step")
#frieze(n, (0, 2), "sidle")
#frieze(n * 2, (0, 12), "jump")
#frieze(n, (0, 2), "spinning sidle")
