---
name: leapstyle
description: Apply the LEAP Economics house style to LaTeX working papers, beamer slides, or R figures. Covers preambles, colour palette, graph theme, and content guidelines.
user-invocable: true
argument-hint: <paper|slides|graph> [filename]
---

# LEAP Style Guide

The unified visual identity for Johan Fourie's research group (LEAP, Stellenbosch University).
Covers three outputs: **working papers** (LaTeX article), **presentations** (LaTeX beamer), and **figures** (R / ggplot2).

## Usage

```
/leapstyle paper myfile.tex        # apply the working paper template
/leapstyle slides myfile.tex       # apply the beamer slide template
/leapstyle graph myscript.R        # apply the LEAP graph identity to an R script
/leapstyle                         # (no argument) describe all three styles
```

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

## Part 1: LaTeX Working Paper

### Preamble

Replace the preamble of the target `.tex` file with the following, preserving the file's own `\title`, `\author`, `\date`, and any custom commands used in its body.

```latex
\documentclass[11pt]{article}

% ---------- LEAP working paper setup ----------
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

### Title page rules

1. Page 1 contains `\maketitle`, the abstract, keywords, and JEL codes only.
2. Format keywords and JEL codes as:
   ```latex
   \end{abstract}
   \vspace{1em}\noindent\textbf{Keywords:} keyword1; keyword2; keyword3

   \vspace{0.25em}
   \noindent\textbf{JEL codes:} X00; Y00; Z00

   \vspace{0.5em}
   ```
3. Insert `\newpage` before `\section{Introduction}` so the body always starts on page 2.

### Author and acknowledgements

- Use `\thanks{}` for affiliations and acknowledgements, attached to `\title` or `\author`.
- Format: `\author{First Last\thanks{Affiliation.} \and Second Author\thanks{Affiliation.}}`
- Leave `\date{}` empty (no date printed).

### Bibliography

- Use `\bibliographystyle{plainnat}` with `\bibliography{references}` (or the relevant `.bib` file).
- Place at the end of the document, before `\end{document}`.

### General formatting

- **Paragraphs**: standard indentation (do NOT set `\parindent` to 0 or add `\parskip`). Line spacing is 1.5 via `\onehalfspacing`.
- **Figures**: use `\begin{figure}[htbp]` with `\centering` and `\includegraphics[width=\linewidth]{...}`.
- **Hyperlinks**: all black (formal, print-ready).

### Minimal working example

```latex
\documentclass[11pt]{article}
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

\title{Paper Title\thanks{Acknowledgements here.}}
\author{Johan Fourie\thanks{LEAP, Department of Economics, Stellenbosch University.}}
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

\bibliographystyle{plainnat}
\bibliography{references}

