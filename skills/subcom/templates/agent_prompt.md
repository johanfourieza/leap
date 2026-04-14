# Per-submission adjudication agent prompt template

Use this template verbatim when spawning a subagent to adjudicate a single book or chapter. Replace `{{...}}` placeholders with per-submission values from the CSV row.

---

Adjudicate DHET submission {{ID}}. Write `{{FOLDER}}\adjudication.md` following the exact format of `{{TEMPLATE_PATH}}`.

**Required reading first:**
1. `{{PROJECT_ROOT}}\rubric\dhet_criteria.md`
2. `{{PROJECT_ROOT}}\rubric\scoring_rubric.md`
3. `{{TEMPLATE_PATH}}` (the format template — match its structure exactly: header table → DHET checklist C1–C7 → score section → recommendation section)

**CSV metadata for {{ID}}:**
- Nomination ID: {{NOMINATION_ID}} | Faculty: {{FACULTY}} | Dept: {{DEPARTMENT}}
- Title: {{TITLE}}
- {{#if CHAPTER}}Chapter title: {{CHAPTER_TITLE}}{{/if}}
- Authors: {{AUTHORS}}
- Publisher: {{PUBLISHER}} | Pages: {{START_PAGE}}–{{END_PAGE}} of {{TOTAL_PAGES}}
- URL: {{PUBLICATION_URL}}
- CSV note: {{COMMENTS}}

**Files in `{{FOLDER}}\`:** List via Glob first to see what's actually there. Typical contents: book/chapter PDF, peer-review letter(s), written justification, publisher/editor letter, any SU-affiliation letter.

**How to read efficiently (DO NOT read the whole book):**
- Full read of peer-review evidence, written justification, publisher/editor letter, SU-affiliation letter (these are short).
- Book PDF pages 1–12 only (cover/copyright/TOC/opening of introduction). Use the `pages` parameter on Read.
- Only read more of the book (e.g. a substantive chapter, the bibliography, or the end of substantive content for C2 length verification) if you need it to resolve a specific criterion.
- For .docx files, if Read fails: use Bash with `unzip -p file.docx word/document.xml | sed 's/<[^>]*>//g'` to extract text.

**Focus points (decide what applies based on the files + CSV):**
- **Publisher legitimacy (C1).** Red flags: unknown/small presses, advocacy-organisation imprints, pay-to-publish operators (e.g. Generis, Lambert Academic). Cambridge Scholars is borderline. Cambridge University Press, Oxford University Press, Routledge, Palgrave, Bloomsbury, Springer Nature, Edward Elgar, Brill, SUN PReSS/African Sun Media, UJ Press, Propylaeum/Karolinum/academic university presses are all fine.
- **Length (C2).** If total pages is near 60, count substantive content precisely — exclude references, bibliography, index, appendices. <60pp substantive = SHORT + eligible=FALSE.
- **Peer review (C3).** Gold: named reviewers + full reports + author response. Good: named reviewers + publisher confirmation letter. OK: double-blind confirmed with a substantive letter describing process. Weak: generic template letter, proposal-only review, author-solicited reviewers, series-editor endorsement only, editor self-review unclear.
- **Originality (C4).** Dissertation-derived → C4 requires "substantial reworking and additional research." 2nd+ editions → ≥50% new material. Prior published articles → disclose and flag if incorporated. Translations → not eligible.
- **Excluded categories (C5).** Textbook tells: "Principles and Applications", "How to...", learning objectives, end-of-chapter exercises/questions, discussion questions, instructor materials. Handbook tells: "Handbook of" in the title without a scholarly-output motivation. Reference work tells: catalogue/dictionary/encyclopedia structure with thin analytical prose. Festschrift/commemorative volume tells: honoring an individual or institution.
- **Non-English (C4).** Requires a one-page English summary.
- **Documentation (C7).** If the research justification is missing, absent, or is only a blank template form, flag `MISSING_JUSTIFICATION` + `eligible=UNCERTAIN`.

**Output requirements:**
- Match the template format exactly: header table, DHET eligibility checklist (C1–C7), score section, recommendation section.
- Score 0–5 integer. `dhet_eligible`: TRUE / FALSE / UNCERTAIN. Flags from the vocabulary in `dhet_criteria.md` (plus soft flags you introduce where useful — e.g. `DISSERTATION_OVERLAP_DISCLOSED` for a documented but not-quantified PhD reworking).
- Quote specific evidence from the files where possible. Be honest about uncertainty. Do not auto-approve cases where peer review is thin, publisher is questionable, or originality is weak — the committee is the final judge but only if Claude has flagged the right things.
- If a folder already contains a `# HUMAN REVIEWED` adjudication.md, SKIP — do not overwrite.

When done, reply with ONE line only:
`{{ID}} | score=X | eligible=Y | flags=... | one-sentence summary`

Do NOT write any other files. Do NOT continue to other submissions — one adjudication per agent.
