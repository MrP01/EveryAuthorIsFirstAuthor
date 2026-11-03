# Truly Every Author is First Author

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="demo/teaser-dark.png">
  <img alt="Five author names superimposed naively, where the longest name sticks out, and at equal width, with scale and tracking or with tracking only; right, both equal-width versions unstacked." src="demo/teaser.png">
</picture>

[![DOI](https://img.shields.io/badge/DOI-10.48550%2FarXiv.2611.01331-blue)](https://doi.org/10.48550/arXiv.2611.01331)

An original work by Demaine & Demaine ([arXiv:2304.01393](https://arxiv.org/abs/2304.01393)) proposed that every author be a first author by printing all names on top of each other. But names have different widths, so the longest name still dominates the block, and a short name hides inside a long one. That brings the ranking back.

This repo fixes that. Each name is stretched or squeezed, using a horizontal glyph scale `s` and a letter tracking `t`, until all names have one common width `W*`. The distortion is chosen to be as small as possible:

- for a fixed width, the best `(s, t)` for each name has a closed form (Lagrange multipliers);
- the best common width `W*` is a weighted mean of the natural widths, `W* = (Σ wᵢ/Kᵢ) / (Σ 1/Kᵢ)`.

It ships as a LaTeX package, a Typst package, a paper, and a Lean proof of every proposition in the paper.

**Read the paper here**: [arXiv:2611.01331](https://arxiv.org/abs/2611.01331).

## Layout

| Path                     | What                                                                                                   |
| ------------------------ | ------------------------------------------------------------------------------------------------------ |
| `lib/equalauthors.sty`   | LaTeX package (pdfLaTeX or LuaLaTeX; needs `microtype`)                                                |
| `lib/equalauthors.typ`   | Typst package                                                                                          |
| `lib/equalauthors.csl`   | Citation style that lets Typst superimpose bibliography authors                                        |
| `demo/`                  | Small LaTeX and Typst examples, a Typst self-check, and `teaser.typ` (the image above, light and dark) |
| `paper/`                 | The paper (`main.tex`) and an arXiv packaging script                                                   |
| `lean/EqualAuthors.lean` | Lean 4 + Mathlib formalisation                                                                         |

## LaTeX

```latex
\usepackage{equalauthors}            % put lib/ on the TeX path

\equalauthorsAddAuthor{Erik D. Demaine}
\equalauthorsAddAuthor{Martin L. Demaine}
\author{\equalauthorsAuthors}
```

| Command                       | Does                                    |
| ----------------------------- | --------------------------------------- |
| `\equalauthorsAuthors`        | All authors superimposed                |
| `\equalauthorsAuthorsStacked` | Same widths, one per line, for checking |
| `\equalauthorsList{A and B}`  | Superimpose a BibTeX-style name list    |
| `\equalauthorsWidth`          | The common width `W*` in pt             |
| `\equalauthorsSolution{Name}` | One name's `w & s & t`, as table cells  |
| `\equalauthorsSetup{...}`     | Set options (below)                     |
| `\equalauthorsClear`          | Empty the author list                   |

To superimpose cited authors too, wrap the `.bib` author field in an extra pair of braces:

```bibtex
author = {{\equalauthorsList{Erik D. Demaine and Martin L. Demaine}}}
```

See `demo/demo.tex`. It compiles from `demo/` or from the repo root, so it also works on Overleaf.

## Typst

```typst
#import "lib/equalauthors.typ": *

#eqa-authors(("Erik D. Demaine", "Martin L. Demaine"))
```

| Function                             | Does                                                                         |
| ------------------------------------ | ---------------------------------------------------------------------------- |
| `eqa-authors(names, ..opts)`         | All names superimposed                                                       |
| `eqa-authors-stacked(names, ..opts)` | Same widths, one per line, with a rule on the left (`rule:` sets its colour) |
| `eqa-list("A and B", ..opts)`        | Superimpose a BibTeX-style name list                                         |
| `optimal-width(names, ..opts)`       | `W*` (needs `context`)                                                       |
| `solve(name, W, ..opts)`             | One name's `(s, t)`                                                          |
| `equal-references`                   | Show rule that superimposes bibliography authors                             |

For the bibliography, use the bundled citation style:

```typst
#show: equal-references
#bibliography("sources.bib", style: "lib/equalauthors.csl")
```

Run the examples from the repo root:

```sh
typst compile --root . demo/paper.typ
typst compile --root . demo/check.typ   # fails if any name misses W*
```

## Options

Both packages take the same options.

| Option         | Default        | Meaning                                           |
| -------------- | -------------- | ------------------------------------------------- |
| `alpha`        | `1`            | Cost of glyph scaling. Higher means less scaling. |
| `beta`         | `1`            | Cost of tracking. Higher means less tracking.     |
| `smin`, `smax` | `0.85`, `1.15` | Bounds on the scale `s`                           |
| `fix_t`        | `false`        | Scale only, no tracking                           |
| `fix_s`        | `false`        | Track only, no scaling (`s = 1`)                  |

## Proofs

```sh
lake exe cache get         # Mathlib build cache
lake build
```

Each theorem is named after its label in the paper (`prop_split`, `prop_width`, `eq_clamp`, `eq_problem`, `abl_scale`, ...). Lean `v4.33.1`.

## Citation

```bibtex
@misc{2026-truly-every-author-is-first-author,
  author        = {Peter Waldert and Benedikt Kantz and Thomas K{\"o}hler},
  title         = {Truly Every Author is First Author: Equal-Width Superimposition by Minimising Visual Distortion},
  year          = {2026},
  eprint        = {2611.01331},
  archiveprefix = {arXiv},
  primaryclass  = {cs.DL},
  doi           = {10.48550/arXiv.2611.01331}
}
```

## License

MIT, see [LICENSE](LICENSE).
