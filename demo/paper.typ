// A small paper-shaped example.
// Compile from the repo root: typst compile --root . demo/paper.typ
#import "../lib/equalauthors.typ": *

#show: equal-references          // superimpose the authors in the references
#set page(paper: "a4", margin: 2.5cm)
#set text(11pt, font: "Libertinus Serif")
#set par(justify: true)
#set heading(numbering: "1.")

#let authors = ("Peter Waldert", "Benedikt Kantz", "Thomas Köhler",)

#align(center)[
  #text(17pt, weight: "bold")[A Paper With No First Author]
  #v(1em)
  #text(12pt, eqa-authors(authors))
  #v(0.5em)
  #text(10pt, datetime.today().display())
]

#v(1em)

#align(center)[
  #block(width: 85%)[
    *Abstract.* Every author of this document is a first author: the three
    names above are superimposed, and each has been distorted to exactly the
    same width so that no name frames or hides inside another.
  ]
]

= Introduction

The superimposition standard @demaine2023every removes author order but leaves
author width, which the reader still reads as a ranking. Equalising the widths
closes that gap. Each name is set with a horizontal glyph scale $s_i$ and a
tracking $t_i$ chosen so that $s_i w_i + g_i t_i = W^*$, where
$W^* = (sum_i w_i \/ K_i) \/ (sum_i 1 \/ K_i)$ is the stiffness-weighted mean
of the natural widths.

Unstacked, the author block above is:

#align(center, eqa-authors-stacked(authors))

All three lines have the same width
#context [$W^* = #calc.round(optimal-width(authors).pt(), digits: 2)$ pt].

= Citations

The standard applies to reference lists too, since those rank authors exactly
as a title page does. A name list can be superimposed inline with `eqa-list`;
the authors of @demaine2023every, for instance, are

#align(center, eqa-list("Erik D. Demaine and Martin L. Demaine"))

The reference list below gets the same treatment automatically: the citation
style `equalauthors.csl` fences each entry's author list, and the
`equal-references` show rule superimposes it.

#bibliography("sources.bib", style: "../lib/equalauthors.csl")
