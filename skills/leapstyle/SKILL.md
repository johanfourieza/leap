---
name: leapstyle
description: Apply the LEAP Economics house style to LaTeX papers, beamer slides, R figures, or academic writing and editing. Covers the article preamble, AER paper structure, introduction and conclusion formulas, colour palette, graph theme and comprehensive writing and editing guidelines. This is the design skill, used while a paper is being written; to package a finished paper as a circulated working paper and file it on the shelf, use /leapwp.
user-invocable: true
argument-hint: <paper|slides|graph|writing> [filename]
---

# LEAP Style Guide

The unified visual identity for Johan Fourie's research group (LEAP, Stellenbosch University).
Covers four outputs: **papers** (LaTeX article), **presentations** (LaTeX beamer), **figures** (R / ggplot2) and **writing** (academic prose editing).

This is the skill for shaping a paper while it is being written: how it is
structured, how it looks, how it reads. Load it at the start of a project and
whenever a draft needs work.

**Its companion is `/leapwp`.** When a paper is finished and needs to become a
circulated working paper -- title footnote, acknowledgements, AI disclosure,
cite-as line, `aea` bibliography, versioned filename, clean build, and the copy
into `1Research\WorkingPapers\` -- that is `/leapwp`, not this skill. Nothing
here writes a front page or files anything on the shelf.

## Usage

```
/leapstyle paper myfile.tex        # apply the article preamble, structure and formatting
/leapstyle slides myfile.tex       # apply the beamer slide template
/leapstyle graph myscript.R        # apply the LEAP graph identity to an R script
/leapstyle writing myfile.tex      # apply LEAP writing and editing standards
/leapstyle                         # (no argument) describe all four styles
```

`/leapstyle paper` fits the preamble, checks the paper against the AER structure
below, and audits the introduction and conclusion against the formulas in Part 4.
It edits the file in place unless told otherwise, and it does not version, compile
or publish. Run `/leapwp` for that.

---

## Shared LEAP Colour Palette

All LEAP outputs draw from one palette. The first four colours are the workhorses; the rest are available when more categories are needed.

| Role        | Name  | Hex       | Use for                              |
|-------------|-------|-----------|--------------------------------------|
| Primary     | plum  | `#5C2346` | Main data series, bars, fills        |
| Secondary   | blue  | `#3D8EB9` | Second series, trend lines           |
| Tertiary    | sage  | `#6B8E5E` | Third category                       |
| Quaternary  | gold  | `#D4A03E` | Fourth category, highlights          |
| Extended    | rose  | `#A34466` | Fifth category                       |
| Extended    | teal  | `#45808B` | Sixth category                       |
| Extended    | earth | `#8B6B3D` | Seventh category                     |
| Extended    | mint  | `#97C5B0` | Eighth category, light fills         |
| UI accent   | maroon| `#7A0019` | Slide chrome (footlines, links) only |
| Utility     | grey  | `#AAAAAA` | Non-significant, reference lines     |

**Accessibility note.** Plum and rose, and sage and earth, can be hard to distinguish under deuteranopia. When a figure must work for colour-blind readers, limit the palette to plum + blue + gold + teal (these four are perceptually distinct across all common forms of colour vision deficiency) and supplement with line type or shape differences.

---

## Part 1: LaTeX Paper

The shape of a LEAP paper: preamble, section order, and the conventions that go
with them. The front page -- title footnote, acknowledgements, AI disclosure,
cite-as line -- is not here. It is added once, at the end, by `/leapwp`, so that
a paper in progress never carries a half-written citation for its own draft.

### Preamble

Replace the preamble of the target `.tex` file with the following, preserving the file's own `\title`, `\author`, `\date` and any custom commands used in its body.

```latex
\documentclass[11pt]{article}

% ---------- LEAP working paper setup ----------
\usepackage[T1]{fontenc}
\usepackage{lmodern}
\usepackage[margin=1in]{geometry}
\usepackage{setspace}
\onehalfspacing

\usepackage{amsmath,amssymb}
\usepackage{graphicx}
\usepackage{xcolor}
\usepackage{booktabs}
\usepackage{float}
\usepackage{caption}
\usepackage{hyperref}
\hypersetup{
  colorlinks=true,
  linkcolor=black,
  citecolor=black,
  urlcolor=black
}

% Bibliography / citations
\usepackage[authoryear,round]{natbib}
```

`fontenc` and `lmodern` are there for the posted PDF: without them the footnote
markers, quotation marks and en dashes are not recoverable when a reader copies
text out of the file. `lmodern` is metrically identical to Computer Modern, so
the paper looks the same and paginates the same.

### Front matter

While a paper is being written, keep the front matter minimal:

```latex
\title{Paper Title}
\author{Johan Fourie}
\date{}
```

Do not draft the title footnote here. The acknowledgements, the AI disclosure and
the cite-as line are written once, from the finished paper, by `/leapwp` -- which
also fills in the co-author affiliation footnotes. A draft that carries a
half-finished citation for itself is worse than one that carries none, because the
citation is the thing most likely to be copied out and reused unchecked.

Two rules do apply from the start, because they shape the paper rather than
decorate it:

1. Page 1 is `\maketitle`, the abstract, keywords and JEL codes, and nothing else.
2. `\newpage` goes before `\section{Introduction}`, so the body always starts on
   page 2.

Format keywords and JEL codes as:

```latex
\end{abstract}
\vspace{1em}\noindent\textbf{Keywords:} keyword1; keyword2; keyword3

\vspace{0.25em}
\noindent\textbf{JEL codes:} X00; Y00; Z00

\vspace{0.5em}
```

Leave `\date{}` empty. No date is printed, in a draft or on the shelf.

### Paper structure

Follow the shape of an AER paper. This is the default section order; depart from
it when the paper needs a different one, and say why.

1. **Introduction** -- built to the formula in Part 4.
2. **Background** -- the historical or institutional setting the design relies
   on. Omit it when the setting is familiar to the paper's readers.
3. **Data** -- sources, construction, coverage, and the measurement problems
   that come with them.
4. **Empirical strategy** -- the specification, the identifying assumption, and
   the threats to it.
5. **Results** -- main estimates first, then robustness.
6. **Mechanisms and heterogeneity** -- after the reader has absorbed the main
   result.
7. **Conclusion** -- built to the formula in Part 4.

Then References, then an appendix numbered A1, A2 and so on.

Conventions that go with this structure:

- **No separate literature-review section.** The literature belongs in the
  introduction's contribution paragraphs, where each cited work is tied to what
  this paper changes.
- **No separate limitations or scope section, ever.** See Part 4 for where each
  kind of limitation goes instead.
- **Robustness is not a section by default.** Fold it into Results, or move it
  to the appendix.
- **Tables and figures stand alone.** Every one carries a note giving the
  sample, the unit of observation and the standard-error clustering, so a reader
  who turns straight to it can read it.

### Bibliography

Cite with `natbib` in author-year form, and set the reference list in `aea.bst`, the
official American Economic Association style. It prints full first names, inverts the
first author and preserves title case.

```latex
\bibliographystyle{aea}
\bibliography{references}
```

Place both commands at the end of the document, before `\end{document}`.

Two things follow from this style, and both are handled by `/leapwp` when the paper
is packaged: `aea.bst` is not in the standard MiKTeX or TeX Live tree, so a copy has
to travel beside the `.tex`; and because `aea.bst` prints whatever the `.bib` holds,
every entry needs the authors' full given names rather than initials. Never expand an
initial from memory while drafting -- leave it, and let the packaging pass resolve it
against a source.

For a full adversarial audit of the `.bib` -- hallucinated references, chimeric
references, wrong years -- run `/kris`.

### General formatting

- **Paragraphs**: standard indentation (do NOT set `\parindent` to 0 or add `\parskip`). Line spacing is 1.5 via `\onehalfspacing`.
- **Figures**: use `\begin{figure}[htbp]` with `\centering` and `\includegraphics[width=\linewidth]{...}`.
- **Hyperlinks**: all black (formal, print-ready).

