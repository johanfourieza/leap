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
