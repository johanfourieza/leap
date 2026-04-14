#!/usr/bin/env Rscript
# 02_aggregate.R — Stage 5 aggregation for NRF2026 DHET adjudications.
# Parses every Docs/Books/B*/adjudication.md and Docs/Chapters/CH*/adjudication.md
# and emits outputs/master_scores.{xlsx,csv}, outputs/all_adjudications.md,
# outputs/flagged_shortlist.md.
# Run from project root: Rscript scripts/02_aggregate.R
# Dependencies: base R + readr + writexl (fallback openxlsx). No tidyverse/fs/here.

suppressWarnings(suppressMessages({
  has_readr   <- requireNamespace("readr", quietly = TRUE)
  has_writexl <- requireNamespace("writexl", quietly = TRUE)
  has_openxlsx <- requireNamespace("openxlsx", quietly = TRUE)
}))

# ---- paths ------------------------------------------------------------------
repo_root   <- getwd()
docs_dir    <- file.path(repo_root, "Docs")
books_dir   <- file.path(docs_dir, "Books")
chapters_dir <- file.path(docs_dir, "Chapters")
out_dir     <- file.path(repo_root, "outputs")
if (!dir.exists(out_dir)) dir.create(out_dir, recursive = TRUE)

# ---- helpers ----------------------------------------------------------------
# null/NA coalesce
`%||%` <- function(a, b) if (is.null(a) || length(a) == 0 || (length(a) == 1 && is.na(a))) b else a

read_md <- function(path) {
  con <- file(path, open = "rb")
  raw <- readBin(con, what = "raw", n = file.info(path)$size)
  close(con)
  txt <- rawToChar(raw)
  # Strip UTF-8 BOM if present
  if (nchar(txt) >= 1 && substr(txt, 1, 1) == "\ufeff") txt <- substr(txt, 2, nchar(txt))
  # Normalise line endings
  txt <- gsub("\r\n", "\n", txt, fixed = TRUE)
  txt <- gsub("\r", "\n", txt, fixed = TRUE)
  txt
}

lines_of <- function(txt) strsplit(txt, "\n", fixed = TRUE)[[1]]

trim <- function(x) gsub("^\\s+|\\s+$", "", x)

# Extract "| Key | Value |" row; key matched case-insensitively on trimmed label
table_field <- function(lines, key) {
  pat <- paste0("^\\s*\\|\\s*", key, "\\s*\\|\\s*(.*?)\\s*\\|\\s*$")
  idx <- grep(pat, lines, ignore.case = TRUE, perl = TRUE)
  if (!length(idx)) return(NA_character_)
  m <- regmatches(lines[idx[1]], regexec(pat, lines[idx[1]], ignore.case = TRUE, perl = TRUE))[[1]]
  if (length(m) < 2) return(NA_character_)
  v <- trim(m[2])
  if (!nchar(v) || v == "---" || v == ":---") NA_character_ else v
}

# Extract a "**label:** value" style line (label is literal, no regex meta chars expected)
bold_field <- function(lines, label) {
  pat <- paste0("^\\*\\*", label, ":\\*\\*\\s*(.*)$")
  idx <- grep(pat, lines, ignore.case = TRUE, perl = TRUE)
  if (!length(idx)) return(NA_character_)
  m <- regmatches(lines[idx[1]], regexec(pat, lines[idx[1]], ignore.case = TRUE, perl = TRUE))[[1]]
  if (length(m) < 2) return(NA_character_)
  trim(m[2])
}

parse_score <- function(lines) {
  # Form A: "## Scientific contribution score: X / 5"
  pat1 <- "^##\\s*Scientific contribution score:\\s*([0-9]+)\\s*/\\s*5\\s*$"
  # Form B: "**Scientific contribution score:** X/5" (any heading level or bold)
  pat2 <- "Scientific contribution score:\\**\\s*([0-9]+)\\s*/\\s*5"
  idx <- grep(pat1, lines, ignore.case = TRUE, perl = TRUE)
  if (length(idx)) {
    m <- regmatches(lines[idx[1]], regexec(pat1, lines[idx[1]], ignore.case = TRUE, perl = TRUE))[[1]]
    return(suppressWarnings(as.integer(m[2])))
  }
  idx <- grep(pat2, lines, ignore.case = TRUE, perl = TRUE)
  if (length(idx)) {
    m <- regmatches(lines[idx[1]], regexec(pat2, lines[idx[1]], ignore.case = TRUE, perl = TRUE))[[1]]
    return(suppressWarnings(as.integer(m[2])))
  }
  NA_integer_
}

