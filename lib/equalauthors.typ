// equalauthors -- equal-width superimposed author names.
// Extends "every author as first author" (Demaine & Demaine, arXiv:2304.01393)
// by forcing every superimposed name to one common width, trading glyph
// scaling (s) against letter tracking (t).

#let _clamp(x, lo, hi) = calc.min(calc.max(x, lo), hi)

// Natural width w, cluster count c, gap count g, stiffness K.
#let _stats(name, alpha, beta, fix_t, fix_s) = {
  let w = measure(name).width.pt()
  let c = calc.max(name.clusters().len(), 1)
  // no tracking is the same as no gaps: K = w^2/alpha, t = 0, s = W/w
  let g = if fix_t { 0 } else { c - 1 }
  let e = w / c
  let K = w * w / alpha + g * g * e * e / beta
  if fix_s {
    K = g * g * e * e / beta
  }
  (w: w, g: g, K: K)
}

// W* = (sum w_i/K_i) / (sum 1/K_i): the cost-minimising common width.
// The bounds (smin, smax) only matter per name, so they are accepted and ignored.
#let optimal-width(names, alpha: 1.0, beta: 1.0, fix_t: false, fix_s: false, ..bounds) = {
  let st = names.map(n => _stats(n, alpha, beta, fix_t, fix_s))
  st.map(x => x.w / x.K).sum() / st.map(x => 1.0 / x.K).sum() * 1pt
}

// Per-name solution (s, t) for a given common width W.
#let solve(name, W, alpha: 1.0, beta: 1.0, smin: 0.85, smax: 1.15, fix_t: false, fix_s: false) = {
  let x = _stats(name, alpha, beta, fix_t, fix_s)
  let lam = (W.pt() - x.w) / x.K
  let s = _clamp(1.0 + lam * x.w / alpha, smin, smax)
  if fix_s {
    s = 1
  }
  if x.g == 0 { (s: W.pt() / x.w, t: 0pt) } else { (s: s, t: (W.pt() - s * x.w) / x.g * 1pt) }
}

// The distorted name itself; its natural width should already be W.
#let render(name, W, ..args) = {
  let r = solve(name, W, ..args)
  scale(x: r.s * 100%, reflow: true, origin: left, text(tracking: r.t / r.s, name))
}

// One name typeset to width W (boxed, so rounding cannot leak into layout).
#let eqa-name(name, W, ..args) = box(width: W, render(name, W, ..args))

// All names superimposed, all exactly W wide.
#let eqa-authors(names, ..args) = context {
  let W = optimal-width(names, ..args.named())
  box(width: W, names.map(n => box(width: 0pt, eqa-name(n, W, ..args))).join())
}

// A BibTeX-style name list "A and B and C", superimposed -- the citation
// counterpart of eqa-authors.
#let eqa-list(names, ..args) = eqa-authors(names.split(" and "), ..args)

// Same widths, one per line -- for inspection, with a coloured rule down the
// left edge (the same colour as the LaTeX package's).
#let eqa-rule-color = rgb(15%, 35%, 75%)
#let eqa-authors-stacked(names, rule: eqa-rule-color, ..args) = context {
  let W = optimal-width(names, ..args.named())
  block(
    stroke: (left: 0.3pt + rule),
    // overhang as in LaTeX, where the tabular struts reach past cap height and baseline
    inset: (left: 4pt, top: 0.2em, bottom: 0.35em),
    stack(dir: ttb, spacing: 0.6em, ..names.map(n => eqa-name(n, W, ..args))),
  )
}

// ---------------------------------------------------------------------------
// Bibliographies.  Typst exposes no element for the author list of a
// reference, so the hook is put in the citation style instead:
// lib/equalauthors.csl is a numeric style that fences each reference's author
// list between two invisible U+2062 characters.  Applying this show rule
// superimposes exactly those runs and nothing else.
//
//   #show: equal-references
//   #bibliography("sources.bib", style: "../lib/equalauthors.csl")
#let _fence = "\u{2062}"
#let equal-references(body, ..args) = {
  show regex("\u{2062}[^\u{2062}]+\u{2062}"): it => eqa-list(
    it.text.replace("\u{2062}", ""),
    ..args,
  )
  body
}
