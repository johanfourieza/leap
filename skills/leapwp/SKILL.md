---
name: leapwp
description: Turn a finished paper into a LEAP working paper and file it on the shelf. Handles the front matter intake (co-authors, acknowledgements, AI disclosure), the title footnote and cite-as line, the author block, the aea bibliography and its full-given-names audit, versioned file naming, rebuilding the figures in the LEAP palette from a copy of the plotting script, a clean compile, the machine-readable Markdown twin for AI and crawler readers, and the copy of both files into 1Research/WorkingPapers with archiving of superseded versions. Trigger with "/leapwp path/to/paper.tex", "make this a working paper", "put this on the working paper shelf", "package this for circulation".
user-invocable: true
argument-hint: <path to the .tex file, or the folder holding it>
---

# LEAP Working Paper

This skill takes a finished paper and makes it circulable: front matter, disclosure,
citation, versioned filename, clean build, shelf copy. It is the last step in a
project, not the first.

Its companion is `/leapstyle`, which shapes the paper while it is being written:
preamble, section structure, figures, slides, prose. Load `/leapstyle` when the
question is *how should this paper read*. Load this skill when the question is
*how does this paper get posted*.

## Usage

```
/leapwp path/to/paper.tex        # package that file as a working paper
/leapwp path/to/folder           # find the manuscript in that folder, then package it
/leapwp                          # ask which paper, then package it
```

## What this skill does

1. Find the source manuscript and read it.
2. Collect the front matter that a circulated paper needs but a journal draft does not.
3. Write a **new versioned `.tex`** — never over the file that was read.
4. Fit the preamble, title footnote, author block and title page.
5. Install `aea.bst` and audit the bibliography for full given names.
6. Rebuild the figures in the LEAP palette, from a copy of the plotting script.
7. Compile clean, then look at page 1.
8. Build the Markdown twin.
9. Copy the PDF **and the `.md`** to the shelf and archive anything they supersede.
10. Report both paths and everything still outstanding.

It does not rewrite the paper. If the prose or structure needs work, that is
`/leapstyle writing` or `/leapstyle paper`, and it happens before this skill runs.
Figures are the exception: they are rebuilt here, in the house palette, because a
working paper should look like one whatever the journal asked for (Step 9).

---

## Step 1: Find the source

If given a folder, look for the manuscript rather than guessing: the largest `.tex`
with a `\documentclass{article}`, or the one whose name matches the project. Journal
submission folders often hold two — a full version and an anonymised one. **Prefer
the anonymised file only if it is the more recent of the two**, and expect to have to
put the author details back.

Read the whole manuscript before writing anything. In particular, find:

- an existing `\thanks{}` or acknowledgements block,
- any generative-AI declaration (often near the end, Elsevier-style),
- a data availability statement,
- whether a supplement, appendix or second `.tex` travels with it.

### Journal submission packages

A paper coming back from a journal has usually had its front matter stripped out of
the `.tex` and parked in a separate file. Before asking Johan for anything, look for
and read:

| File | What it usually carries |
|---|---|
| `title_page.docx` / `.tex` / `.txt` | Authors, affiliation, correspondence, keywords, JEL, acknowledgements, funding, AI declaration, data availability |
| `cover_letter.tex` | Occasionally the funding line |
| `README.md` in the project root | Target journal, submission dates, what compiles against what |

Read a `.docx` by unzipping `word/document.xml` and stripping the tags:

