#!/usr/bin/env bash
# make_md.sh — build the machine-readable .md twin of a LEAP working paper.
#
#   ./make_md.sh <stem>                      # looks for <stem>.tex and references.bib
#   ./make_md.sh <stem> path/to/refs.bib
#
# Writes <stem>.md beside <stem>.tex. Run it after the PDF builds clean, from the
# directory holding the .tex, so that relative figure paths resolve.

set -euo pipefail

stem="${1:?usage: make_md.sh <stem> [bibfile]}"
stem="${stem%.tex}"
bib="${2:-}"

if [ -z "$bib" ]; then
  for cand in references.bib refs.bib references_final.bib; do
    [ -f "$cand" ] && bib="$cand" && break
  done
fi

args=(--from=latex --to=gfm+tex_math_dollars-raw_html --wrap=none --standalone)
if [ -n "$bib" ] && [ -f "$bib" ]; then
  # reference-section-title matters: without it citeproc appends the bibliography
  # with no heading, so a machine reader cannot tell where the body text ends.
  args+=(--citeproc --bibliography="$bib" --metadata=reference-section-title=References)
  echo "bibliography: $bib"
else
  echo "bibliography: none found — citations stay as written in the source"
fi

# A hand-rolled \begin{thebibliography} carries no heading of its own, so pandoc
# emits the entries as ordinary paragraphs and the bibliography becomes
# indistinguishable from body text. Inject a heading into a temporary copy of the
# source; the paper's own .tex is never touched.
src="$stem.tex"
tmp=""
if grep -q '\\begin{thebibliography}' "$stem.tex" && \
   ! grep -qE '\\(sub)?section\*?\{References\}' "$stem.tex"; then
  tmp="$(mktemp -t leapwp_XXXXXX).tex"
  sed 's/\\begin{thebibliography}/\\section*{References}\n\\begin{thebibliography}/' "$stem.tex" > "$tmp"
  src="$tmp"
  echo "injected a References heading before thebibliography"
fi

pandoc "$src" "${args[@]}" -o "$stem.md"
[ -n "$tmp" ] && rm -f "$tmp"

# gfm writes inline math as $`x`$ and display math as ```math fences.
# Normalise both to plain LaTeX delimiters, which every model reads natively.
python - "$stem.md" "$stem" <<'PY'
import re, sys
p, stem = sys.argv[1], sys.argv[2]
s = open(p, encoding="utf-8").read()

# math -> plain LaTeX delimiters, which every model reads natively
s = re.sub(r"\$`(.+?)`\$", r"$\1$", s, flags=re.S)
s = re.sub(r"``` ?math\n(.*?)\n```", lambda m: "$$\n%s\n$$" % m.group(1), s, flags=re.S)

# figures are not reproduced: leave a placeholder and keep the caption that follows
n = len(re.findall(r"(?m)^!\[[^\]]*\]\([^)]*\)\s*$", s))
s = re.sub(r"(?m)^!\[[^\]]*\]\([^)]*\)\s*$",
           "*[Figure not reproduced here — see %s.pdf]*" % stem, s)

# point machine readers at the typeset version, immediately after the YAML block
note = ("\n> Figures and typeset tables are omitted from this Markdown version.\n"
        "> The complete paper, with all figures, is in %s.pdf.\n" % stem)
if s.startswith("---"):
    end = s.index("\n---", 3) + len("\n---")
    s = s[:end] + "\n" + note + s[end:]
else:
    s = note + "\n" + s

open(p, "w", encoding="utf-8").write(s)
print("figure placeholders: %d" % n)
PY

words=$(wc -w < "$stem.md")
echo "wrote $stem.md ($words words)"
