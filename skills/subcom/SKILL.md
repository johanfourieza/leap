---
name: subcom
description: DHET research-output subsidy adjudication for the Stellenbosch University subsidy committee. Use when Johan says "/subcom <dir>" or asks to adjudicate book/chapter submissions against South African Department of Higher Education and Training (DHET) criteria. Given a directory with policy docs, a Books/Chapters CSV, and per-submission PDF folders, runs the full first-pass adjudication pipeline and produces a committee-ready scoring spreadsheet, a flagged shortlist, and a consolidated markdown dossier.
---

# /subcom — subsidy-committee adjudication pipeline

Johan chairs the SU committee that evaluates whether books and book chapters submitted for the DHET research-output subsidy meet the Department's criteria. This skill runs the full workflow end-to-end: ingest check, per-submission first-pass adjudication, and consolidation of results.

**Claude is a first-pass recommender, never the final adjudicator.** Every judgement must be grounded in quoted evidence from the submission files; the committee reviews and can override.

## Invocation

Typical usage:
- `/subcom` → operate on the current working directory
- `/subcom <path>` → operate on the given directory

## Expected input layout

The target directory should contain:

```
<project-root>/
├── SCA Workbook ... (Books_...).csv       # authoritative books metadata
├── SCA Workbook ... (Chapters_...).csv    # authoritative chapters metadata
├── Addendum C_Requirements...pdf          # DHET evidence rules (optional — skill has its own distilled rubric)
├── Research Outputs policy 2015.pdf       # DHET definitions (optional)
├── Docs/
│   ├── Books/B<n>/                        # one folder per book (ID from CSV)
│   │   └── <any>.pdf                      # book PDF + peer review + justification + ...
│   └── Chapters/CH<n>/                    # one folder per chapter
└── (outputs/, rubric/, scripts/ get created by the skill)
```

The CSV columns the skill expects: `Book Number` / `Chapter No.`, `Nomination ID`, `Publication URL`, `Faculty`, `Department`, `Year`, `Output Year`, `Category`, `Book title`, `Authors`, `Publisher`, `Start Page`, `End Page`, `Total Pages`, `Links`, `Additional Comments` or `Status` (for chapters: also `Chapter title`).

If the CSVs use different names, ask Johan to confirm the mapping — do not guess.

## Pipeline

### Step 1 — Install rubric + scripts into the project

Copy these skill resources into the project root if they don't already exist:
- `rubric/dhet_criteria.md` → authoritative seven-criteria checklist
- `rubric/scoring_rubric.md` → 0–5 scientific-contribution scale + flag vocabulary
- `scripts/01_ingest_check.R` → ingest auditor
- `scripts/02_aggregate.R` → aggregation

Use Bash `cp` preserving the existing files if they're already there (Johan may have edited them).

### Step 2 — Ingest check

Run `Rscript scripts/01_ingest_check.R` from the project root.

Windows note: Git Bash's `Rscript` usually isn't on PATH — use the explicit Windows path e.g. `/c/Program\ Files/R/R-4.5.2/bin/Rscript.exe`. Run the script in the background and read its output file when it's done (R startup on Windows is slow; don't sit blocking).

Report to Johan: total submissions per type, how many folders exist / are missing, how many have likely-complete vs flagged source files. If many folders are missing, tell Johan which IDs and stop — downloads are his part of the workflow.

### Step 3 — Per-submission adjudication

For every submission with a populated folder **and no existing `adjudication.md`** (or only a Claude-written one without `# HUMAN REVIEWED`), spawn **one subagent per submission** to write its `adjudication.md` in place.

**Parallelism.** Spawn in waves of up to 8 agents in parallel. Do not sequence — waves are for context management, not for dependency.

**Subagent briefing.** Use `templates/agent_prompt.md` as the base prompt; fill in the per-submission CSV row. Each subagent must:
1. Read `rubric/dhet_criteria.md`, `rubric/scoring_rubric.md`, and `templates/adjudication_template.md` (or `Docs/Books/B1/adjudication.md` if that's the first one already done — it's the canonical example).
2. Read the submission's supporting letters in full (peer review, written justification, publisher/editor letters, SU-affiliation letters — all short).
3. Read the book PDF pages 1–12 only (cover/copyright/TOC/intro). Extend only to resolve a specific criterion (e.g. the end of substantive content for C2 length verification near 60pp).
4. Never read the whole book.
5. Write `adjudication.md` into the submission folder using the template's exact structure.
6. Reply with one line: `{ID} | score=X | eligible=Y | flags=... | one-sentence summary`.