```powershell
Add-Type -AssemblyName System.IO.Compression.FileSystem
$zip = [System.IO.Compression.ZipFile]::OpenRead("title_page.docx")
$entry = $zip.Entries | Where-Object { $_.FullName -eq "word/document.xml" }
$reader = New-Object System.IO.StreamReader($entry.Open())
$xml = $reader.ReadToEnd(); $reader.Close(); $zip.Dispose()
($xml -replace '</w:p>', "`n") -replace '<[^>]+>', ''
```

Everything harvested this way is the author's own text. Use it verbatim rather than
asking again, and say in the report where each element came from.

---

## Step 2: Front matter intake

Collect the three facts below. Ask only about what is missing: if the target file or
its title page already carries a complete acknowledgement, verify it and say so
rather than asking again. Never invent an acknowledgement, a co-author or a model
version.

Put whatever genuinely remains unknown into a single `AskUserQuestion` batch:

1. **Co-authors.** Names and author order. Offer "Solo paper" and "Same as the last
   paper" as options. Each co-author gets their own affiliation footnote on
   `\author`.
2. **Acknowledgements.** Who to thank: readers and commenters, seminar and conference
   audiences, funders, research assistants, archivists. Offer "None", "Reuse the
   block from my last working paper" (look for a recent `\thanks{}` under
   `0Claude0/1Research/` and show it before reusing) and free text.
3. **AI models used.** Detect first, then confirm. The Claude model is the one running
   the session. The Codex model can usually be read from `~/.codex/config.toml`. Ask
   outright for anything that cannot be determined. Do not guess a version number.

**The manuscript's own declaration wins.** When the paper or its title page already
records which AI tools were used, that is the author's record of the actual work, and
it beats whatever the current config happens to say. Use it, and flag the difference
rather than silently replacing it with today's model names. If that declaration names
a tool but no version — "the author used Claude Code" — carry the sentence across
without a version number and offer to add one, rather than inventing it.

---

## Step 3: Preamble

Replace the preamble of the target `.tex` with the following, preserving the file's
own `\title`, `\author`, `\date` and any custom commands used in its body.

> Mirrored from `/leapstyle` Part 1. If one changes, change both.

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
markers, quotation marks and en dashes are not recoverable when a reader copies text
out of the file. `lmodern` is metrically identical to Computer Modern, so the paper
looks the same and paginates the same.

A paper that already carries most of this will usually be missing exactly those two
packages. Add them rather than rewriting a preamble that is otherwise correct, and
leave the paper's own custom commands, `\usepackage` lines and macros alone.

---

## Step 4: Title footnote

The title carries one `\thanks{}` with three elements, always in this order:
acknowledgements, then the AI disclosure, then the citation.

```latex
\title{Paper Title\thanks{%
We thank [names] for helpful comments, and [funder] for financial support.
This paper was created with the help of Anthropic's Claude Code (Opus 5) and
OpenAI's Codex (GPT-5.5).
Cite this paper as: Fourie, Johan. 2026. ``Paper Title.'' Working Paper,
Department of Economics, Stellenbosch University.}}
```

Rules:

- **The AI disclosure is permanent.** Every LEAP working paper carries it. Only the
  model names inside the sentence change. If only one tool was used, name only that
  one; keep the sentence otherwise identical.
- **The citation title must match `\title` exactly**, character for character,
  including capitalisation and any subtitle.
- **Co-authors in the citation** follow AEA name order: `Fourie, Johan, and Krige
  Siebrits. 2026. ...` -- first author inverted, the rest in natural order. The comma
  before `and` is part of the AEA citation format. It is a deliberate, documented
  exception to the house rule against the serial comma, and an editing pass must not
  remove it.
- **The citation carries no URL.** It ends at `Stellenbosch University.` A working
  paper should not depend on a repository being created before it can be cited. If a
  particular paper genuinely needs a link -- a published DOI, a registered
  pre-analysis plan -- add it only when the author asks, and only once the link
  resolves.
- **Solo papers say "I thank".** Copy the author's own voice from the source
  acknowledgement; do not convert it to "we".
- Keep the whole footnote in continuous prose. No bullet lists, no line breaks between
  the three elements.

---

## Step 5: Author block

The affiliation is `Department of Economics, Stellenbosch University` -- not LEAP.
LEAP branding belongs on slides and figures, not on the paper's front page. A journal
title page that reads "LEAP, Department of Economics" is trimmed back to the
department here.

```latex
\author{Johan Fourie\thanks{Department of Economics, Stellenbosch University.
Email: \href{mailto:johanf@sun.ac.za}{johanf@sun.ac.za}.}}
\date{}
```

With co-authors, each author carries their own footnote in the same form:

```latex
\author{Johan Fourie\thanks{Department of Economics, Stellenbosch University.
Email: \href{mailto:johanf@sun.ac.za}{johanf@sun.ac.za}.}
\and Krige Siebrits\thanks{Department of Economics, Stellenbosch University.
Email: \href{mailto:ksiebrits@sun.ac.za}{ksiebrits@sun.ac.za}.}}
```

Leave `\date{}` empty. No date is printed.

---

## Step 6: Title page

1. Page 1 contains `\maketitle`, the abstract, keywords and JEL codes only.
2. Format keywords and JEL codes as:
   ```latex
   \end{abstract}
   \vspace{1em}\noindent\textbf{Keywords:} keyword1; keyword2; keyword3

   \vspace{0.25em}
   \noindent\textbf{JEL codes:} X00; Y00; Z00

   \vspace{0.5em}
   ```
3. Insert `\newpage` before `\section{Introduction}` so the body always starts on
   page 2.

### Data availability

If the source package carries a data availability statement -- journals increasingly
require one, and it usually sits on the title page -- keep it. It belongs in the
posted PDF, because a working paper circulates without the title page that carried
it. Put it as an unnumbered section immediately before the bibliography, not on
page 1:

```latex
\section*{Data availability}