# Pull the paragraph(s) under "## Recommendation to committee" until next H2/H1 or EOF
parse_recommendation <- function(lines) {
  idx <- grep("^##\\s*Recommendation to committee", lines, ignore.case = TRUE, perl = TRUE)
  if (!length(idx)) return(NA_character_)
  start <- idx[1] + 1
  end <- length(lines)
  if (start <= end) {
    hdr <- grep("^#{1,2}\\s", lines[start:end], perl = TRUE)
    if (length(hdr)) end <- start + hdr[1] - 2
  }
  block <- lines[start:end]
  block <- block[!grepl("^\\s*---\\s*$", block)]
  txt <- trim(paste(block, collapse = "\n"))
  txt <- gsub("\n{3,}", "\n\n", txt)
  if (!nchar(txt)) NA_character_ else txt
}

first_sentence <- function(s) {
  if (is.na(s) || !nchar(s)) return(NA_character_)
  # Strip leading markdown emphasis like "**Approve.** " but keep the period
  one <- gsub("\n", " ", s, fixed = TRUE)
  one <- trim(one)
  m <- regmatches(one, regexpr("^.*?[.!?](\\s|$)", one, perl = TRUE))
  if (length(m) && nchar(m)) trim(m) else one
}

parse_id_from_h1 <- function(lines) {
  idx <- grep("^#\\s+", lines, perl = TRUE)
  # skip the HUMAN REVIEWED line if it is the first H1
  for (i in idx) {
    if (grepl("HUMAN REVIEWED", lines[i], ignore.case = TRUE)) next
    h <- lines[i]
    m <- regmatches(h, regexec("^#\\s+Adjudication:\\s*([A-Za-z]+[0-9]+)", h, perl = TRUE))[[1]]
    if (length(m) >= 2) return(m[2])
    # fallback: first token after "# "
    m2 <- regmatches(h, regexec("^#\\s+([A-Za-z]+[0-9]+)", h, perl = TRUE))[[1]]
    if (length(m2) >= 2) return(m2[2])
    return(NA_character_)
  }
  NA_character_
}

get_h1_title <- function(lines) {
  idx <- grep("^#\\s+", lines, perl = TRUE)
  for (i in idx) {
    if (grepl("HUMAN REVIEWED", lines[i], ignore.case = TRUE)) next
    return(sub("^#\\s+", "", lines[i]))
  }
  NA_character_
}

# Pandoc-style anchor: lowercase, strip punctuation (keep letters/digits/space/hyphen),
# collapse whitespace to single hyphen, strip leading non-letters.
pandoc_anchor <- function(s) {
  if (is.na(s)) return(NA_character_)
  a <- tolower(s)
  a <- gsub("[^a-z0-9 \\-]", "", a, perl = TRUE)
  a <- gsub("\\s+", "-", trim(a), perl = TRUE)
  a <- sub("^[^a-z]+", "", a, perl = TRUE)
  if (!nchar(a)) "section" else a
}

# ---- discover adjudication files -------------------------------------------
find_adjudications <- function() {
  out <- data.frame(folder = character(), path = character(), type = character(),
                    stringsAsFactors = FALSE)
  for (kind in c("Books", "Chapters")) {
    base <- file.path(docs_dir, kind)
    if (!dir.exists(base)) next
    subs <- list.dirs(base, recursive = FALSE, full.names = TRUE)
    for (s in subs) {
      f <- file.path(s, "adjudication.md")
      if (file.exists(f)) {
        out <- rbind(out, data.frame(folder = s, path = f,
                                     type = if (kind == "Books") "book" else "chapter",
                                     stringsAsFactors = FALSE))
      }
    }
  }
  out
}

# ---- parse one file ---------------------------------------------------------
parse_one <- function(path, type_hint) {
  txt <- read_md(path)
  lines <- lines_of(txt)
  human_reviewed <- length(lines) > 0 && grepl("^#\\s*HUMAN REVIEWED", lines[1], ignore.case = TRUE, perl = TRUE)

  id <- parse_id_from_h1(lines)
  if (is.na(id)) id <- table_field(lines, "ID")

  type_tbl <- table_field(lines, "Type")
  type_val <- if (!is.na(type_tbl)) {
    if (grepl("chapter", type_tbl, ignore.case = TRUE)) "chapter" else "book"
  } else if (!is.na(id)) {
    if (grepl("^CH", id, ignore.case = TRUE)) "chapter" else "book"
  } else type_hint

  rec <- parse_recommendation(lines)

  flags_raw <- bold_field(lines, "flags")
  if (!is.na(flags_raw)) {
    f <- trim(flags_raw)
    if (tolower(f) %in% c("none", "n/a", "na", "-", "")) flags_raw <- ""
  } else {
    flags_raw <- NA_character_
  }

  rel_path <- sub(paste0("^", gsub("([.\\^$*+?()\\[\\]{}|])", "\\\\\\1", repo_root, perl = TRUE), "[/\\\\]"),
                  "", path, perl = TRUE)
  rel_path <- gsub("\\\\", "/", rel_path)

  list(
    id                  = id,
    type                = type_val,
    faculty             = table_field(lines, "Faculty"),
    department          = table_field(lines, "Department"),
    author              = table_field(lines, "Author"),
    title               = {
      t <- get_h1_title(lines)
      if (!is.na(t)) sub("^Adjudication:\\s*[A-Za-z]+[0-9]+\\s*[—–-]\\s*", "", t, perl = TRUE) else NA_character_
    },
    h1                  = get_h1_title(lines),
    publisher           = table_field(lines, "Publisher"),
    year                = table_field(lines, "Year"),
    total_pages         = table_field(lines, "Total pages"),
    publication_url     = table_field(lines, "Publication URL"),
    dhet_eligible       = {
      v <- bold_field(lines, "dhet_eligible")
      if (is.na(v)) NA_character_ else toupper(trim(v))
    },
    flags               = flags_raw,
    score               = parse_score(lines),
    recommendation_text = rec,
    one_line_summary    = first_sentence(rec),
    human_reviewed      = human_reviewed,
    path                = rel_path,
    raw                 = txt
  )
}

