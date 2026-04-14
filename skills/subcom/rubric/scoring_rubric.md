# Scoring Rubric — NRF 2026 Book/Chapter Adjudication

Every submission gets three outputs in its `adjudication.md`:

1. **`score`** — 0–5 integer, the scientific-contribution score.
2. **`dhet_eligible`** — `TRUE`, `FALSE`, or `UNCERTAIN`.
3. **`flags`** — comma-separated codes from `dhet_criteria.md`.

`score` captures academic merit. `dhet_eligible` captures whether the hard DHET tests (C1–C5, C7) are met. `flags` capture specific issues a human must verify. These are independent: a work can be DHET-eligible but score 2; or score 5 but be flagged `UNCERTAIN` for missing peer-review paperwork.

---

## The 0–5 scientific-contribution scale

| Score | Label | Typical pattern |
|---|---|---|
| **0** | **Not a research output** | Falls in an excluded category (textbook, fiction, translation, dissertation-as-is, commissioned report) or fails a hard eligibility test (no ISBN, <60 pp, zero peer-review evidence). Recommend rejection. |
| **1** | **Seriously deficient** | Multiple criteria weak: e.g. very thin originality **and** generic peer-review letter **and** shallow engagement with literature. Unlikely to survive DHET audit. Recommend rejection unless strong rebuttal. |
| **2** | **Doubtful** | One significant weakness: e.g. peer-review evidence is a generic template; or originality is limited (largely restates prior work); or second edition where <50% looks new. Flag for committee deliberation. |
| **3** | **Borderline / meets minimum** | Criteria just met. Scholarly contribution is modest — a competent survey, or a niche contribution of limited reach. DHET-eligible but the committee may wish to record a weak recommendation. |
| **4** | **Meets all criteria cleanly** | Clear scholarly contribution; original research or substantive conceptual synthesis; documented peer review with named reviewers; reputable publisher; embedded in relevant literature. Routine pass. |
| **5** | **Exemplary** | Significant, original contribution likely to shape the discipline or policy debate; rigorous methodology; robust peer review (reports attached); strong publisher; deep engagement with the field. |

**Guidance.**
- Award 5 sparingly. Most genuinely scholarly works are a 4.
- A score of 3 means "this is borderline — a reasonable committee member could disagree." Always justify with evidence.
- 0 is reserved for clear disqualifications, not for "I don't love it." A weak-but-eligible work is a 2 or 3.

---

## Eligibility tri-state

- **`TRUE`** — All of C1, C2, C3, C4, C5, C7 pass on the evidence available.
- **`FALSE`** — At least one hard criterion fails (e.g. translation, no ISBN, <60 pp, clearly a textbook).
- **`UNCERTAIN`** — Evidence is missing or ambiguous (most commonly: peer-review documentation is thin or absent from the dossier). Committee must verify before deciding.

Default to `UNCERTAIN` when evidence is simply not in the folder — do not assume compliance.

---

## Score vs. eligibility: common combinations

| Combination | Interpretation |
|---|---|
| `score=5`, `eligible=TRUE` | Routine approve. |
| `score=4`, `eligible=TRUE` | Routine approve. |
| `score=3`, `eligible=TRUE` | Approve; flag for minutes if the committee wants to record weak support. |
| `score=3`, `eligible=UNCERTAIN` | Committee must resolve the uncertainty before approving. |
| `score=2`, `eligible=TRUE` | Committee debate. Academically weak but technically compliant. |
| `score=2`, `eligible=FALSE` | Reject — technical failure dominates. |
| `score=0–1`, `eligible=FALSE` | Reject. |
| `score=0–1`, `eligible=TRUE` | Rare; something's wrong with the scoring — re-examine. |

---

## Flag vocabulary

All flag codes are defined in `dhet_criteria.md`. Summary list:

**Hard-fail flags** (generally force `eligible=FALSE`):
`NO_ISBN`, `SHORT`, `NO_PEER_REVIEW`, `TRANSLATION`, `EXCLUDED_TEXTBOOK`, `EXCLUDED_HANDBOOK`, `EXCLUDED_REFERENCE`, `EXCLUDED_FICTION`, `EXCLUDED_COMMISSIONED`, `EXCLUDED_FESTSCHRIFT`, `EXCLUDED_BOOK_REVIEW`, `EXCLUDED_INTRO_ONLY`, `EXCLUDED_DISSERTATION`, `DISSERTATION_NOT_REWORKED`, `2ND_ED_<50PCT_NEW`, `VANITY_PUBLISHER`.

**Soft-fail / committee-review flags** (generally force `eligible=UNCERTAIN`):
`PEER_REVIEW_GENERIC`, `PEER_REVIEW_PROPOSAL_ONLY`, `EDITOR_SELF_REVIEW_UNCLEAR`, `THIN_JUSTIFICATION`, `NO_JUSTIFICATION`, `NON_ENGLISH_NO_SUMMARY`, `MISSING_BOOK_PDF`, `MISSING_JUSTIFICATION`, `MISSING_EDITOR_LETTER`, `MISSING_ENGLISH_SUMMARY`, `LATE_NO_MOTIVATION`.

Use multiple flags where warranted. Flags drive `outputs/flagged_shortlist.md`.

---

## Human-reviewed marker

If an `adjudication.md` begins with the line `# HUMAN REVIEWED`, Stage-4 automation must skip it — the committee's edits are authoritative.