The datasets discussed ... are archived at the Laboratory for the Economics of
Africa's Past (LEAP), Stellenbosch University, and are available on request.
```

Convert bare author-year references in it to `\citep{}` so it stays consistent with
the rest of the paper. If the source has no such statement, do not invent one.

---

## Step 7: Bibliography

Use `aea.bst`, the official American Economic Association style. It prints full first
names, inverts the first author and preserves title case, which is the format the
paper's own citation line uses.

```latex
\bibliographystyle{aea}
\bibliography{references}
```

Place both commands at the end of the document, before `\end{document}`. A journal
draft will usually arrive with `\bibliographystyle{agsm}` or similar; replace it.

`aea.bst` is not in the standard MiKTeX or TeX Live tree. **Copy `assets/aea.bst`
from this skill folder into the paper's directory, beside the `.tex` file.** That is
also what Overleaf, arXiv and co-authors need, so the file travels with the paper
rather than with the machine.

### Full first names, and never inventing one

Every reference-list entry carries the authors' full given names. `aea.bst` prints
whatever the `.bib` holds, so this is a rule about the `.bib` file, not about the
style. Grep the `.bib` for `author =` lines and read the list: single-letter and
initial-only given names stand out immediately.

When an entry has only initials, resolve it in this order:

1. **DOI present**: query Crossref at `https://api.crossref.org/works/<doi>` and take
   the `author[].given` field. This is authoritative *when it holds a name*. For
   articles digitised retrospectively -- anything mid-century, and much of the older
   Africanist and Afrikaans literature -- Crossref carries the initials the printed
   page carried, and resolves nothing. Move on rather than reporting it as checked.
2. **No DOI, or Crossref returns initials**: use the publisher or journal landing
   page, an ORCID record, an institutional or obituary page, or the title page of the
   paper itself. One citable source per name, and record which source gave it.
3. **Still unresolved**: ask Johan. List the entries, with what you tried, and wait.
   Do not hold the build for this -- compile, file the paper, and ask in the report.
4. **Never** expand an initial from memory, and never infer a first name from an
   initial and a surname. `J. Smith` is not Johan, John or Jane until a source says
   so.

An author who published under initials by preference is a legitimate exception. When
Johan says to keep one, keep it, and note in the report that the entry is a recorded
exception rather than an unresolved gap.

Report at the end: which names were resolved and from where, which are recorded
exceptions, and which are still initials.

Editing a `.bib` shared with a live journal submission is fine — expanding given
names changes nothing in styles that abbreviate them, so the submitted PDF still
renders identically. Say that you touched the shared file.

For a full adversarial audit of the `.bib` -- hallucinated references, chimeric
references, wrong years -- run `/kris`. The first-name pass here is the narrow check
that runs as part of packaging.

---

## Step 8: File naming and versioning

A packaged paper is saved under the `/tyler` naming scheme, with a version suffix:

```text
<AuthorInitials>_<FirstThreeTitleWords>_v<N>.tex
```

- **Initials** follow the author count:
  - one author: that author's initials, `JF`;
  - two authors: both sets of initials, `JF_KS`;
  - three or more: the first author's initials and `_EtAl`, `JF_EtAl`.
- Initials are formed per author: `Johan Fourie` becomes `JF`, `Dieter von Fintel`
  becomes `DvF`. Name particles (van, von, de, der) keep their lower-case initial.
- **Title words** are the first three alphanumeric words of `\title`, CamelCased,
  stopwords included: `Writing in the Age of AI` gives `WritingInThe`.
- **Version** is `_v1` for the first packaged draft, then `_v2`, `_v3` and so on.

