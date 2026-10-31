// README teaser, light and dark (transparent background).  From the repo root:
//   typst compile --root . --ppi 400 demo/teaser.typ demo/teaser.png
//   typst compile --root . --ppi 400 --input theme=dark demo/teaser.typ demo/teaser-dark.png
#import "../lib/equalauthors.typ": *
#let dark = sys.inputs.at("theme", default: "light") == "dark"
// GitHub's dark-mode text and link colours
#let (ink, muted, rule) = if dark { (rgb("#e6edf3"), luma(150), rgb("#58a6ff")) } else { (black, luma(110), eqa-rule-color) }
#set page(width: auto, height: auto, margin: 12pt, fill: none)
#set text(16pt, font: "Libertinus Serif", fill: ink)

#let names = ("Peter Waldert", "Benedikt Kantz", "Thomas Köhler", "Erik D. Demaine", "Martin L. Demaine")
#let label(it) = text(9pt, fill: muted, style: "italic", it)

#let naive(names) = context box(
  width: calc.max(..names.map(n => measure(n).width.pt())) * 1pt,
  names.map(n => place(n)).join() + hide(names.first()),
)

#let default = (:)
#let track-only = (fix_s: true) // ablation A.2 of the paper

// the three superimpositions on the left, both equal-width versions unstacked on the right
#let panel(title, body, gap: 0pt) = stack(spacing: 8pt + gap, label(title), body)
#let right = (
  panel([Scale and tracking, unstacked], eqa-authors-stacked(names, rule: rule, ..default)),
  panel([Tracking only, unstacked], eqa-authors-stacked(names, rule: rule, ..track-only)),
)
// the left column is stretched to the height of the right ones
#context grid(
  columns: 3,
  column-gutter: 32pt,
  // gap and bottom inset match the rule's overhang, so first and last baselines line up
  block(height: measure(right.first()).height, inset: (bottom: 0.35em), stack(
    panel([Naive superimposition], naive(names), gap: 0.2em),
    v(1fr),
    panel([Equal width, scale and tracking], eqa-authors(names, ..default), gap: 0.2em),
    v(1fr),
    panel([Equal width, tracking only ($s = 1$)], eqa-authors(names, ..track-only), gap: 0.2em),
  )),
  ..right,
)