# ---- build master table -----------------------------------------------------
files <- find_adjudications()
if (nrow(files) == 0) {
  message("No adjudication.md files found under Docs/Books or Docs/Chapters.")
  quit(status = 0)
}

records <- lapply(seq_len(nrow(files)), function(i) parse_one(files$path[i], files$type[i]))

# natural sort: type (book < chapter) then numeric part of ID
id_num <- function(id) {
  if (is.na(id)) return(NA_integer_)
  n <- suppressWarnings(as.integer(gsub("[^0-9]", "", id)))
  if (is.na(n)) NA_integer_ else n
}
type_rank <- function(t) if (isTRUE(t == "book")) 1L else if (isTRUE(t == "chapter")) 2L else 3L

ord <- order(
  vapply(records, function(r) type_rank(r$type), integer(1)),
  vapply(records, function(r) id_num(r$id), integer(1)),
  na.last = TRUE
)
records <- records[ord]

master <- data.frame(
  id              = vapply(records, function(r) r$id %||% NA_character_, character(1)),
  type            = vapply(records, function(r) r$type %||% NA_character_, character(1)),
  title           = vapply(records, function(r) r$title %||% NA_character_, character(1)),
  author          = vapply(records, function(r) r$author %||% NA_character_, character(1)),
  faculty         = vapply(records, function(r) r$faculty %||% NA_character_, character(1)),
  department      = vapply(records, function(r) r$department %||% NA_character_, character(1)),
  publisher       = vapply(records, function(r) r$publisher %||% NA_character_, character(1)),
  year            = vapply(records, function(r) r$year %||% NA_character_, character(1)),
  total_pages     = vapply(records, function(r) r$total_pages %||% NA_character_, character(1)),
  publication_url = vapply(records, function(r) r$publication_url %||% NA_character_, character(1)),
  dhet_eligible   = vapply(records, function(r) r$dhet_eligible %||% NA_character_, character(1)),
  flags           = vapply(records, function(r) r$flags %||% NA_character_, character(1)),
  score           = vapply(records, function(r) r$score %||% NA_integer_, integer(1)),
  human_reviewed  = vapply(records, function(r) isTRUE(r$human_reviewed), logical(1)),
  one_line_summary = vapply(records, function(r) r$one_line_summary %||% NA_character_, character(1)),
  path            = vapply(records, function(r) r$path %||% NA_character_, character(1)),
  stringsAsFactors = FALSE
)

master$dossier_link <- ifelse(
  is.na(master$path),
  NA_character_,
  paste0("[", master$id, "](", master$path, ")")
)

# ---- write master_scores.{csv,xlsx} ----------------------------------------
csv_path <- file.path(out_dir, "master_scores.csv")
xlsx_path <- file.path(out_dir, "master_scores.xlsx")

if (has_readr) {
  readr::write_csv(master, csv_path, na = "")
} else {
  write.csv(master, csv_path, row.names = FALSE, na = "", fileEncoding = "UTF-8")
}

if (has_writexl) {
  writexl::write_xlsx(master, xlsx_path)
} else if (has_openxlsx) {
  openxlsx::write.xlsx(master, xlsx_path, overwrite = TRUE)
} else {
  warning("Neither writexl nor openxlsx is installed — skipping xlsx output.")
}

# ---- all_adjudications.md --------------------------------------------------
all_path <- file.path(out_dir, "all_adjudications.md")
anchor_map <- vapply(records, function(r) pandoc_anchor(r$h1), character(1))

toc_lines <- c("# Consolidated adjudications",
               "",
               paste0("*Generated: ", format(Sys.time(), "%Y-%m-%d %H:%M"), " — ",
                      nrow(master), " submissions.*"),
               "",
               "## Table of contents",
               "")
