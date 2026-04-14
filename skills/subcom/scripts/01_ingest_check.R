# 01_ingest_check.R
# Cross-reference the Books and Chapters CSVs against the Docs/Books and
# Docs/Chapters folders. For every submission the CSV lists, report:
#   - whether a folder Docs/<Type>/<ID> exists
#   - how many files are in it
#   - which DHET-required artefacts appear to be present (heuristic by filename)
#   - any ingest flags
# Writes outputs/ingest_report.csv and prints a summary.
#
# Run from the NRF2026 project root:
#   Rscript scripts/01_ingest_check.R

suppressPackageStartupMessages({
  library(readr)
})

root <- getwd()
if (basename(root) == "scripts") root <- dirname(root)

books_csv    <- file.path(root, "SCA Workbook 2025 survey in 2026(Books_SCA2025).csv")
chapters_csv <- file.path(root, "SCA Workbook 2025 survey in 2026(Chapters_SCA2025).csv")
docs_books    <- file.path(root, "Docs", "Books")
docs_chapters <- file.path(root, "Docs", "Chapters")
out_dir <- file.path(root, "outputs")
dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)

# --- Helpers -------------------------------------------------------------

# Classify the files in a folder by looking at filenames. Heuristic only —
# meant to flag likely-missing artefacts, not to score content.
classify <- function(files) {
  if (length(files) == 0) {
    return(list(tags = character(), flags = "EMPTY_FOLDER"))
  }
  n <- tolower(basename(files))
  tags  <- character()
  flags <- character()

  has_peer <- any(grepl("peer|review|referee", n))
  has_just <- any(grepl("justif|motivation", n))
  has_edit <- any(grepl("editor|edit.?letter", n))
  has_sum  <- any(grepl("summary|english.?summary|abstract", n))
  has_cov  <- any(grepl("cover|font.?and.?back", n))
  # A PDF that isn't obviously one of the supporting docs is likely the book/chapter text.
  supporting_regex <- "peer|review|referee|justif|motivation|editor|summary|abstract|cover|affiliation|appointment|acceptance|fellow"
  main_pdfs <- files[grepl("\\.pdf$", n) & !grepl(supporting_regex, n)]

  if (has_peer) tags <- c(tags, "peer_review")
  if (has_just) tags <- c(tags, "justification")
  if (has_edit) tags <- c(tags, "editor_letter")
  if (has_sum)  tags <- c(tags, "english_summary")
  if (has_cov)  tags <- c(tags, "cover")
  if (length(main_pdfs) > 0) tags <- c(tags, "main_pdf")

  if (!has_peer) flags <- c(flags, "NO_PEER_REVIEW_FILE")
  if (!has_just) flags <- c(flags, "NO_JUSTIFICATION_FILE")
  if (length(main_pdfs) == 0) flags <- c(flags, "NO_MAIN_PDF")

  list(tags = tags, flags = flags)
}

audit_id <- function(id, title, docs_root) {
  folder <- file.path(docs_root, id)
  if (!dir.exists(folder)) {
    return(list(
      folder_exists = FALSE,
      n_files       = 0L,
      tags          = "",
      flags         = "FOLDER_MISSING"
    ))
  }
  files <- list.files(folder, full.names = TRUE, recursive = TRUE)
  cls <- classify(files)
  list(
    folder_exists = TRUE,
    n_files       = length(files),
    tags          = paste(cls$tags, collapse = ";"),
    flags         = paste(cls$flags, collapse = ";")
  )
}

audit_csv <- function(csv_path, id_col, type, docs_root) {
  df <- read_csv(csv_path, show_col_types = FALSE, progress = FALSE)
  ids    <- as.character(df[[id_col]])
  titles <- df[["Book title"]]

  rows <- lapply(seq_along(ids), function(i) {
    a <- audit_id(ids[i], titles[i], docs_root)
    data.frame(
      id            = ids[i],
      type          = type,
      faculty       = df[["Faculty"]][i],
      title         = titles[i],
      folder_exists = a$folder_exists,
      n_files       = a$n_files,
      tags          = a$tags,
      flags         = a$flags,
      stringsAsFactors = FALSE
    )
  })
  do.call(rbind, rows)
}

# --- Run -----------------------------------------------------------------

cat("Auditing books ...\n")
books_report    <- audit_csv(books_csv,    "Book Number", "book",    docs_books)

cat("Auditing chapters ...\n")
chapters_report <- audit_csv(chapters_csv, "Chapter No.", "chapter", docs_chapters)

report <- rbind(books_report, chapters_report)
out_path <- file.path(out_dir, "ingest_report.csv")
write_csv(report, out_path)

# --- Summary -------------------------------------------------------------

summarise <- function(df, label) {
  cat(sprintf("\n== %s (%d total) ==\n", label, nrow(df)))
  cat(sprintf("  folder exists : %d\n", sum(df$folder_exists)))
  cat(sprintf("  folder missing: %d\n", sum(!df$folder_exists)))
  cat(sprintf("  clean (no flags, folder exists): %d\n",
              sum(df$folder_exists & df$flags == "")))
  cat("  flag counts:\n")
  flag_vec <- unlist(strsplit(df$flags[df$flags != ""], ";"))
  if (length(flag_vec) > 0) {
    tbl <- sort(table(flag_vec), decreasing = TRUE)
    for (nm in names(tbl)) cat(sprintf("    %-25s %d\n", nm, tbl[[nm]]))
  } else {
    cat("    (none)\n")
  }
}

summarise(books_report,    "BOOKS")
summarise(chapters_report, "CHAPTERS")

cat(sprintf("\nReport written to %s\n", out_path))

# Print the per-book status for quick eyeballing (only the books CSV has few rows)
cat("\nPer-book status:\n")
for (i in seq_len(nrow(books_report))) {
  r <- books_report[i, ]
  status <- if (!r$folder_exists) "MISSING"
            else if (r$flags == "") "OK"
            else "FLAGGED"
  cat(sprintf("  %-5s  %-8s  files=%-2d  %s\n",
              r$id, status, r$n_files,
              if (r$flags == "") "" else paste("flags:", r$flags)))
}