| Authors | Title | File |
|---|---|---|
| Johan Fourie | Writing in the Age of AI | `JF_WritingInThe_v1.tex` |
| Johan Fourie and Krige Siebrits | Writing in the Age of AI | `JF_KS_WritingInThe_v1.tex` |
| Fourie, Inwood and Mariotti | Discrimination After Hiring | `JF_EtAl_DiscriminationAfterHiring_v1.tex` |
| Dieter von Fintel | The Remarkable Wealth of the Cape | `DvF_TheRemarkableWealth_v1.tex` |

The two-author case is a deliberate divergence from `/tyler`, which writes `_EtAl` for
any paper with more than one author. Two-author papers are common enough here that
both names are worth carrying in the filename. Do not "correct" this back to match
`tyler/convert.py`.

Rules:

- **Never overwrite.** Before writing, find the highest existing version of the stem
  and write the next one. If none exists, write `_v1`.

  ```bash
  ls <stem>_v*.tex 2>/dev/null | sed -E 's/.*_v([0-9]+)\.tex/\1/' | sort -n | tail -1
  ```

- **Leave the previous version in place.** Copy the source to the new name and edit
  the copy; do not touch the file that was read. Separating versions is the point of
  the scheme. Report both paths: what was read, what was written.
- **The sources stay in the project folder**, beside the `.bib`, `aea.bst` and the
  figures, where the paper actually compiles. Do not move them to the shelf and do not
  restructure the project to package a paper.
- **Recompute the stem** from the current `\title` and `\author` on every run. If the
  title has changed enough to change the stem, versioning restarts at `_v1` under the
  new stem. Say so explicitly, so it is not mistaken for lost history.
- **Only the `.tex` is renamed.** `references.bib`, `aea.bst`, figures and data keep
  their names, and `pdflatex` names the PDF and the build artefacts after the `.tex`
  on its own.
- **Do not rename when the metadata is not safe**: a placeholder title such as `Paper
  Title`, a missing or implausible author, or initials shorter than two or longer than
  five characters. Keep the existing filename and say why.
- **Check for dependants first.** If another `.tex` in the folder `\input`s or
  `\include`s the target, renaming breaks it. Report this and ask before proceeding.

---

## Step 9: Figures in the LEAP palette

Every LEAP working paper carries the house palette in its figures. A journal
submission often does not — editors ask for greyscale, or for their own sizes and
formats — and **that artwork, and the script that produced it, must never be
touched.** The working paper therefore gets its own figures, built by its own copy
of the script.

1. **Find the script** that builds the paper's figures. It is usually one file
   under `code/`, `scripts/` or `replication/` with the `ggsave` calls in it. The
   project README normally names it.
2. **Copy it** to `leap_figures/<stem>_figures.R` beside the paper. Work only on
   the copy, from here on.
3. **Apply `/leapstyle graph` to the copy**: insert the LEAP visual identity block,
   replace the paper's own theme with `theme_leap()`, map the series onto the
   palette in order of importance (plum, blue, sage, gold, then rose, teal, earth,
   mint), and save through `save_leap_fig()` at 10 x 6 inches and 600 dpi.
4. **Redirect its output directory** to `leap_figures/`, so the run cannot overwrite
   the submitted artwork. Check for a `FIG_DIR`-style constant near the top and for
   any hard-coded paths further down.
5. **Re-run it.** A restyled script that has not been executed changes nothing:

   ```powershell
   & 'C:\Program Files\R\R-4.5.2\bin\Rscript.exe' 'leap_figures\<stem>_figures.R'
   ```

6. **Point the working paper at the new files** — either `\graphicspath{{leap_figures/}}`
   or the individual `\includegraphics` paths — and recompile.
7. **Look at the figures in the rebuilt PDF.** A palette swap can destroy a
   greyscale-encoded distinction: a chart that separated two series by fill pattern
   or shade may now use two colours that carry no ordering.

**Check for the silent grey fallback before you run anything.** A script can carry
the palette, name the right colours, and still produce a grey figure:

```r
scale_color_manual(values = c("Significant" = LEAP_COLORS["plum"]))   # WRONG
scale_color_manual(values = c("Significant" = LEAP_COLORS[["plum"]])) # right
```

`LEAP_COLORS["plum"]` is a *named* element, so the vector's name becomes
`Significant.plum`, ggplot2 matches no level, and it falls back to `grey50` without
a warning. The figure looks deliberate. Grep every script you touch:

```bash
grep -n 'LEAP_COLORS\["' script.R      # then check each hit inside a scale_*_manual
```

Direct aesthetics — `geom_point(colour = LEAP_COLORS["plum"])` — are unaffected, so
only the `scale_*_manual` hits matter. Fix them with `[[ ]]` or `unname()`. If a
paper's figures are grey where the script clearly intends colour, this is why.

Rules:

- **Never edit the submitted script or the submitted figures.** The whole point of
  the copy is that the journal package stays byte-identical.
- **Accessibility beats variety.** When a figure must work for colour-blind readers,
  use plum, blue, gold and teal, and keep any line type or shape distinctions the
  original had.
- **When the script cannot be run** — data not on this machine, packages missing, an
  hour of runtime, an API key — do not fake it and do not hand-edit the figure files.
  Package the paper with the figures it has and say plainly in the report that the
  house palette was not applied and why.
- **Not every figure comes from a script.** Maps exported from QGIS, scanned plates,
  diagrams drawn by hand: leave them, and say so.
- The restyled script stays in the project folder with the paper. It is part of how
  the working paper rebuilds, not a throwaway.

## Step 10: Compile and look at it

```bash
pdflatex -interaction=nonstopmode <stem>.tex
bibtex <stem>
pdflatex -interaction=nonstopmode <stem>.tex
pdflatex -interaction=nonstopmode <stem>.tex
```

The build must end with no undefined citations, no undefined references and no
"Label(s) may have changed" warning. If the last warning survives, run `pdflatex`
once more; if an `Undefined citation` survives, the `.bib` key is wrong and that is a
content problem to report, not to paper over.

Then **read page 1 and 2 of the compiled PDF** rather than trusting the source. This
is the step that catches a title footnote overflowing onto page 2, a `\thanks` that
swallowed the abstract, an author footnote marker on the wrong name, and a first
section that did not start on page 2. Read one page from the reference list too, to
confirm `aea.bst` took and the given names print in full.

Delete the build logs you created. Leave `.aux`, `.bbl` and `.blg` — they are how the
paper rebuilds.

---

## Step 11: The Markdown twin

Every working paper ships as two files: the typeset PDF for people, and a Markdown
version for machines. The `.md` is what Johan posts alongside the PDF on
johanfourie.com so that crawlers and AI assistants can read the work without
parsing a PDF.

The reasoning is worth keeping in view, because it decides what the file must get
right. A PDF encodes a print layout, so extracting text from it inverts that layout
and yields column jumps, hyphenated line breaks, running heads, page numbers and
footnote fragments spliced into the body. Markdown arrives already structured:
headings stay headings, emphasis survives, and there is no extraction step to go
wrong. It costs fewer tokens and parses cleanly, and many crawlers index PDFs poorly
or not at all. The `.md` is therefore a faithful **text** mirror, not a replica of
the typeset artefact.

Build it with `assets/make_md.sh` from this skill folder, run from the directory
holding the `.tex` so relative paths resolve:

```bash
bash assets/make_md.sh <stem>              # finds references.bib automatically
bash assets/make_md.sh <stem> refs.bib     # or name the bibliography
```

It runs pandoc from the `.tex` — never from the PDF — and then normalises the
output. What the file contains:

- **YAML front matter** with the title, author and abstract, so a scraper gets the
  metadata without reading the body. Add `doi:` and `cite_as:` fields by hand when
  the paper has a published version of record.
- **A pointer to the PDF**, as a blockquote immediately under the front matter.
- **The full text**, including footnotes, with headings as real Markdown headings.
- **Citations and the reference list resolved** by `--citeproc` against the same
  `.bib` the paper uses, so the Markdown's references match the PDF's.