### Minimal working example

A paper in progress. The front page is deliberately bare: `/leapwp` fills it in when
the paper is finished.

```latex
\documentclass[11pt]{article}
\usepackage[T1]{fontenc}
\usepackage{lmodern}
\usepackage[margin=1in]{geometry}
\usepackage{setspace}
\onehalfspacing
\usepackage{amsmath,amssymb}
\usepackage{graphicx}
\usepackage{xcolor}
\usepackage{booktabs}
\usepackage{float}
\usepackage{caption}
\usepackage{hyperref}
\hypersetup{colorlinks=true,linkcolor=black,citecolor=black,urlcolor=black}
\usepackage[authoryear,round]{natbib}

\title{Writing in the Age of AI}
\author{Johan Fourie}
\date{}

\begin{document}
\maketitle

\begin{abstract}
\noindent Abstract text goes here.
\end{abstract}
\vspace{1em}\noindent\textbf{Keywords:} keyword1; keyword2

\vspace{0.25em}
\noindent\textbf{JEL codes:} N17; O10

\vspace{0.5em}

\newpage

\section{Introduction}
Body text begins on page two.

\begin{figure}[htbp]
\centering
\includegraphics[width=\linewidth]{Fig1_example.png}
\caption{Example figure produced with the LEAP graph identity.}
\label{fig:example}
\end{figure}

\bibliographystyle{aea}
\bibliography{references}

\end{document}
```

### Packaging and publication: use `/leapwp`

Everything that turns a styled paper into a posted one lives in `/leapwp`:

- the front matter intake -- co-authors, acknowledgements, the AI tools used;
- the title footnote, in its fixed order of acknowledgements, AI disclosure,
  cite-as line;
- the author block and its affiliation footnotes;
- installing `aea.bst` and auditing the `.bib` for full given names;
- the versioned filename, `JF_KS_WritingInThe_v2.tex`, written beside the file it
  was made from and never over it;
- supplements, versioned in lockstep with the paper they document;
- the clean four-pass build, and reading the compiled front page rather than
  trusting the source;