\end{document}
```

---

## Part 2: Beamer Slides

### Template preamble

Replace the **entire preamble** (everything before `\begin{document}`) of each target beamer file with the following, preserving only the file's own `\title`, `\subtitle`, `\author`, and `\date` lines. If a file defines custom commands used in its body (e.g. `\newcommand{\source}[1]{\caption*{Source: {#1}}}`), keep those too, placed just before the title block.

```latex
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Beamer Presentation – LEAP template
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
2. **Title block**: Keep the file's `\title`, `\subtitle`, `\author`, and `\date` lines. Update `\date` to the current year if it is outdated.
3. **Logo**: Replace any logo path (`LEAP SU logo colour on white transparent.png`, `LEAP icon colour on white transparent.png`, or variants with `Figures/` or `Pictures/` prefixes) with `Pictures/LEAPlogo.png`.
4. **Image paths**: Change all `{Figures/...}` references to `{Pictures/...}`.
5. **Image sizing**: Never use `scale=` for content images (only for the logo). Use `height=0.7\paperheight,keepaspectratio` for standalone images, `height=0.60\paperheight,keepaspectratio` for images with captions, and `height=0.55\paperheight,keepaspectratio` for images in columns.
6. **References frame**: If the file has a references frame, keep it as `\begin{frame}[allowframebreaks]{References}\printbibliography\end{frame}`.
7. **Non-beamer files**: If a `.tex` file uses `\documentclass{article}` or similar (not beamer), apply the working paper template from Part 1 instead.

### Content style guide

Apply these rules to every slide's content for a clean, minimalist look:

#### Text density
- **Max 5 bullets** per slide. If a slide has 6+, split it into two frames or trim to essentials.
- **Max 2 levels** of nesting (main bullet + one sub-level). Never use a third level; flatten it up or split the slide.
- Each bullet should be **1 line, max 2**. If longer, tighten the wording or break into sub-bullets.

#### Bold usage
- Use `\textbf{}` for **1-2 key terms per slide** as visual anchors.
- Pattern: `\textbf{Key term}: short explanation` (bold the concept, not the explanation).
- Bold only 1-3 words. Never bold full sentences or long phrases.
- Every content slide should have at least one bold term so the audience can scan.

#### Italics
- Use `\textit{}` only for: direct quotes, book/paper titles, and foreign-language terms.
- Do not use italics for emphasis; use bold for that.

#### General tone
- Write for the listener, not the reader. Slides are prompts for the presenter, not a textbook.
- Prefer short noun phrases over full sentences where possible.
- Remove filler words ("it is important to note that..." -> just state the point).
- Keep citations compact: prefer `\parencite*{key}` inline rather than spelling out author names in the text.

#### Structural patterns
- **Image-only slides**: just the image, centred. No `\begin{figure}` wrapper needed.
- **Two-column slides**: text in left column, image in right column. Keep text to 4-5 short bullets.
- **Quote slides**: use `\begin{quote}...\end{quote}` with italics, attributed below.
- **Discussion/end slide**: LEAP logo centred, no extra text.

### Creating a new blank deck

If invoked without an argument (i.e. `/leapstyle slides`), create a new file with this structure. Ask the user for a filename before writing.

```latex
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Beamer Presentation – LEAP template
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

When applying the LEAP graph style to an R script, insert the following block near the top of the script (after `library()` calls, before any plotting code). Then update all figures to use `theme_leap()`, the LEAP colour palette, and `save_leap_fig()`.

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
2. **Colours**: Replace greyscale fills and colours with the LEAP palette. Use hex codes directly in `scale_fill_manual()` / `scale_color_manual()` — do NOT use `LEAP_COLORS["name"]` inside these calls, because the carried name interferes with ggplot2's level matching. Assign colours in order of visual importance:
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

## Part 4: Writing Style

### "Not X but Y" constructions

- Minimise sentences that contain both the words "not" and "but" (e.g., "not the poorest but the middle").
- **Hard limit: no more than two such sentences in an entire paper.**
- Rewrite others using alternative structures: concessive clauses ("although..."), positive framing, or splitting into two sentences.

### Triplets (lists of three)

- Do not default to the rhetorical "rule of three". Writers instinctively reach for three-item lists because they sound good, but the pattern quickly becomes formulaic.
- Vary list lengths: one item, two, four, or even five are all fine. Use three when three is genuinely the right number, not because three sounds nice.
- When editing, actively look for triplets and ask whether each item earns its place. If one item is weaker or redundant, cut it. If a fourth item belongs, add it.

### Banned words

- **underscore**: Never use "underscore" as a verb (e.g., "this underscores the importance of..."). Use "highlights", "reinforces", "confirms" or similar alternatives.
- **utilise / utilize**: Never use. Always use "use" instead.

### Oxford comma

- **Do not use the Oxford comma.** In lists of three or more items, omit the comma before the final "and" or "or".
- Write `A, B and C` — not `A, B, and C`.
- **Exception**: Keep the comma if removing it would create genuine ambiguity (e.g., "Stellenbosch, the Cape, and parts of Swellendam and Worcester" — dropping the comma could misparse the grouping).

### Dashes

- **Avoid em dashes** (`---` in LaTeX). They are overused and disrupt the flow of prose.
- When a parenthetical or aside is needed, prefer **en dashes with spaces** (`--` with a space before and after) as the default punctuation. Example: `the frontier farmers -- many of whom owned few slaves -- were drawn to the interior`.
- Use em dashes only in rare cases where a very abrupt break is genuinely needed. As a rule of thumb, if you find yourself using more than one or two per page, switch to en dashes or restructure the sentence.
- In LaTeX: en dash with spaces = `word -- word`; em dash (sparingly) = `word---word`.

---

## Design rationale

These choices follow Tufte, Cleveland & McGill, and Few:

- **Horizontal gridlines only**: aid value comparison without adding clutter (Cleveland & McGill, 1984).
- **Bottom + left spines only**: top and right spines carry no data; removing them increases the data-ink ratio (Tufte, 1983).
- **No bar borders**: borders add non-data ink. White separators are the exception for grouped bars where adjacent fills would otherwise bleed together (Few, 2012).
- **600 DPI**: ensures crisp reproduction in print, on slides, and on retina screens.
- **Maroon for slide chrome, plum for data**: projected slides need a warm, high-contrast accent for UI elements; printed/PDF figures benefit from a deeper, cooler primary that reproduces well across devices. Graphs embedded in LEAP slides use the graph palette (plum, blue, sage, gold...), not the slide maroon.