**Important per-submission cues to flag in the agent prompt:**
- Flagged `NO_PEER_REVIEW_FILE` in ingest report → the peer-review letter is probably named generically (e.g. `Letter from OUP.pdf`); tell the agent to check.
- Author has a PhD-thesis PDF in the folder → dissertation-to-book conversion, C4 requires "substantial reworking"; direct the agent to the explanation file and the book's treatment of prior research.
- Publisher is obscure → ask the agent to judge legitimacy (not a vanity/pay-to-publish press).
- Non-English book → C4 requires a one-page English summary; point to it.
- Title contains "How to", "Principles and Applications", "Handbook", "Festschrift", "Complete Works", "Edition/Translation", "Dictionary", "Encyclopedia", "Reference" → flag the relevant excluded-category risk.
- Second or later edition → C4 requires ≥50% new material.
- CSV note mentions late submission / password / SU-affiliation-on-cover / DHET advised splitting volumes → pass this to the agent.

Johan has already adjudicated many of these cases for the 2026 cycle — refer to `Docs/Books/B1/adjudication.md` as the canonical format, and use B26 / B27 / B30 for reference patterns on hard-fail cases (predatory publisher, textbook, and <60pp respectively).

Do not skip the cue-generation step. Lazy "read the folder, adjudicate" prompts produce weaker judgements than prompts that tell the agent what to look for.

### Step 4 — Aggregate

After all adjudications are written, run `Rscript scripts/02_aggregate.R`.

This parses every `adjudication.md` and produces four files in `outputs/`:
- `master_scores.csv` and `master_scores.xlsx` — one row per submission, sortable, committee-ready
- `all_adjudications.md` — all dossiers concatenated with a TOC
- `flagged_shortlist.md` — borderline/problem cases grouped by severity

### Step 5 — Report back

Give Johan a concise summary:
- Adjudicated count (books + chapters)
- Mean score, distribution across the 0–5 bucket
- Hard-fail cases (score 0–1 AND eligible=FALSE) — list these by ID
- UNCERTAIN cases the committee should deliberate
- Paths to the four output files

Do NOT ask him to confirm routine subagent invocations — just run them. DO ask before pushing anywhere external (GitHub, email, shared drives).

## Resuming a partial run

If the skill is invoked on a directory where some `adjudication.md` files already exist:
- Skip submissions with `# HUMAN REVIEWED` at the top of their adjudication.md (the committee's edit is authoritative).
- Skip submissions with any existing `adjudication.md` unless Johan asks for a re-run.
- Process only folders that are missing an adjudication.md.

Always re-run Step 4 (aggregate) — it's cheap and regenerates the outputs.

## Design principles

1. **Evidence over assertion.** Every checklist finding in `adjudication.md` quotes or cites a specific document in the folder.
2. **First-pass, not final.** Claude flags and recommends; the committee decides.
3. **Honest uncertainty.** Default to `eligible=UNCERTAIN` when evidence is missing or ambiguous. Do not approve weak submissions to be helpful.
4. **Targeted reading.** Read supporting letters in full; read the book PDF only enough to verify the criteria. Never read a whole book.
5. **Auditable.** Every dossier is reproducible by reading the files it cites. If DHET audits, the committee can defend every decision.

## Files provided by this skill

- `SKILL.md` — this file
- `rubric/dhet_criteria.md` — the seven DHET criteria with exact Addendum C quotations
- `rubric/scoring_rubric.md` — 0–5 scoring scale + flag vocabulary + eligibility tri-state
- `scripts/01_ingest_check.R` — CSV × Docs/ cross-reference; produces `outputs/ingest_report.csv`
- `scripts/02_aggregate.R` — parses all `adjudication.md` files; produces master scores, flagged shortlist, consolidated markdown
- `templates/adjudication_template.md` — the canonical adjudication format (B1 example)
- `templates/agent_prompt.md` — per-submission subagent prompt template with placeholders
