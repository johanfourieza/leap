# LEAP

Resources for Johan Fourie's research group ([LEAP](https://leapstellenbosch.org/), Stellenbosch University).

## Skills

### `/leapstyle` — LEAP house style

A [Claude Code](https://claude.ai/claude-code) skill that applies the LEAP Economics house style to your research outputs.

| Command | What it does |
|---------|-------------|
| `/leapstyle paper myfile.tex` | Apply the LEAP working paper template to a LaTeX article |
| `/leapstyle slides myfile.tex` | Apply the LEAP beamer slide template to a presentation |
| `/leapstyle graph myscript.R` | Apply the LEAP graph identity (colours, theme, export) to an R script |

### `/ehrstyle` — Economic History Review submission style

A Claude Code skill that applies the *Economic History Review* house style (Notes for Contributors, Feb 2026 v1) to a LaTeX manuscript for EHR submission. Includes a bespoke biblatex style (`echr.bbx` + `echr.cbx`) that produces EHR footnote references with short-title form and *ibid.*/*idem* handling, surname-first bibliography, *"2nd ser."* / roman-volume handling for pre-1992 EHR citations, working-paper exclusion, UK -ize spelling, Oxford commas, and EHR-specific capitalisation rules (e.g. lower-case *global financial crisis*).

| Command | What it does |
|---------|-------------|
| `/ehrstyle paper [file]` | Install preamble + `echr.bbx`/`echr.cbx`; switch to EHR style; walk through anonymisation, double-spacing, section CAPS, subsection flattening |
| `/ehrstyle bib [file]` | Audit `references.bib`: add `skipbib=true` to non-published entries; add `shorttitle` where titles >5 words |
| `/ehrstyle titlepage` | Copy the anonymous-submission title page template |
| `/ehrstyle coverletter` | Copy the cover letter template |
| `/ehrstyle check [file]` | Audit a draft against EHR style rules (spelling, Oxford commas, capitalisation, numbers, dates) |

### `/subcom` — DHET subsidy-committee adjudication

A Claude Code skill that runs the full first-pass adjudication pipeline for South African DHET research-output subsidy submissions (books and book chapters). Given a project directory with policy docs, CSV manifests, and per-submission PDF folders, it produces a committee-ready scoring spreadsheet, a flagged shortlist, and a consolidated markdown dossier.

| Command | What it does |
|---------|-------------|
| `/subcom <dir>` | Run the full pipeline on a submission directory |
| `/subcom` | Run on the current working directory |

Pipeline stages:

1. **Ingest check** — cross-reference the CSV manifests against the `Docs/` folder; report missing submissions and incomplete dossiers.
2. **Per-submission adjudication** — spawn one subagent per book/chapter (in parallel waves) to read each submission's peer-review evidence, written justification, publisher letter, and book front matter; writes a structured `adjudication.md` per folder.
3. **Aggregation** — parse every `adjudication.md` into `outputs/master_scores.xlsx`, `outputs/flagged_shortlist.md`, and `outputs/all_adjudications.md`.

Each adjudication scores the submission 0–5 against the seven DHET criteria (publisher/ISBN, length, peer review, originality, excluded categories, scholarly contribution, documentation), assigns an eligibility tri-state (TRUE / FALSE / UNCERTAIN), and logs specific flag codes. Claude is a first-pass recommender, not the final adjudicator; the committee reviews every case and can override.

### Colour palette

| Role | Name | Hex | Sample |
|------|------|-----|--------|
| Primary | plum | `#5C2346` | ![#5C2346](https://placehold.co/40x20/5C2346/5C2346) |
| Secondary | blue | `#3D8EB9` | ![#3D8EB9](https://placehold.co/40x20/3D8EB9/3D8EB9) |
| Tertiary | sage | `#6B8E5E` | ![#6B8E5E](https://placehold.co/40x20/6B8E5E/6B8E5E) |
| Quaternary | gold | `#D4A03E` | ![#D4A03E](https://placehold.co/40x20/D4A03E/D4A03E) |
| Extended | rose | `#A34466` | ![#A34466](https://placehold.co/40x20/A34466/A34466) |
| Extended | teal | `#45808B` | ![#45808B](https://placehold.co/40x20/45808B/45808B) |
| Extended | earth | `#8B6B3D` | ![#8B6B3D](https://placehold.co/40x20/8B6B3D/8B6B3D) |
| Extended | mint | `#97C5B0` | ![#97C5B0](https://placehold.co/40x20/97C5B0/97C5B0) |
| UI accent | maroon | `#7A0019` | ![#7A0019](https://placehold.co/40x20/7A0019/7A0019) |

For colour-blind safe work, use the four-colour subset: **plum + blue + gold + teal**.

## Installation

```bash
git clone https://github.com/johanfourieza/leap ~/.claude/skills/leap
```

After installation, `/leapstyle` will be available in all your Claude Code sessions.

## Design principles

The style follows Tufte, Cleveland & McGill, and Few:

- **Horizontal gridlines only** — aids value judgements without clutter
- **Bottom + left spines only** — removes non-data ink
- **No bar borders** — except white separators for grouped bars
- **600 DPI export** — crisp on screen, print, and retina displays
- **1.5 line spacing** in papers — standard economics working paper convention

## License

MIT. Use freely, adapt as needed.