- **Mathematics as LaTeX**, `$x$` and `$$...$$`. Do not convert it to images or
  Unicode: LaTeX is what models read natively, and pandoc's default fenced
  ```` ``` math ```` blocks are normalised to `$$` by the script.
- **No figures.** Each one becomes `*[Figure not reproduced here — see
  <stem>.pdf]*`, with its caption kept underneath. The caption carries the finding;
  the image lives in the PDF.

Rules:

- **Generate from the `.tex`, never from the PDF.** Text scraped out of a PDF
  reproduces exactly the mangling this file exists to avoid.
- **Same stem, same version.** `JF_WritingIsNot_v3.pdf` is accompanied by
  `JF_WritingIsNot_v3.md`. A supplement gets its own twin on the same rule.
- **Build it after the PDF compiles clean**, from the same source, so the two cannot
  disagree.
- **Check the word count** against the PDF's. A large shortfall means pandoc dropped
  an `\input` fragment or a custom macro; investigate rather than shipping it.
- When the paper's source is Word rather than LaTeX, build the `.md` from the
  assembled `.tex` that produced the PDF, so both come from one source.

## Step 12: The shelf

Every working paper is also filed in one central place:

```text
C:\Users\johanf\Dropbox\0Claude0\1Research\WorkingPapers\
```

After the paper compiles cleanly, copy **the PDF and the `.md`** there, under the
same versioned name as the `.tex`. Nothing else goes to the shelf — not the source,
not the figures, not the `.bib`. The top level holds the current version of each
paper; every superseded version moves down into `archive\`:

```text
1Research\WorkingPapers\
  JF_BabiesAsIndustrial_v2.pdf        <- current
  JF_BabiesAsIndustrial_v2.md
  JF_KS_InvisibleHandedness_v3.pdf    <- current
  JF_KS_InvisibleHandedness_v3.md
  archive\
    JF_BabiesAsIndustrial_v1.pdf
    JF_BabiesAsIndustrial_v1.md
    JF_KS_InvisibleHandedness_v1.pdf
    JF_KS_InvisibleHandedness_v2.pdf
```

The copy step, in order:

1. Compile, then build the `.md`. Do not copy anything until the build is clean. A
   shelf copy that does not match a compiling source is worse than no copy.
2. Move every existing top-level `.pdf` **and `.md`** whose stem matches the new one
   into `archive\`, creating `archive\` if it does not exist. Match on the stem
   before `_v<N>`, so `JF_BabiesAsIndustrial_v1.*` is superseded by
   `JF_BabiesAsIndustrial_v2.*` but an unrelated paper is left alone.
3. Copy the new PDF and the new `.md` to the top level.

Rules:

- **Never overwrite, on the shelf or in the archive.** The version suffix makes every
  build a distinct file, so a copy that would overwrite means the version was not
  incremented. Stop and fix the version rather than overwriting. (Re-copying the same
  version after a late fix within one session is the one exception, and say that you
  did it.)
- **Archive, never delete.** A superseded version moves; it does not disappear.
- **One current version per paper.** After the copy, exactly one PDF and one `.md`
  per stem sit at the top level. If two remain, the archiving step missed one -- say
  so rather than leaving it.
- **Never a PDF without its `.md`.** They are one deliverable; a stem with only one
  of the two on the shelf is an incomplete copy step.
- Report both paths when handing back: the source `.tex` and the shelf PDF and `.md`,
  plus anything moved to `archive\`.

### The website

The `.md` files are uploaded to johanfourie.com beside the PDFs, and the research
page carries one sentence saying so, along these lines:

> Each working paper is also available as a Markdown file, which is easier for AI
> assistants and other automated readers to process than a PDF.

`/research-sync` publishes the downloadable working papers to the site; when it runs,
the `.md` travels with the PDF and that sentence stays on the page.

---

## Supplementary documents

A paper that has a supplement -- an analytical appendix, a derivation, proofs, data
documentation -- gets the supplement packaged and versioned alongside it. The two are
one deliverable.

```text
JF_WritingIsNot_v2.tex        JF_WritingIsNot_v2.pdf
JF_WritingIsNot_sup_v2.tex    JF_WritingIsNot_sup_v2.pdf
```

- **The version number is always the paper's**, never the supplement's own count. If
  the paper goes to `_v3`, rebuild the supplement as `_sup_v3` even when nothing in it
  changed. A reader holding `_sup_v3` must be able to assume it belongs to `_v3`
  without checking. Lockstep is the whole point: a supplement that versions
  independently is a supplement that will one day document a paper that no longer
  exists.
- **Keep it in the paper's folder**, next to the `.tex` it supports, whatever directory
  the source was drafted in.
- **The author block is the author.** Write `\author{Johan Fourie\thanks{Department of
  Economics, Stellenbosch University. Email: ...}}`, exactly as in the paper. Do not
  put a description such as "Supplementary material to ..." in the `\author` slot; the
  relationship belongs in the title footnote.
- **The title footnote names the parent, then discloses, then cites the parent.** A
  supplement is not cited on its own: the cite-as line points at the paper, so anyone
  quoting the derivation credits the article.

  ```latex
  \title{\emph{Paper Title}: analytical supplement\thanks{%
  This is the supplementary material for Fourie, Johan. 2026. ``Paper Title.''
  Working Paper, Department of Economics, Stellenbosch University.
  This paper was created with the help of [models].
  Cite the paper, not this supplement.}}
  ```

- **Share the paper's bibliography.** Use the same `.bib` and `aea.bst` as the paper
  rather than a hand-maintained `thebibliography` block. A manual list drifts out of
  step with the paper and almost always carries initials instead of full given names.
- **Both PDFs and both `.md` files go to the shelf**, and all four archive together
  when the version bumps. Never leave `_v3` on the shelf beside `_sup_v2`.

---

## Minimal working example

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

\title{Writing in the Age of AI\thanks{%
We thank Krige Siebrits and seminar participants at Stellenbosch University for
helpful comments. This paper was created with the help of Anthropic's Claude
Code (Opus 5) and OpenAI's Codex (GPT-5.5). Cite this paper as: Fourie, Johan.
2026. ``Writing in the Age of AI.'' Working Paper, Department of Economics,
Stellenbosch University.}}
\author{Johan Fourie\thanks{Department of Economics, Stellenbosch University.
Email: \href{mailto:johanf@sun.ac.za}{johanf@sun.ac.za}.}}
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

\bibliographystyle{aea}
\bibliography{references}

\end{document}
```

