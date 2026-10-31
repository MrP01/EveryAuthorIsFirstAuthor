// Compile from the repo root: typst compile --root . demo/<file>.typ
#import "../lib/equalauthors.typ": *
#set page(width: 12cm, height: auto, margin: 1cm)
#set text(14pt)

#let names = (
  "Peter Waldert",
  "Benedikt Joachim Kantz",
  "Thomas Köhler",
  "Erik D. Demaine",
  "Martin L. Demaine",
  "Y Wuuuuuuuuuu",
  "Donaudampfschiffskapitän",
  "Jesus Salvador Martinez Alcaide",
  "Yu Liu",
)

*Stacked (all should be equal width):*
#eqa-authors-stacked(names, beta: 1)
#context [W\* = #optimal-width(names)]

*Stacked with $t=0$ (all should be scaled freely, but no inter-character adjustments applied):*\
#eqa-authors-stacked(names, fix_t: true)
#context [W\* = #optimal-width(names, fix_t: true)]
#eqa-authors-stacked(names, alpha: 1e-5)
#context [W\* = #optimal-width(names, alpha: 1e-5)]

*Stacked with $s=1$ (all should be scaled equally, only no inter-character adjustments applied):*
#eqa-authors-stacked(names, fix_s: true)
#context [W\* = #optimal-width(names, fix_s: true)]
#eqa-authors-stacked(names, beta: 1e-5)
#context [W\* = #optimal-width(names, beta: 1e-5)]
#v(1em)

*Superimposed:*
#eqa-authors(names)
#v(1em)

#context [W\* = #optimal-width(names)]
#v(1em)

*From a BibTeX-style name list:*
#eqa-list("Erik D. Demaine and Martin L. Demaine")