- the copy into `1Research\WorkingPapers\`, with any superseded version moved into
  `archive\`.

Do none of that from this skill. A paper can be restyled a dozen times during a
project; it should be versioned and shelved only when it is ready to circulate, and
keeping the two apart is what stops the shelf filling with drafts.

---

## Part 2: Beamer Slides

### Template preamble

Replace the **entire preamble** (everything before `\begin{document}`) of each target beamer file with the following, preserving only the file's own `\title`, `\subtitle`, `\author` and `\date` lines. If a file defines custom commands used in its body (e.g. `\newcommand{\source}[1]{\caption*{Source: {#1}}}`), keep those too, placed just before the title block.

```latex
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Beamer Presentation â€“ LEAP template
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\documentclass[aspectratio=169]{beamer}

\mode<presentation> {
\usetheme{Boadilla}
\usecolortheme{seagull}

% LEAP colour accents
\definecolor{leapMaroon}{HTML}{7A0019}
\setbeamercolor{author in head/foot}{bg=leapMaroon,fg=white}
\setbeamercolor{title in head/foot}{bg=leapMaroon,fg=white}
\setbeamercolor{date in head/foot}{bg=leapMaroon,fg=white}
\setbeamercolor{section in head/foot}{bg=leapMaroon,fg=white}
\setbeamercolor{subsection in head/foot}{bg=leapMaroon,fg=white}
\setbeamercolor{footline}{bg=leapMaroon,fg=white}
}

\newcommand\tinytiny{\fontsize{3}{7.2}\selectfont}
\renewcommand*{\bibfont}{\tiny}
\usepackage{multirow}
\usepackage{booktabs}
\usepackage{dcolumn}
\usepackage{amsmath}
\usepackage{caption}
\usepackage{float}
\usepackage[utf8]{inputenc}
\usepackage{setspace}
\usepackage{threeparttable}
\usepackage[maxcitenames=2, maxbibnames=5, date=year, doi=false, backend=bibtex, url=false, isbn=false, style=authoryear, uniquename=init,giveninits]{biblatex}
\usepackage{rotating}
\newcolumntype{d}{D{.}{.}{2.5}}
\newcommand\mc[1]{\multicolumn{1}{c}{#1}}
\usepackage{hyperref}
\hypersetup{
    colorlinks=true,
    linkcolor=leapMaroon,
    filecolor=leapMaroon,
    citecolor=leapMaroon,
    urlcolor=leapMaroon,
}
\urlstyle{same}

% Minimalist bibliography look
\setbeamertemplate{bibliography item}{}
\setbeamercolor{bibliography entry author}{fg=black}
\setbeamercolor{bibliography entry title}{fg=black}
\setbeamercolor{bibliography entry location}{fg=black}
\setbeamercolor{bibliography entry note}{fg=black}

\bibliography{bibliography.bib}
```

### Transformation rules

When converting an existing beamer file:

1. **Preamble**: Replace everything before the `\title` line with the template preamble above. Remove all commented-out `\usetheme` and `\usecolortheme` lines.
2. **Title block**: Keep the file's `\title`, `\subtitle`, `\author` and `\date` lines. Update `\date` to the current year if it is outdated.
3. **Logo**: Replace any logo path (`LEAP SU logo colour on white transparent.png`, `LEAP icon colour on white transparent.png`, or variants with `Figures/` or `Pictures/` prefixes) with `Pictures/LEAPlogo.png`.
4. **Image paths**: Change all `{Figures/...}` references to `{Pictures/...}`.
5. **Image sizing**: Never use `scale=` for content images (only for the logo). Use `height=0.7\paperheight,keepaspectratio` for standalone images, `height=0.60\paperheight,keepaspectratio` for images with captions and `height=0.55\paperheight,keepaspectratio` for images in columns.
6. **References frame**: If the file has a references frame, keep it as `\begin{frame}[allowframebreaks]{References}\printbibliography\end{frame}`.
7. **Non-beamer files**: If a `.tex` file uses `\documentclass{article}` or similar (not beamer), apply the working paper template from Part 1 instead.

### Content style guide

Apply these rules to every slide's content for a clean, effective academic presentation.

#### Action titles (non-negotiable)

Every content slide title must be a **complete sentence stating the takeaway** -- not a topic label. This is the single most important formatting rule.

| Instead of (topic label) | Use (action title) |
|--------------------------|-------------------|
| Results | Treatment effect is significant across all three cohorts |
| Literature Review | Prior work leaves the causal mechanism unexplained |
| Data | Dataset covers 40 years of county-level panel data |
| Methodology | Regression discontinuity exploits a sharp funding threshold |

**Ghost deck test:** Read only the action titles in sequence. They should tell the complete argument. If they don't, the deck's logic needs repair -- fix the titles or restructure before building.

Title length: one to two lines. If more is needed, the point is not sharp enough yet. Title font: 24--28 pt, bold.

#### Argument structure

- **One argument per presentation.** Choose the claim that can be made convincingly in the available time. Everything else belongs in the appendix.
- **Each slide has one job.** If a slide is doing two things, split it.
- **Flow test:** After outlining, read slide titles in order. Each should make the next one feel like a natural consequence. If a slide feels disconnected, it is misplaced or dispensable.
- **Research question on screen by slide 2 or 3.** State it explicitly and give it its own slide so the audience can orient.

#### Deck architecture

Required slides for a complete academic presentation, in this order:

1. **Title slide** -- full title (statement or question, not just a topic), author(s), affiliations, venue, date.
2. **Motivation / Context** (1--2 slides) -- why the problem matters; the gap or puzzle.
3. **Research question** (1 slide) -- stated explicitly on its own slide.
4. **Methods** (1--2 slides) -- only what the audience needs to evaluate the findings. Detail belongs in the appendix.
5. **Results** (as many as needed) -- one finding per slide, one exhibit per slide, action title states the finding.
6. **Discussion / Implications** (1--2 slides) -- interpret findings, connect back to the research question, address the main limitation(s) directly.
7. **Conclusions** (1 slide) -- 2--4 bullet points restating key takeaways. **This slide stays on screen during Q\&A.** Do NOT follow it with ``Thank You'' or a blank slide.
8. **References** -- complete citations for all sources cited in the deck.
9. **Appendix** (clearly labelled) -- pre-built Q\&A slides anticipating likely audience questions, robustness checks, additional data.

#### Timing and slide budget

Maximum one slide per minute. Typical budgets:
- 10-minute talk: 8--10 content slides (title + references excluded)
- 15-minute talk: 12--14 content slides
- 20-minute talk: 15--18 content slides
- 45-minute seminar: 30--40 slides

Know in advance which slides to skip if time runs short. Methods and context compress first; the research question, key result and conclusions are non-negotiable.

#### Exhibit discipline

- **One exhibit per slide.** One chart, table, diagram, equation block or map. If you need two charts to make a point, consider whether they are really one comparison (combine) or two points (two slides).
- **Every exhibit must earn its place.** Cover the exhibit and read the title -- does the title still make sense without it? If yes, the exhibit is not necessary.
- **Annotate the key finding directly on the chart.** Mark the key data point with a call-out arrow, highlighted region, text annotation (e.g. ``$\uparrow$ 23\% above baseline'') or a distinct visual treatment for the focal series. Do not make the audience search.
- **Self-sufficient slide test:** Could someone understand the key point from this slide without hearing the narration? If not, add an annotation.
- **Figure placement:** Place figures on the **left side** of the slide; interpretive bullets on the **right**. Evidence first, interpretation second.
- **Prefer graphs over tables for results.** Tables require more cognitive load under time pressure. Reserve tables for precise numerical comparisons where exact values matter.
- **Rebuild figures from your paper.** Paper figures are too small and use print-resolution fonts. Rebuild at presentation resolution with axis labels $\geq$ 16 pt.
- **Don't include exhibits you won't discuss.** If you won't have time, move it to the appendix.

#### Text density
- **Max $\sim$40 words of body text per slide.** If you need more, the slide is doing too much -- split it or move content to the appendix.
- **Max 5 bullets** per slide. If a slide has 6+, split it into two frames or trim to essentials.
- **Max 2 levels** of nesting (main bullet + one sub-level). Never use a third level; flatten it up or split the slide.
- Each bullet should be **1 line, max 2**. If longer, tighten the wording or break into sub-bullets.
- Bullets are orientation cues, not information transfer. Each bullet contains one idea.
- **Body font: 20 pt minimum.** If text must be smaller than 20 pt to fit, remove content until it fits at 20 pt.

#### Bold usage
- Use `\textbf{}` for **1--2 key terms per slide** as visual anchors.
- Pattern: `\textbf{Key term}: short explanation` (bold the concept, not the explanation).
- Bold only 1--3 words. Never bold full sentences or long phrases.
- Every content slide should have at least one bold term so the audience can scan.

#### Italics
- Use `\textit{}` only for: direct quotes, book/paper titles, foreign-language terms and statistical notation.
- Do not use italics for emphasis; use bold for that.

#### General tone
- Write for the listener, not the reader. Slides are prompts for the presenter, not a textbook.
- Telegraphic language is acceptable. Omit articles and filler phrases where meaning is preserved (e.g. ``Intervention reduced costs by 23\% ($p < 0.01$)'' not ``Our study found that the intervention reduced costs significantly'').
- Remove filler words (``it is important to note that...'' $\rightarrow$ just state the point).
- Keep citations compact: prefer `\parencite*{key}` inline rather than spelling out author names in the text.

#### Citations on slides
- Every claim, figure or dataset that is not your own original work must be cited on the slide where it appears.
- Place citations at the bottom of the slide in a smaller muted font (12--14 pt).
- Figures from published sources need an attribution caption directly beneath the figure (e.g. ``Source: Jones et al., 2021, Fig.~3'').

#### Structural patterns
- **Image-only slides**: just the image, centred. No `\begin{figure}` wrapper needed.
- **Two-column slides**: figure in left column, text/interpretation in right column. Keep text to 4--5 short bullets.
- **Quote slides**: use `\begin{quote}...\end{quote}` with italics, attributed below.
- **Conclusions slide**: 2--4 bullet points. Contact info (email, QR code to working paper) at the bottom or on a final standalone slide. This slide stays on screen during Q\&A.
- **Discussion/end slide**: LEAP logo centred, no extra text.

#### Common mistakes

| Mistake | Fix |
|---------|-----|
| Topic labels as titles | Write action titles (complete sentence, states the takeaway) |
| Presenting the whole paper | Choose one argument; move the rest to the appendix |
| Reading the slides aloud | Slides carry evidence; the presenter carries the argument |
| Evidence without a ``so what'' | Annotate the key finding directly on the chart |
| Body text $<$ 20 pt | Remove content until it fits at 20 pt |
| Slides you won't discuss | Move to appendix if you won't have time |
| Ending on ``Thank You'' | End on conclusions slide; it stays up during Q\&A |
| Burying the research question | State it explicitly, on its own slide, by slide 2--3 |
| No references slide | Always include one |

### Creating a new blank deck

If invoked without an argument (i.e. `/leapstyle slides`), create a new file with this structure. Ask the user for a filename before writing.

```latex
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Beamer Presentation â€“ LEAP template
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\documentclass[aspectratio=169]{beamer}

\mode<presentation> {
\usetheme{Boadilla}
\usecolortheme{seagull}

% LEAP colour accents
\definecolor{leapMaroon}{HTML}{7A0019}
\setbeamercolor{author in head/foot}{bg=leapMaroon,fg=white}
\setbeamercolor{title in head/foot}{bg=leapMaroon,fg=white}
\setbeamercolor{date in head/foot}{bg=leapMaroon,fg=white}
\setbeamercolor{section in head/foot}{bg=leapMaroon,fg=white}
\setbeamercolor{subsection in head/foot}{bg=leapMaroon,fg=white}
\setbeamercolor{footline}{bg=leapMaroon,fg=white}
}

\newcommand\tinytiny{\fontsize{3}{7.2}\selectfont}
\renewcommand*{\bibfont}{\tiny}
\usepackage{multirow}
\usepackage{booktabs}
\usepackage{dcolumn}
\usepackage{amsmath}
\usepackage{caption}
\usepackage{float}
\usepackage[utf8]{inputenc}
\usepackage{setspace}
\usepackage{threeparttable}
\usepackage[maxcitenames=2, maxbibnames=5, date=year, doi=false, backend=bibtex, url=false, isbn=false, style=authoryear, uniquename=init,giveninits]{biblatex}
\usepackage{rotating}
\newcolumntype{d}{D{.}{.}{2.5}}
\newcommand\mc[1]{\multicolumn{1}{c}{#1}}
\usepackage{hyperref}
\hypersetup{
    colorlinks=true,
    linkcolor=leapMaroon,
    filecolor=leapMaroon,
    citecolor=leapMaroon,
    urlcolor=leapMaroon,
}
\urlstyle{same}

% Minimalist bibliography look
\setbeamertemplate{bibliography item}{}
\setbeamercolor{bibliography entry author}{fg=black}
\setbeamercolor{bibliography entry title}{fg=black}
\setbeamercolor{bibliography entry location}{fg=black}
\setbeamercolor{bibliography entry note}{fg=black}

\bibliography{bibliography.bib}

%--- TITLE PAGE --------------------------------------------------------

\title[]{Presentation title}
\subtitle{Subtitle}
\author[Johan Fourie]{Johan Fourie}
\date{2026}

\begin{document}

\begin{frame}
\titlepage
\includegraphics[scale=0.25]{Pictures/LEAPlogo.png}\centering
\end{frame}

\begin{frame}{First slide}
\begin{itemize}
    \item Point one
    \item Point two
\end{itemize}
\end{frame}

\begin{frame}{Discussion}
\begin{figure}[H]
\includegraphics[scale=0.3]{Pictures/LEAPlogo.png}\centering
\end{figure}
\end{frame}

\begin{frame}[allowframebreaks]{References}
\printbibliography
\end{frame}

\end{document}
```

---

## Part 3: R Figures (ggplot2)

**Preferred defaults:** All LEAP figures are saved at **10 x 6 inches** (width x height) and **600 DPI** unless the context demands otherwise.

When applying the LEAP graph style to an R script, insert the following block near the top of the script (after `library()` calls, before any plotting code). Then update all figures to use `theme_leap()`, the LEAP colour palette and `save_leap_fig()`.

### LEAP colour palette and theme

```r
# ============================================================================
# LEAP VISUAL IDENTITY - Publication-Ready Graph Style
# ============================================================================

# LEAP colour palette
LEAP_COLORS <- c(
  plum  = "#5C2346",
  blue  = "#3D8EB9",
  sage  = "#6B8E5E",
  gold  = "#D4A03E",
  rose  = "#A34466",
  teal  = "#45808B",
  earth = "#8B6B3D",
  mint  = "#97C5B0"
)
LEAP_CYCLE <- unname(LEAP_COLORS)

# Utility colours
LEAP_NONSIG_COLOR <- "#AAAAAA"

# Scale functions for ggplot2
scale_fill_leap <- function(...) {
  scale_fill_manual(values = LEAP_CYCLE, ...)
}

scale_color_leap <- function(...) {
  scale_color_manual(values = LEAP_CYCLE, ...)
}

# LEAP ggplot2 theme
theme_leap <- function(base_size = 10) {
  theme_minimal(base_size = base_size, base_family = "sans") %+replace%
    theme(
      # Text
      text = element_text(family = "sans"),
      plot.title = element_text(
        size = 11, face = "bold", color = "#2D2D2D",
        margin = ggplot2::margin(b = 12), hjust = 0
      ),
      axis.title = element_text(size = 10, color = "#4A4A4A"),
      axis.text = element_text(size = 9, color = "#5A5A5A"),
      legend.text = element_text(size = 9),

      # Spines: only bottom and left
      axis.line.x.bottom = element_line(color = "#4A4A4A", linewidth = 0.8),
      axis.line.y.left = element_line(color = "#4A4A4A", linewidth = 0.8),
      panel.border = element_blank(),

      # Grid: horizontal only, light
      panel.grid.major.y = element_line(color = "#E0E0E0", linewidth = 0.5),
      panel.grid.major.x = element_blank(),
      panel.grid.minor = element_blank(),

      # Ticks
      axis.ticks = element_line(color = "#4A4A4A", linewidth = 0.6),
      axis.ticks.length = unit(3, "pt"),

      # Legend: no frame, no title by default
      legend.background = element_blank(),
      legend.key = element_blank(),

      # Background: pure white
      plot.background = element_rect(fill = "#FFFFFF", color = NA),
      panel.background = element_rect(fill = "#FFFFFF", color = NA),

      # Margins
      plot.margin = ggplot2::margin(10, 10, 10, 10),

      # Strip text for facets
      strip.text = element_text(size = 10, face = "bold", color = "#2D2D2D")
    )
}

# Helper: save LEAP figure in both PNG and PDF at high resolution
save_leap_fig <- function(fig_path, plot, width, height, dpi = 600) {
  png_path <- sub("\\.[^.]+$", ".png", fig_path)
  ggsave(png_path, plot, width = width, height = height, dpi = dpi)
  pdf_path <- sub("\\.[^.]+$", ".pdf", fig_path)
  ggsave(pdf_path, plot, width = width, height = height)
  cat("Saved:", png_path, "and", pdf_path, "\n")
}
```

### Transformation rules for R scripts

When converting an existing R script to LEAP style:

1. **Theme**: Replace any existing custom theme (e.g. `theme_minimal_pub`, `theme_bw(...)`, `theme_minimal(...)`) with `theme_leap()`.
2. **Colours**: Replace greyscale fills and colours with the LEAP palette. Use hex codes directly in `scale_fill_manual()` / `scale_color_manual()` â€” do NOT use `LEAP_COLORS["name"]` inside these calls, because the carried name interferes with ggplot2's level matching. Assign colours in order of visual importance:
   - Primary: `#5C2346` (plum)
   - Secondary: `#3D8EB9` (blue)
   - Tertiary: `#6B8E5E` (sage)
   - Quaternary: `#D4A03E` (gold)
   - Additional: `#A34466` (rose), `#45808B` (teal), `#8B6B3D` (earth), `#97C5B0` (mint)
   - Non-significant / reference: `#AAAAAA`
3. **Legend titles**: Remove legend titles by default (`labs(fill = NULL, colour = NULL)`), unless a title is genuinely needed for clarity.
4. **Saving**: Replace `ggsave()` calls with `save_leap_fig()` at 600 DPI. Standard dimensions: `width = 10, height = 6`.
5. **Bar borders**: No borders on bars (omit `colour` argument in `geom_col` / `geom_bar`). Exception: grouped/dodged bars may use `colour = "white", linewidth = 0.3` to separate adjacent bars.
6. **Line/point charts**: Use plum for the primary series. For dual-axis charts, use plum for bars and blue for the line/points.

### Minimal R example

```r
library(tidyverse)

# (paste the LEAP VISUAL IDENTITY block from above here)

# Example: grouped bar chart
df <- tibble(
  period = rep(c("2000-2009", "2010-2019"), each = 3),
  region = rep(c("Africa", "Europe", "Americas"), 2),
  share  = c(25, 55, 20, 35, 45, 20)
)

fig <- ggplot(df, aes(x = period, y = share, fill = region)) +
  geom_col(position = position_dodge(width = 0.75), width = 0.7,
           colour = "white", linewidth = 0.3) +
  scale_fill_manual(values = c("Africa"   = "#5C2346",
                               "Europe"   = "#3D8EB9",
                               "Americas" = "#6B8E5E")) +
  scale_y_continuous(labels = function(x) paste0(x, "%"),
                     expand = expansion(mult = c(0, 0.05))) +
  labs(x = NULL, y = "Share of authors", fill = NULL) +
  theme_leap()

save_leap_fig("Fig_example_grouped_bars.png", fig, width = 10, height = 6)
```

### Example: dual-axis chart (bars + line)

```r
fig2 <- ggplot(df_timeseries, aes(x = year)) +
  geom_col(aes(y = count), fill = "#5C2346", width = 0.7) +
  geom_line(aes(y = share * scale_factor), colour = "#3D8EB9", linewidth = 1) +
  geom_point(aes(y = share * scale_factor), colour = "#3D8EB9", size = 2) +
  scale_y_continuous(
    name = "Count",
    expand = expansion(mult = c(0, 0.05)),
    sec.axis = sec_axis(~ . / scale_factor, name = "Share (%)")
  ) +
  labs(x = NULL) +
  theme_leap()

save_leap_fig("Fig_example_dual_axis.png", fig2, width = 10, height = 6)
```

---

## Part 4: Writing and Editing Guide

A comprehensive writing-and-editing guide so that drafts come back in plain, classic English: ruthless removal of clutter; strong reader-orientation; careful punctuation; and strict attention to whether claims, citations, terminology and numbers actually make sense.

### Hard constraints (non-negotiables)

1. Do not invent facts, numbers, citations, page numbers, archival call numbers or quotations.
2. Do not add new literature "for completeness".
3. Do not change substantive meaning without flagging it as a query.
4. Do not "fix" apparent data errors by guesswork; query them.
5. Avoid ChatGPT tell-tales: em dashes; padded buzzwords; generic bureaucratic phrasing.

---

### Editing priorities

Prioritise the following, in roughly this order.

1. **Meaning first.** If a sentence is ambiguous, query it ("Meaning unclear...") or rewrite for explicit meaning.
2. **Reader-first organisation.** The reader should never have to work to follow the thread: avoid meandering structure, backwards references and needless detours.
3. **Plain, classic English.** Avoid bureaucratic/journalistic fashion; prefer ordinary words and direct syntax.
4. **Concision without loss of content.** Cut redundancy, throat-clearing, "thesis" scaffolding and wordy glue phrases.
5. **Precision of terms and claims.** Words must mean what they mean; technical/idiomatic phrases must be used correctly; comparisons must use correct grammar; key distinctions must be maintained.
6. **Consistency.** Consistent terminology, style, citation format, spelling (-ise not -ize when UK style) and typographic conventions.
7. **Venue compliance.** Check journal-specific rules (quotes, commas, section numbering, citation punctuation, abstract word limits).

---

### Macro-structure

#### Openings

Be unusually strict about the first paragraph.

- Keep the opening paragraph **short, brisk and simple**. No long, convoluted sentences.
- Start with **the topic**, not with methodological or historiographical throat-clearing.
- Avoid footnotes and (as a rule) avoid citations in the first paragraph.
- Do not overload the opener with detail or unfamiliar proper nouns that have not yet been motivated.
- The opening should "get the reader into the story quickly".

LLM action: Rewrite the opening to be plain and inviting; move detail/citations later; remove first-paragraph footnotes unless essential.

#### Introduction formula

**The rule the rest of this formula serves: say what the paper does in paragraph 2.** Everything below is subordinate to that. If the reader has to reach paragraph 4 to learn what was done, the introduction has failed regardless of how well the other paragraphs are written.

Treat this sequence as the LEAP default for an economics paper, not as a universal law. Depart from it when the paper or venue requires a different structure, but do not simulate concision by making the prescribed paragraphs unusually long.

1. **Big-picture motivation and knowledge gap.** Explain why the question matters and state clearly what we do not yet know. Keep this paragraph to no more than half a page and preferably to a third of a page or less.
2. **What the paper does.** Describe the main approach in one paragraph. Use two only when the approach is genuinely complicated. Give enough detail for the reader to understand and assess the method, but avoid a data inventory or a detailed identification discussion. If the design uses an instrument, name it and explain briefly why it is valid. Do not preview extensions, heterogeneity or mechanisms here.
3. **What the paper finds.** State the main findings in context, then explain what they imply and why they matter. Do not present an unconnected list of estimates. Summarise the most important robustness evidence concisely, for example: `Our findings are robust to [variations].`
4. **Extensions, heterogeneity and mechanisms.** Let the reader absorb the main result before adding these analyses. For closely related extensions, describe the analyses in one paragraph and their combined findings in the next. For distinct extensions, devote one paragraph to each and state what we do followed by what we find. More than four paragraphs on extensions will rarely be optimal.
5. **Literature contributions.** Use no more than two paragraphs. Organise them around what the paper changes in the literature and why that change matters. Avoid a separate literature-review section unless the venue or subject requires one.
6. **Roadmap.** End with a brief paragraph beginning, where natural, `The rest of the paper is structured as follows.` Keep the roadmap because paper structures differ, particularly in PhD work. Make it informative about the sequence rather than a bare list of section numbers.

##### Introduction audit

- Reach what the paper does in paragraph 2. A long motivational preamble weakens the introduction.
- Keep citations sparse in the first few paragraphs. If a motivational citation helps, one representative source, introduced by `e.g.`, is usually enough. Reserve most introduction citations for the contribution paragraphs.
- Name the missing knowledge explicitly. When relevant, explain what previously prevented an answer, such as unavailable data, absent exogenous variation or computational constraints, and how the paper overcomes that obstacle.
- Avoid a strawman question whose qualitative answer is already accepted. Ask a quantitative question, such as `How much does air pollution affect human health?`, or explain the competing forces that make the answer uncertain.
- State contributions as consequences, not merely differences. `Doe et al. (2012) do X, whereas we do Y` is incomplete until the introduction explains why Y changes what readers know.
- Keep the focus on this paper. Compress accounts of prior work and frame comparisons around the present contribution: `Unlike Doe et al. (2012), our model includes a tradable service sector. This modification reverses their leakage result.`
- Cite methodological precedents selectively. One representative `e.g.` citation is often sufficient in the introduction; discuss the broader methodological literature in the empirical-strategy section.
- Put every citation in the contribution paragraphs into context. Explain the precise relationship, for example: `By focusing on adults, our study complements estimates of pollution's effects on infant mortality (Doe et al. 2012; Smith et al. 2013).`
- Describe prior work neutrally. Prefer `builds on`, `extends` and `complements` to claims that earlier studies `failed` or have `little value`. Use a priority claim such as `We are the first to ...` only after verifying it, and always state why the contribution matters.
- Interpret results. Connect estimates to the motivating question, knowledge gap or policy problem rather than leaving the reader with coefficients alone.
- Balance detail by asking what the reader needs to understand and assess the paper. Omit minor data description, secondary results and routine checks. Include the source and logic of identification, key responses to obvious objections and a few informative robustness or placebo checks.
- Remove material that is not directly relevant to the research question, even when it connects loosely to an outcome or policy in the paper.
- Prefer first person (`we` or `I`) in economics. Use `this paper` occasionally if it improves variety, but avoid sustained third-person prose and habitual passive constructions such as `regressions are estimated`.
- Keep footnotes out of the introduction. A footnote interrupts the one part of the paper that most needs to read straight through. The defensible exception is a note in the contribution paragraphs identifying tangentially related literature.

When `/leapstyle paper` runs on a full manuscript, audit the introduction against this formula and report the result: which paragraph does which job, which slot is missing, and which is out of order. Do not silently rearrange an author's introduction; show the mapping and propose the repair.

#### Conclusion formula

The introduction earns the reader's attention; the conclusion decides what they carry away. Write it in the register expected by the *Journal of Political Economy* or the *Quarterly Journal of Economics*: three to five paragraphs, roughly 600 to 900 words, and never longer than the introduction.

1. **The answer.** Name the question and answer it, in one or two sentences, at exactly the level the evidence supports. Not `this paper examined`. This paragraph should survive on its own: if a reader quoted only it, they would have the paper's result.
2. **What the number means.** Put the headline estimate into a unit a reader can price -- a share of a benchmark, a comparison with a known effect, a back-of-envelope aggregate. This is the paragraph in which the result stops being a coefficient and becomes a fact about the world.
3. **What changes in what we believed.** State the revision to priors relationally: what a reader who held the standard view should now believe instead, and why that matters. `Consistent with the literature` says nothing. Name the belief the paper moves.
4. **Where the result binds.** Scope, not apology. Give the population, period and margin over which the estimate identifies something, then name the nearest setting where it would not hold and say why. Policy implications, if the paper has any, belong here, stated at the scope the design supports with the condition attached.
5. **The open question.** Name the data, variation or experiment that would settle what remains. A research design, not a genre sentence.

Paragraphs 2 and 3 may merge in a short paper; paragraph 4 may merge with 5. Paragraph 1 never merges with anything.

Hard rules:

- No new evidence. No number, table, figure or robustness result appears in the conclusion that is not already in the body.
- No section-by-section summary (`Section 2 described the data...`).
- No replay of the abstract sentence by sentence.
- No `In conclusion`, `To conclude`, `This paper has shown that`, `Further research is needed`.
- No bullet lists.
- No claim wider or narrower in scope than the same claim in the results section. The conclusion is where overclaiming happens; check it against the results, not against the abstract.

##### Conclusion audit

- Does the first paragraph answer the title's question in one sentence?
- Does the headline number appear with a unit and a benchmark?
- Is there a sentence saying what a reader should now believe that they did not before?
- Does any number appear that is not already in the body? There must be none.
- Is the final paragraph a specific research design rather than a genre sentence?
- Is the conclusion shorter than the introduction?

#### No limitations section, ever

Never give a paper a separate `Limitations`, `Caveats`, `Shortcomings` or `Scope conditions` section, and never a subsection either. A limitations section quarantines the honest content of a paper in the one place a referee reads as a confession, and it removes each limitation from the point where the reader actually needs it.

Fold every limitation into the section where the reader meets the problem:

| The limitation | Where it goes |
|---|---|
| Measurement error, coverage, selection into the source, transcription and linkage error | Data |
| Threats to the identifying assumption, and the tests that address each one | Empirical strategy |
| Statistical power, interpretation of magnitudes, competing explanations for the estimate | Results |
| External validity and the scope of the finding | Conclusion, paragraph 4 |

A limitation stated where the reader meets it reads as command of the material. The same sentence in a limitations section reads as an apology.

Mechanical audit: flag any section or subsection heading matching `limitation`, `caveat`, `shortcoming` or `scope condition`, and any paragraph opening `A limitation of this study`, `One caveat` or `This study is not without`. Relocate the content according to the table and report each move.

#### Thesis-language removal

Avoid "thesis language" and "examiner-facing" writing.

Common targets:
- Generic signposting outside the introduction. Retain the short final introduction roadmap described above.
- Meta-writing ("It is important to...", "This paper has shown...") -- write the content directly.
- Over-citation and "student" citation patterns ("plonk, plonk, plonk" strings).

LLM action: Remove thesis-like scaffolding, but retain an informative final introduction roadmap; replace other scaffolding with direct statements of contribution and findings.

#### Lists and signposting

- If you say "we contribute in three ways", **state the three ways clearly** in one sentence before elaborating.
- Avoid "firstly, secondly..." where a clean preview sentence will do.
- Summarise the list; then give details.

LLM action: Turn "preview + ramble" into: preview sentence (list) then short paragraphs corresponding to each item.

#### Triplets (lists of three)

- Do not default to the rhetorical "rule of three". Writers instinctively reach for three-item lists because they sound good, but the pattern quickly becomes formulaic.
- Vary list lengths: one item, two, four or even five are all fine. Use three when three is genuinely the right number, not because three sounds nice.
- When editing, actively look for triplets and ask whether each item earns its place. If one item is weaker or redundant, cut it. If a fourth item belongs, add it.
- Mechanical check: `grep -c -E ", [a-z]+ and [a-z]+" file.tex`. Target near zero in body prose; justify every survivor as a true count of the things listed (then it is content, not rhetoric).

#### Storytelling structure (added July 2026, from the Messy Research rewrite)

A paper is still a story: a world, a shock, a turn, a dilemma, an ending. Before drafting, write the arc in five one-line beats and let the paper's structure follow them. Storytelling means structure, pacing and rhythm; it never means metaphor. The prose stays literal throughout, and the variation does the work figurative language would otherwise be asked to do.

The reader to write for is a good economist outside the subfield. The test of the whole paper: could that reader finish it in one sitting and retell the main result at lunch, in one sentence?

#### Radical literalness

- No figurative language, personification or idiom in scientific prose. Signals do not "travel", text does not "bear" traces, results do not "carry" weight, prices do not "live" anywhere. Say what happens: the association weakens, the premium declines, the mass increases.
- Established terms of art are not figurative language (the stamp, the pool, the toll, the window, the race, the commons, the market for lemons). Keep them. The line to hold: a term of art is a phrase the field already uses with a fixed meaning.
- No smuggled verdicts: every evaluative word ("efficient", "dissipates", "better") must be backed by a stated result at exactly that strength. If the result proves a bound, write the bound.

#### Verbs keep their objects

Parsimony must never swallow meaning. "Polish stops separating" is wrong; "polish stops separating good work from plausible work" is right. Every transitive verb keeps its object, and every "gap", "pool", "path" or "threshold" says which one, unless the same sentence already named it. When compression and clarity conflict, clarity wins: use more words.

#### Rhythm and variety (sentence and paragraph length)

- Every paragraph of four or more sentences contains at least one sentence under ten words; no paragraph consists entirely of 25+-word sentences. A two-word sentence is allowed.
- Short verdict sentences are the strongest beat available and the easiest to overuse. Ration them: twice per section, not once per paragraph.
- Allow one- and two-sentence paragraphs at turns in the argument; keep long development paragraphs where the material needs room. No wall of same-sized blocks.
- Audit rhythm mechanically: list sentence word-counts for the abstract and one long section; the numbers should look varied (13/25/10/2/25/16...), not uniform (30/29/53/40/35/33).

#### Glossing for the non-specialist

- Gloss every technical term at first use, in the same sentence, in plain words (affiliation: "better-skilled authors have better ideas on average"; the posterior: "the reputation readers rationally infer"; a Pigouvian toll: "a charge equal to the harm one more submission does to everyone else").
- Words before parameters: explain a result in words first, then give the formula or condition. Never make the reader meet an inequality before knowing what its symbols are and what it is doing.
- Define every symbol at or before first use, including the ones that feel obvious after months inside the model.
- Formal statements and proofs may stay technical; the body prose does not get that license.

#### No revision-relative language

A manuscript speaks in one timeless voice. Never "the earlier draft", "now", "no longer" (in the revision sense) in the paper itself; revisions are discussed in the response letter only.

#### Cite your own prior work in the third person

This is the rule the timeless-voice rule above does not by itself catch, and it is a desk-reject-grade error: **never introduce your own earlier paper as an earlier paper.** A manuscript has no history that the reader can see. A predecessor working paper is a separate published object, and it is cited exactly like anyone else's work.

| Never write | Write instead |
|---|---|
| An earlier working paper argued that X (Fourie, 2026). | Fourie (2026) argues that X. |
| Our previous paper showed X. | Smith and Jones (2025) show X. |
| In an earlier version of this paper, X. | *(delete: the reader is not reading a version)* |
| A companion paper discusses X. | Fourie (2026) discusses X. |
| This paper builds on our working paper. | *(delete, or state the substantive relation without the possessive)* |

Two reasons, both fatal on their own. First, "an earlier working paper" tells the reader that the manuscript in front of them is a revision of something else, which invites the question of what changed rather than what is true. Second, in the AEA's own words a paper should stand alone: an editor reading "an earlier working paper" sees an author narrating a private drafting history in a public document.

Naming yourself is not the problem and self-citation is not the problem. The framing is. `\citet{key}` and let the reference list do the work. If the predecessor is genuinely superseded by the paper at hand, say what it argues and what the present model adds, in ordinary literature-review voice, with no possessive and no chronology of drafts.

Mechanical check, run on every pass:

```bash
grep -inE "an earlier (paper|version|draft|working paper)|our (earlier|previous|prior|companion) (paper|work)|in (an|the) earlier version|companion paper|this paper (builds on|extends) (our|my)" file.tex
```

Any hit is a rewrite, not a judgement call. Then read every self-citation in context: `grep -n -B3 -A2 "<yoursurname><year>" file.tex`, and confirm each one is introduced by author-year and not by its relationship to the manuscript.

#### The cold read (final QA)

Have an independent reader (a person, or an agent told to be "an applied economist, not a theorist") read only the PDF and report: (a) any sentence read twice, (b) where the story lost them, (c) residual monotony, (d) the one-sentence lunch retell. Fix everything in (a)-(c). If (d) fails, the problem is the paper, not the reader. If the style pass followed a content revision, verify no content drifted: citation multiset identical, equation and theorem counts identical, every number and hedge intact, verification scripts still passing.

#### Paragraph integrity

- One paragraph, one job. Avoid drifting off-topic.
- Avoid repetition ("Don't tell the reader what you've already said").
- Avoid "going forward/back" references; fix organisation instead.

LLM action: Reorder paragraphs to prevent forward/back references; delete repetition; add topic sentences when needed.

---

### Sentence-level style

#### Prefer direct syntax over roundabout phrasing

- Replace expletive openings ("There is/are...") with concrete subjects where possible.
- Replace nouny constructions with verbs ("played an important role in increasing" -> "increased").
- Avoid tacking on clauses with "with" when a new sentence would be clearer.
- Prefer active voice where it clarifies agency (especially for methods).
- In economics, prefer first person (`we` or `I`) to sustained third-person references to `this paper`. Use passive voice only when the object or procedure, rather than the actor, deserves emphasis.

LLM action: Seek the actor and the action; make the subject do the verb; split sentences that are overloaded.

#### Break up long sentences

- Long sentences are acceptable only if they remain easy to parse. Often break 50-70-word sentences into smaller ones.
- Sometimes a new sentence is better than multiple semi-colons.

LLM action: If a sentence exceeds ~30-35 words, check whether splitting improves readability.

#### Use repetition for comparisons

Simple repetition can clarify comparisons ("more X..., more Y...").

LLM action: When contrasting groups, use parallel structure rather than baroque phrasing.

#### Avoid "elegant variation"

Don't use multiple terms for the same thing ("run by/administered/under the direction of").

LLM action: Pick one term for a concept and reuse it; use synonyms only when the meaning differs.

#### "While" discipline

- Don't overuse "While" to start sentences for contrast; often "But" or "Although" is better.

LLM action: Replace sentence-initial "While" (contrastive) with "But/Although" where appropriate.

#### "Former/latter" discipline

- Avoid "former/latter": it forces the reader to look back.

LLM action: Repeat the nouns or rewrite the sentence.

#### Allow And/But at the start of sentences

It is acceptable (and often good style) to start a sentence with And or But.

LLM action: Use And/But judiciously to control flow; don't fear it when it improves readability.

#### "Not X but Y" constructions

- Minimise sentences that contain both the words "not" and "but" (e.g., "not the poorest but the middle").
- **Hard limit: no more than two such sentences in an entire paper.**
- Rewrite others using alternative structures: concessive clauses ("although..."), positive framing or splitting into two sentences.

---

### Word choice

#### Plain English over inflated diction

Frequent simplifications:
- prior to -> before
- (adverbial) due to -> because of / owing to
- regarding -> about
- make use of -> use
- the majority -> most

LLM action: Prefer short, ordinary words unless technical vocabulary is needed.

#### Avoid Americanisms and language fads

Non-negotiables:
- Do not use **likely** as an adverb meaning "probably". Prefer "probably", or rewrite ("It is likely that..." -> "This probably...").
- Do not misuse **as such** to mean "therefore". "As such" means "in this capacity".

LLM action: Audit drafts for these patterns; rewrite rather than swapping words mechanically.

#### Avoid bureaucrat-speak and buzzwords

Avoid bureaucratic language in formal writing (address, leverage, empower, going forward, etc.). See Appendix A below.

LLM action: Replace buzzwords with specific verbs/nouns that say what actually happened.

#### Avoid journalistic language in academic prose

- "deadly" (journalistic, often unquantified)
- journalistic inversion ("Says Ruggles" rather than "Ruggles says/argues...")

LLM action: Prefer measured, quantified language; keep normal subject-verb order.

#### Words must mean what they mean

Academic writing must use special terms correctly (examples: begs the question; contemporary; as such; specifically vs particularly). See Appendix B below.

LLM action: When a phrase has a technical meaning, use it technically; otherwise choose a safer alternative.

#### Comparisons: use "than"

Avoid circumlocutions around "than" (e.g., "more relative to", "higher likelihood relative to"). Use "than" for comparisons.

LLM action: Rewrite comparisons to use standard comparative grammar: "more X than Y".

#### "Impact" as a verb

Replace "impact" (verb) with "affect".

LLM action: Replace "impact" (verb) with "affect/influence" unless the usage is deliberate.

#### Banned words

- **underscore**: Never use "underscore" as a verb (e.g., "this underscores the importance of..."). Use "highlights", "reinforces", "confirms" or similar alternatives.
- **utilise / utilize**: Never use. Always use "use" instead.

#### Terminology consistency and precision

- Query terminology that is ambiguous or politically/chronologically anachronistic.
- Object to unnecessary synonym-swapping (elegant variation).

LLM action: Enforce one term per concept; if a term is historically contingent or ambiguous, query it and recommend an explicit definition at first mention.

---

### Punctuation, typography and formatting

#### Venue-first, then default

Check the venue's style (examples: AEJ vs EHR vs Tourism Economics vs JEH). The rule is:

1. If journal/publisher style is known, follow it.
2. If not, use LEAP default (below).

LLM action: If venue is unknown, apply LEAP default and add a margin comment: "Confirm venue style for quotes/serial comma/citation punctuation/section numbering."

#### Serial/Oxford comma

- **Do not use the Oxford/serial comma by default.**
- Write `A, B and C` -- not `A, B, and C`.
- Use it only if the sense requires it, or if the publication demands it.
- **Exception**: Keep the comma if removing it would create genuine ambiguity (e.g., "Stellenbosch, the Cape, and parts of Swellendam and Worcester" -- dropping the comma could misparse the grouping).
- Be consistent.

LLM action: Remove unnecessary serial commas; keep only those needed to prevent ambiguity.

#### Colons vs semi-colons

- Use a **colon** to introduce an explanation, elaboration, extension or list.
- Use a **semi-colon** mainly to:
  - hinge between contrasting statements, or
  - create a long pause stronger than a comma.
- Don't overuse semi-colons: they make prose heavy.

LLM action: Replace incorrect semi-colons with colons; split sentences if semi-colons accumulate.

#### Dashes

- **Don't use em dashes.** They are overused and disrupt the flow of prose.
- Use **en dashes sparingly**. Prefer commas or parentheses unless the dash is doing real work.
- When a parenthetical is needed, prefer **en dashes with spaces** (`--` with a space before and after). Example: `the frontier farmers -- many of whom owned few slaves -- were drawn to the interior`.
- Convert hyphen ranges to en dashes (e.g., 1850-1900 -> 1850--1900).
- In LaTeX: en dash with spaces = `word -- word`; em dash (sparingly) = `word---word`.

LLM action: Convert hyphen ranges to en dashes; avoid em dashes entirely; reduce dash frequency.

#### Hyphenation

- No hyphen after -ly (e.g., "highly developed", not "highly-developed").
- Add hyphens to prevent misreading.
- Hyphenation can be aesthetic/clarifying; apply consistently.

LLM action: Fix -ly compounds; hyphenate compound modifiers before nouns when needed.

#### Quotes and quotation punctuation

- Single quotes are default in UK style, but follow a journal that uses double quotes.
- British convention: closing inverted comma precedes comma/full stop (unless the punctuation belongs to the quoted material).

LLM action: Choose single vs double quotes based on venue; otherwise default to UK single quotes and British punctuation placement.

#### Spelling and variants

- Default to UK spelling: -ise not -ize.
- Be consistent within a document.
- Preserve official names as they are (some proper nouns may use US spelling).

LLM action: Enforce UK spelling and tidy inconsistencies; query if venue requires US style.

#### Capitalisation

- Avoid unnecessary capitals (subjects like maths/history; generic terms).
- Capitalise only proper nouns or formal course/module titles where relevant.
- Be consistent (including with contested terms); avoid performative inconsistency.

LLM action: Lower-case generic descriptors; keep proper nouns capitalised; query venue-driven capitalisation choices when sensitive.

#### Slashes

- Avoid slashed alternatives ("and/or") in formal writing.

LLM action: Replace slashes with explicit prose ("and", "or", or "and... or..."), depending on meaning.

#### Abbreviations and acronyms

- Do not assume readers know an acronym; spell it out at first mention.
- Avoid abbreviations unless they genuinely reduce repetition and are standard in the field.
- Avoid "et al." outside reference-style contexts (see citations section).

LLM action: Spell out at first mention; remove non-standard acronyms; add a margin query if an acronym cannot be expanded from context.

---

### Quotation handling

#### Quote only when wording matters

Quote only if the wording is special; otherwise paraphrase.

LLM action: Replace unremarkable quotes with paraphrase; keep essential quotes tight.

#### Integrate quotes smoothly

- Avoid "according to" clutter.
- Use the simplest reporting verbs; stylistic variety ("explains", "points out") can be distracting.
- Avoid ugly square brackets; restructure to minimise them.

LLM action: Rewrite lead-ins, integrate quotes grammatically and reduce bracketed insertions.

#### Scare quotes

- Scare quotes imply irony/doubt; if you don't mean that, remove them.
- Do not put standard expressions in quotes.

LLM action: Remove scare quotes unless the author clearly intends scepticism/irony.

#### Block quotes

- Use a block quote for a long quote (generally >50 words or more than one sentence).

LLM action: Convert long quotations to block format (if required by venue) or paraphrase.

---

### Numbers, data and evidential discipline

- Always give denominators/totals alongside percentages ("state the actual number").
- Avoid calling something an "annual rate" if it is a single year.
- Present statistics clearly and concisely; avoid leisurely narrative around numbers.
- Distinguish concepts precisely (e.g., pandemic/virus vs lockdown; don't use one term as shorthand for another).
- Avoid exaggerated adjectives ("enormous", "deadly") unless quantified and defensible.

LLM action: Do not alter numbers; instead tighten wording around them, standardise the presentation (per venue) and add margin queries for missing totals or possible misinterpretations.

---

### Citations, references and footnotes

#### Reference list integrity

- Every cited work must be in the reference list; the list must contain only cited works.
- Every entry carries the authors' full given names, not initials. When a `.bib` entry has only initials, resolve it against a source or ask -- never expand an initial from memory. The resolution procedure is in `/leapwp`, which runs the audit when the paper is packaged.

#### Citation placement and density

- Keep citations sparse in the first few introduction paragraphs and avoid them in the first paragraph where possible. Put most introduction citations in the contribution paragraphs.
- When a motivational or methodological precedent is useful early in the introduction, one representative `e.g.` citation is usually enough.
- Do not cite sources for basic facts that can be found anywhere.
- Avoid scattershot citations; collate them so they serve the reader.
- In contribution paragraphs, cite only directly relevant work and state how each cited paper relates to the present contribution.

LLM action: Move or consolidate citations; add margin notes when a citation seems irrelevant or when the claim needs a source.

#### Footnote discipline

- Don't use footnotes to expand the text. Aim for no footnotes in the introduction where possible and no more than about one footnote per page in the paper as a general rule.
- Use footnotes for necessary clarifications, source details or venue-required apparatus.
- The most defensible introduction footnotes usually identify tangentially related literature in the contribution paragraphs.

LLM action: Delete, integrate or relocate each avoidable footnote; move essential content into the main text and tangential material to a more appropriate section.

#### "et al."

- Use "et al." only for references; not as a vague substitute in prose.
- Include the full stop after "al.".
- Check each journal's rule (first citation often does not require listing all authors).

LLM action: Fix incorrect "et al." uses; query author where meaning is unclear ("Who are et al. here?").

#### Ibid.

- Do not use ibid. when the preceding footnote cites several sources.

LLM action: Replace ibid. with the specific reference.

#### Citation punctuation and ordering

- Semi-colons (not commas) between citations in some venues.
- Citations often alphabetical.
- Always: journal-specific rules apply.

LLM action: Apply the venue's citation punctuation; if unknown, keep it consistent and add a query.

---

### Metaphors, cliches and rhetorical control

- Avoid overused metaphors ("lens" is a frequent irritant).
- Do not mix metaphors; clashes create absurd mental images.
- Use metaphors only when they genuinely aid comprehension; otherwise be plain.
- Avoid cliches ("stark", "eloquent", "perfect storm", etc.).

LLM action: Replace mixed/overused metaphors with literal wording; keep at most one metaphor per paragraph.

---

### Appendix A: Buzzword blacklist

| Avoid | Prefer | Why |
| --- | --- | --- |
| address (as a verb) | answer / tackle / deal with / discuss | Bureaucrat-speak. |
| leverage | use / draw on / take advantage of | Overused management jargon. |
| empower | enable / give people the means to | Buzzword. |
| pillar | domain / theme / component | Buzzword; avoid structural metaphors. |
| going forward | in future / from now on | Bureaucratic cliche. |
| reach out | contact | Corporate fashion; avoid. |
| lived experience | (usually) experience | Irritating buzzphrase unless analytically necessary. |
| challenge (meaning 'problem') | problem / difficulty / constraint | Use 'challenge' only in its dictionary sense. |
| operationalise | define / measure / specify | Bureaucratic word; not appropriate. |
| task (used as a verb) | assign / ask / instruct | Bureaucratic usage. |
| issues (meaning 'problems') | problems / questions / concerns | Avoid vague bureaucratic phrasing. |
| dynamic (as vague noun/adjective) | process / mechanism / change over time | Be specific; avoid hand-waving. |
| unique (when you just mean 'special') | distinct / particular / unusual | Avoid empty emphasis. |
| underscore (as a verb) | highlights / reinforces / confirms | Overused LLM-speak. |

### Appendix B: Misuse watchlist

| Avoid/misuse | Prefer | Rationale |
| --- | --- | --- |
| likely (as adverb meaning 'probably') | probably / may / might / is likely to (adjective) | Adverbial use is an American fad. |
| as such (misused to mean 'therefore') | thus / therefore / so | 'As such' means 'in this capacity'. |
| begs the question | raises the question / prompts the question | Technical term in logic (petitio principii). |
| contemporary (meaning 'today') | today / present-day / current | 'Contemporary' means 'at the same time'. |
| relative to (for comparisons) | than | Incorrect avoidance of 'than'. |
| more relative to | more than | Incorrect English. |
| impact (verb) | affect / influence | Not a verb in good prose. |
| scare quotes | plain wording or a short clarification | Quotes imply irony/doubt. |
| former/latter | repeat the nouns or rewrite | Slows the reader down. |

---

## Design rationale

These choices follow Tufte, Cleveland & McGill, and Few:

- **Horizontal gridlines only**: aid value comparison without adding clutter (Cleveland & McGill, 1984).
- **Bottom + left spines only**: top and right spines carry no data; removing them increases the data-ink ratio (Tufte, 1983).
- **No bar borders**: borders add non-data ink. White separators are the exception for grouped bars where adjacent fills would otherwise bleed together (Few, 2012).
- **600 DPI**: ensures crisp reproduction in print, on slides and on retina screens.
- **Maroon for slide chrome, plum for data**: projected slides need a warm, high-contrast accent for UI elements; printed/PDF figures benefit from a deeper, cooler primary that reproduces well across devices. Graphs embedded in LEAP slides use the graph palette (plum, blue, sage, gold...), not the slide maroon.

---

## Acknowledgements

This style guide draws on several inputs:

- **Visual identity**: Nudge Studio (Mike Cruywagen) designed the LEAP colour palette and brand elements.
- **Presentation content guidelines**: The beamer content style guide (Part 2) draws on the academic presentation framework by [Gabberflast](https://github.com/Gabberflast/academic-pptx-skill/blob/main/content_guidelines.md).
- **Writing and editing guide**: Di Kilpert developed the writing and editing standards codified in Part 4.
- **Introduction formula**: the paragraph sequence and the audit in Part 4 follow Tatyana Deryugina, [A two-for-one blog post on writing introductions](https://deryugina.com/a-two-for-one-blog-post-on-writing-introductions/).
- **Bibliography style**: `aea.bst` is the American Economic Association's BibTeX style (version 2009.05.20), distributed by the AEA. The file itself ships with `/leapwp`, which installs it beside the paper.