---

## Front-page checklist

Before handing back a working paper, confirm:

- [ ] Title footnote has all three elements, in order: acknowledgements, AI
      disclosure, citation.
- [ ] The citation title matches `\title` exactly, and the citation ends at
      "Stellenbosch University." with no URL.
- [ ] Every author has an affiliation footnote reading "Department of Economics,
      Stellenbosch University", with an email. No "LEAP" on the front page.
- [ ] `\date{}` is empty.
- [ ] Abstract, keywords and JEL codes are on page 1; Section 1 starts on page 2 --
      verified by reading the PDF, not the source.
- [ ] `aea.bst` sits beside the `.tex`, and `\bibliographystyle{aea}` is set.
- [ ] Every reference-list entry has full given names, or is on the reported list of
      unresolved initials or recorded exceptions.
- [ ] The build runs clean: `pdflatex`, `bibtex`, `pdflatex`, `pdflatex`, with no
      undefined citations or references.
- [ ] The file is saved as `<AuthorInitials>_<ThreeTitleWords>_v<N>.tex`, the version
      is one higher than any already in the folder, and the previous version is still
      on disk.
- [ ] The figures carry the LEAP palette, rebuilt by a copy of the plotting script in
      `leap_figures\`; the submitted script and the submitted artwork are untouched.
      Any figure left in its original style is named in the report, with the reason.
- [ ] The Markdown twin is built from the `.tex`, carries YAML front matter and the
      pointer to the PDF, keeps the mathematics as LaTeX, and its word count is close
      to the PDF's.
- [ ] The compiled PDF **and the `.md`** are copied to `1Research\WorkingPapers\`
      under the same versioned name, any superseded version of the same stem has
      moved to `archive\`, and nothing was overwritten or deleted.
- [ ] Any supplement is built as `<stem>_sup_v<N>` with the paper's own version
      number, sits in the paper's folder, and is on the shelf beside it, with its own
      `.md`.

## The report

Hand back, in this order:

1. **Written** and **Shelf** paths, plus anything moved to `archive\`.
2. Build result: page count, and that it was clean.
3. What changed, briefly — de-anonymisation, preamble additions, bibliography style,
   anything harvested from a title page and where it came from.
4. Anything you decided on the author's behalf, so it can be reversed in one word: an
   AI disclosure carried across without a version number, a data availability
   statement kept, a structural departure left alone.
5. Open questions — unresolved given names above all — asked as questions, not buried
   in prose.

If `/leapstyle`'s introduction or conclusion audit would flag something, mention it in
one line and leave the text alone. Packaging does not rewrite a paper, and a survey or
a review will legitimately depart from the AER shape.

---

## Acknowledgements

`assets/aea.bst` is the American Economic Association's BibTeX style (version
2009.05.20), distributed by the AEA. The naming scheme is shared with `/tyler`; the
house style this skill packages is `/leapstyle`.
