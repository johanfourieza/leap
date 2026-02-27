---
name: leapstyle
description: Apply the LEAP Economics house style to LaTeX working papers, beamer slides, R figures, or academic writing and editing. Covers preambles, colour palette, graph theme, and comprehensive writing and editing guidelines.
user-invocable: true
argument-hint: <paper|slides|graph|writing> [filename]
---

# LEAP Style Guide

The unified visual identity for Johan Fourie's research group (LEAP, Stellenbosch University).
Covers three outputs: **working papers** (LaTeX article), **presentations** (LaTeX beamer), and **figures** (R / ggplot2).

## Usage

```
/leapstyle paper myfile.tex        # apply the working paper template
/leapstyle slides myfile.tex       # apply the beamer slide template
/leapstyle graph myscript.R        # apply the LEAP graph identity to an R script
/leapstyle writing myfile.tex      # apply LEAP writing and editing standards
/leapstyle                         # (no argument) describe all four styles
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

**Preferred defaults:** All LEAP figures are saved at **10 x 6 inches** (width x height) and **600 DPI** unless the context demands otherwise.

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

## Part 4: Writing and Editing Guide

A comprehensive writing-and-editing guide so that drafts come back in plain, classic English: ruthless removal of clutter; strong reader-orientation; careful punctuation; and strict attention to whether claims, citations, terminology and numbers actually make sense.

### Hard constraints (non-negotiables)

1. Do not invent facts, numbers, citations, page numbers, archival call numbers or quotations.
2. Do not add new literature "for completeness".
3. Do not change substantive meaning without flagging it as a query.
4. Do not "fix" apparent data errors by guesswork; query them.
5. Avoid ChatGPT tell-tales: em dashes; padded buzzwords; generic bureaucratic phrasing.

---

### 4.1 Editing priorities

Prioritise the following, in roughly this order.

1. **Meaning first.** If a sentence is ambiguous, query it ("Meaning unclear...") or rewrite for explicit meaning.
2. **Reader-first organisation.** The reader should never have to work to follow the thread: avoid meandering structure, backwards references and needless detours.
3. **Plain, classic English.** Avoid bureaucratic/journalistic fashion; prefer ordinary words and direct syntax.
4. **Concision without loss of content.** Cut redundancy, throat-clearing, "thesis" scaffolding and wordy glue phrases.
5. **Precision of terms and claims.** Words must mean what they mean; technical/idiomatic phrases must be used correctly; comparisons must use correct grammar; key distinctions must be maintained.
6. **Consistency.** Consistent terminology, style, citation format, spelling (-ise not -ize when UK style) and typographic conventions.
7. **Venue compliance.** Check journal-specific rules (quotes, commas, section numbering, citation punctuation, abstract word limits).

---

### 4.2 Macro-structure

#### Openings

Be unusually strict about the first paragraph.

- Keep the opening paragraph **short, brisk and simple**. No long, convoluted sentences.
- Start with **the topic**, not with methodological or historiographical throat-clearing.
- Avoid footnotes and (as a rule) avoid citations in the first paragraph.
- Do not overload the opener with detail or unfamiliar proper nouns that have not yet been motivated.
- The opening should "get the reader into the story quickly".

LLM action: Rewrite the opening to be plain and inviting; move detail/citations later; remove first-paragraph footnotes unless essential.

#### Thesis-language removal

Avoid "thesis language" and "examiner-facing" writing.

Common targets:
- Signpost paragraphs ("This chapter/paper is structured as follows...") unless the journal demands them.
- Meta-writing ("It is important to...", "This paper has shown...") -- write the content directly.
- Over-citation and "student" citation patterns ("plonk, plonk, plonk" strings).

LLM action: Remove thesis-like scaffolding, unless venue requires it; replace with direct statements of contribution and findings.

#### Lists and signposting

- If you say "we contribute in three ways", **state the three ways clearly** in one sentence before elaborating.
- Avoid "firstly, secondly..." where a clean preview sentence will do.
- Summarise the list; then give details.

LLM action: Turn "preview + ramble" into: preview sentence (list) then short paragraphs corresponding to each item.

#### Triplets (lists of three)

- Do not default to the rhetorical "rule of three". Writers instinctively reach for three-item lists because they sound good, but the pattern quickly becomes formulaic.
- Vary list lengths: one item, two, four or even five are all fine. Use three when three is genuinely the right number, not because three sounds nice.
- When editing, actively look for triplets and ask whether each item earns its place. If one item is weaker or redundant, cut it. If a fourth item belongs, add it.

#### Paragraph integrity

- One paragraph, one job. Avoid drifting off-topic.
- Avoid repetition ("Don't tell the reader what you've already said").
- Avoid "going forward/back" references; fix organisation instead.

LLM action: Reorder paragraphs to prevent forward/back references; delete repetition; add topic sentences when needed.

---

### 4.3 Sentence-level style

#### Prefer direct syntax over roundabout phrasing

- Replace expletive openings ("There is/are...") with concrete subjects where possible.
- Replace nouny constructions with verbs ("played an important role in increasing" -> "increased").
- Avoid tacking on clauses with "with" when a new sentence would be clearer.
- Prefer active voice where it clarifies agency (especially for methods).

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

### 4.4 Word choice

#### Plain English over inflated diction

Frequent simplifications:
- utilise -> use
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

### 4.5 Punctuation, typography and formatting

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

### 4.6 Quotation handling

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

### 4.7 Numbers, data and evidential discipline

- Always give denominators/totals alongside percentages ("state the actual number").
- Avoid calling something an "annual rate" if it is a single year.
- Present statistics clearly and concisely; avoid leisurely narrative around numbers.
- Distinguish concepts precisely (e.g., pandemic/virus vs lockdown; don't use one term as shorthand for another).
- Avoid exaggerated adjectives ("enormous", "deadly") unless quantified and defensible.

LLM action: Do not alter numbers; instead tighten wording around them, standardise the presentation (per venue) and add margin queries for missing totals or possible misinterpretations.

---

### 4.8 Citations, references and footnotes

#### Reference list integrity

- Every cited work must be in the reference list; the list must contain only cited works.

#### Citation placement and density

- Avoid citations in the first paragraph.
- Do not cite sources for basic facts that can be found anywhere.
- Avoid scattershot citations; collate them so they serve the reader.

LLM action: Move or consolidate citations; add margin notes when a citation seems irrelevant or when the claim needs a source.

#### Footnote discipline

- Don't use footnotes to expand the text (especially in the first paragraph).
- Use footnotes for necessary clarifications, source details or venue-required apparatus.

LLM action: Move essential content into the main text; delete non-essential footnote expansions.

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

### 4.9 Metaphors, cliches and rhetorical control

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
- **600 DPI**: ensures crisp reproduction in print, on slides, and on retina screens.
- **Maroon for slide chrome, plum for data**: projected slides need a warm, high-contrast accent for UI elements; printed/PDF figures benefit from a deeper, cooler primary that reproduces well across devices. Graphs embedded in LEAP slides use the graph palette (plum, blue, sage, gold...), not the slide maroon.