for (i in seq_along(records)) {
  r <- records[[i]]
  label <- if (!is.na(r$h1) && nchar(r$h1)) r$h1 else (r$id %||% "(untitled)")
  sc <- if (!is.na(r$score)) paste0(" — score ", r$score, "/5") else ""
  elig <- if (!is.na(r$dhet_eligible)) paste0(" — ", r$dhet_eligible) else ""
  toc_lines <- c(toc_lines,
                 paste0("- [", label, "](#", anchor_map[i], ")", sc, elig))
}
toc_lines <- c(toc_lines, "", "<a id=\"top\"></a>", "")

body <- character(0)
for (i in seq_along(records)) {
  r <- records[[i]]
  body <- c(body, r$raw, "",
            "[Back to top](#top)",
            "",
            "---",
            "")
}

writeLines(c(toc_lines, body), con = all_path, useBytes = TRUE)

# ---- flagged_shortlist.md --------------------------------------------------
flag_path <- file.path(out_dir, "flagged_shortlist.md")

is_flagged_flags <- function(f) !is.na(f) && nchar(trim(f)) > 0
cat_of <- function(r) {
  elig <- r$dhet_eligible
  if (!is.na(elig) && elig == "FALSE") return("FAIL")
  if (!is.na(elig) && elig == "UNCERTAIN") return("UNCERTAIN")
  if (!is.na(r$score) && r$score <= 2) return("FAIL")
  if (!is.na(r$score) && r$score == 3) return("SOFT-FLAGGED")
  if (is_flagged_flags(r$flags)) return("SOFT-FLAGGED")
  NA_character_
}

cats <- vapply(records, cat_of, character(1))
flagged_idx <- which(!is.na(cats))

render_entry <- function(r) {
  bits <- c(
    paste0("### ", r$id %||% "(no id)", " — ", r$title %||% "(no title)"),
    "",
    paste0("- **Author:** ", r$author %||% "NA"),
    paste0("- **Score:** ", ifelse(is.na(r$score), "NA", paste0(r$score, "/5"))),
    paste0("- **DHET eligible:** ", r$dhet_eligible %||% "NA"),
    paste0("- **Flags:** ", if (is_flagged_flags(r$flags)) r$flags else "(none)"),
    paste0("- **Dossier:** [", r$path, "](", r$path %||% "", ")"),
    paste0("- **Recommendation (first sentence):** ", r$one_line_summary %||% "NA"),
    ""
  )
  bits
}

flag_lines <- c("# Flagged shortlist — committee priority reading",
                "",
                paste0("*Generated: ", format(Sys.time(), "%Y-%m-%d %H:%M"), ". ",
                       length(flagged_idx), " of ", nrow(master), " submissions flagged.*"),
                "")
for (grp in c("FAIL", "UNCERTAIN", "SOFT-FLAGGED")) {
  ids <- flagged_idx[cats[flagged_idx] == grp]
  flag_lines <- c(flag_lines, paste0("## ", grp, " (", length(ids), ")"), "")
  if (!length(ids)) {
    flag_lines <- c(flag_lines, "_None._", "")
    next
  }
  for (i in ids) flag_lines <- c(flag_lines, render_entry(records[[i]]))
}
writeLines(flag_lines, con = flag_path, useBytes = TRUE)

# ---- console summary --------------------------------------------------------
n <- nrow(master)
mean_score <- if (any(!is.na(master$score))) round(mean(master$score, na.rm = TRUE), 2) else NA
buckets <- table(factor(master$score, levels = 1:5), useNA = "no")
missing_score <- sum(is.na(master$score))
flagged_n <- length(flagged_idx)

expected <- list(
  book    = length(list.dirs(books_dir, recursive = FALSE)),
  chapter = length(list.dirs(chapters_dir, recursive = FALSE))
)
done_book <- sum(master$type == "book", na.rm = TRUE)
done_ch   <- sum(master$type == "chapter", na.rm = TRUE)

cat("------------------------------------------------------------\n")
cat("NRF2026 aggregation complete.\n")
cat(sprintf("Adjudicated:    %d (books %d/%d, chapters %d/%d)\n",
            n, done_book, expected$book, done_ch, expected$chapter))
cat(sprintf("Mean score:     %s\n", ifelse(is.na(mean_score), "NA", mean_score)))
cat("Score buckets:\n")
for (k in 1:5) cat(sprintf("  %d/5 : %d\n", k, as.integer(buckets[as.character(k)] %||% 0)))
cat(sprintf("Missing score:  %d\n", missing_score))
cat(sprintf("Flagged:        %d\n", flagged_n))
cat("Outputs:\n")
cat(sprintf("  %s\n", csv_path))
cat(sprintf("  %s\n", xlsx_path))
cat(sprintf("  %s\n", all_path))
cat(sprintf("  %s\n", flag_path))
cat("------------------------------------------------------------\n")
