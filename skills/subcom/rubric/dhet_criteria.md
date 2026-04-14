# DHET Criteria for Books & Book Chapters (2025 submission, returned 2026)

Sources: `Research Outputs policy 2015.pdf` (Sections 6.1–6.2), `Addendum C_Requirements for submission of books_2024.pdf`, `Addendum A Checklist_2025.docx`.

This file is the authoritative checklist Claude uses when adjudicating each submission. Every finding in an `adjudication.md` must map back to one of the seven criteria below.

---

## C1. Publisher & ISBN

**Requirement.** The work must have a valid ISBN; an online book must have an e-ISBN. Publisher must be legitimate (peer-reviewed scholarly publication).

**Evidence to look for.** Copyright page showing ISBN. Publisher name consistent with scholarly/academic publishing. There is no official "recognised publisher" list.

**Fail codes.** `NO_ISBN`, `VANITY_PUBLISHER`.

---

## C2. Length

**Requirement.** Minimum **60 pages**, excluding references, bibliography, index and appendices (above UNESCO's 49-page minimum).

**Evidence.** Total pages on copyright page or CSV `Total Pages` column; verify by deducting back-matter.

**Fail codes.** `SHORT` (<60pp of substantive content).

**Note for chapters.** The chapter itself has no page minimum; the **parent book** must meet the 60-page test. A chapter also only counts if the parent book qualifies as a research-output book.

---

## C3. Peer review evidence

**Requirement (quoted from Addendum C).**
> "Evidence of the pre-publication peer review process must be provided for every book … by the publisher. A mere statement that peer review had taken place is not sufficient."

Specifically:
- Names and affiliations of reviewers must be mentioned (unless review was blind).
- The scope of review must be stated: whole manuscript vs. proposal only.
- Peer review reports should be supplied to support the submission.
- **Generic templates are not accepted.**
- If the editor of an edited book also contributed a chapter, information validating **independent** peer review of that chapter is required.

**Fail / flag codes.** `NO_PEER_REVIEW`, `PEER_REVIEW_GENERIC`, `PEER_REVIEW_PROPOSAL_ONLY`, `EDITOR_SELF_REVIEW_UNCLEAR`.

---

## C4. Originality / new knowledge

**Requirement (quoted from 2015 Policy §6.1).**
A book must be a "peer reviewed, non-periodical scholarly or research publication disseminating original research and developments within specific disciplines," and be either:
> "(a) an extensive and in-depth scholarly treatment of a topic by one or more scholars, largely comprising significant and original (own) research, embedded in relevant literature"; or
> "(b) an extensive and in-depth scholarly exposition … which makes a significant conceptual or empirical synthesis that advances scholarship."

For edited books:
> "a collected work … with individually peer-reviewed chapters by appropriately qualified authors, [generating] a new conceptual synthesis that advances scholarship."

**Required artefact.** A research justification (≤500 words) describing methodology and the unique contribution to knowledge, with an **unequivocal plagiarism / prior-publication declaration** and statement of target audience.

**Special cases.**
- **Dissertations → books.** Require "evidence of substantial reworking and additional research."
- **Second or later editions.** "At least 50% of the publication being claimed must have not been published previously."
- **Translations.** Not eligible.
- **Non-English works.** Require a one-page English summary.

**Fail / flag codes.** `NO_JUSTIFICATION`, `THIN_JUSTIFICATION`, `DISSERTATION_NOT_REWORKED`, `2ND_ED_<50PCT_NEW`, `TRANSLATION`, `NON_ENGLISH_NO_SUMMARY`.

---

## C5. Not an excluded category

**Excluded (Addendum C).**
- Dissertations and theses
- Textbooks, professional handbooks, study guides
- Reference books, dictionaries, encyclopaedias
- Speeches of any kind
- Reports forming part of contract research or commissioned work
- Works of fiction
- Introductions and conclusions alone (unless the entire book is submitted)
- Book reviews
- Second or later editions without substantial new research
- Translations
- Festschrifts (unless proven to contain original research)
- Works titled "Handbook" unless a motivation proves academic research rather than a textbook

**Flag codes.** `EXCLUDED_TEXTBOOK`, `EXCLUDED_HANDBOOK`, `EXCLUDED_REFERENCE`, `EXCLUDED_FICTION`, `EXCLUDED_COMMISSIONED`, `EXCLUDED_FESTSCHRIFT`, `EXCLUDED_BOOK_REVIEW`, `EXCLUDED_INTRO_ONLY`, `EXCLUDED_DISSERTATION`.

---

## C6. Scholarly contribution (academic merit)

**This is the committee's chief intellectual judgement.** Claude scores it on the 0–5 scale in `scoring_rubric.md`.

Criteria for academic merit:
- **Originality** — genuinely new findings, interpretation, or synthesis.
- **Depth** — sustained scholarly engagement, not a popular summary.
- **Significance** — advances the discipline or policy debate; not ephemeral.
- **Embedding in literature** — engages existing scholarship; cites and builds on it.
- **Methodological rigour** — where empirical, methods are appropriate and transparent.

Claude must ground the score in quoted evidence from the book/chapter and from the research justification.

---

## C7. Supporting documentation complete

**Must be on file for every submission:**
- Electronic copy of the published book / chapter (or high-quality scan).
- Research justification (≤500 words) from author.
- For edited books: editor's written justification (≤500 words), signed.
- For non-English works: one-page English summary.
- For late submissions: signed formal motivation.
- Peer-review evidence (see C3).

**Flag codes.** `MISSING_BOOK_PDF`, `MISSING_JUSTIFICATION`, `MISSING_EDITOR_LETTER`, `MISSING_ENGLISH_SUMMARY`, `LATE_NO_MOTIVATION`.

---

## Subsidy units (for reference only — not scored by Claude)

- Authored book: **10 units**
- Book chapter: **1 unit**
- Edited book with >10 chapters: varies by chapter count

Claude does **not** compute units. The 0–5 score in this system is academic merit, not a rand value.
