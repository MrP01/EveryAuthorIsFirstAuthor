// Compile from the repo root: typst compile --root . demo/<file>.typ
// Self-check: every rendered name must have the common width W*, in every mode.
#import "../lib/equalauthors.typ": *
#set page(width: 20cm, height: auto)
#let names = (
  "Peter Waldert", "Benedikt Kantz", "Thomas Köhler",
  "Erik D. Demaine", "Martin L. Demaine", "Jesús Salvador Martínez Alcaide",
)
#let modes = (
  (:),
  (beta: 4.0, smin: 0.5, smax: 1.5),
  (fix_t: true),
  (fix_s: true),
)
#context for opts in modes {
  let W = optimal-width(names, ..opts)
  for n in names {
    let m = measure(render(n, W, ..opts)).width
    assert(calc.abs(m.pt() - W.pt()) < 1e-4, message: n + ": " + repr(m) + " != " + repr(W))
    let r = solve(n, W, ..opts)
    if opts.at("fix_t", default: false) { assert(r.t == 0pt, message: n + ": t != 0") }
    if opts.at("fix_s", default: false) { assert(r.s == 1, message: n + ": s != 1") }
    [#repr(opts) #n: #m (target #W, s = #calc.round(r.s, digits: 4)) \ ]
  }
}
OK
