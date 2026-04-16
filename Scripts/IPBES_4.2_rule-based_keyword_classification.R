# ===============================
# IPBES Literature Classification Pipeline (CSV-based)
# Case-insensitive keyword search
# ===============================

library(dplyr)
library(stringr)
library(tidyr)
library(purrr)
library(readxl)
library(openxlsx)

# ---- Inputs ----
csv_file <- "................./Core_literature_search_2000_2026.csv"
keyword_file <- "............./section_keywords.xlsx"
output_dir <- ".............../Literature_search_classifications"

min_keyword_hits <- 1

dir.create(output_dir, showWarnings = FALSE, recursive = TRUE)

# ---- Load CSV ----
bib <- read.csv(csv_file, stringsAsFactors = FALSE)

# ---- Create internal document ID and lowercase titles ----
bib <- bib %>%
  mutate(
    DOC_ID = row_number(),
    TI = str_to_lower(title)
  )

# ---- Build TEXT field for keyword search ----
bib <- bib %>%
  mutate(
    TEXT = str_to_lower(
      paste(
        coalesce(TI, ""),
        coalesce(abstract, ""),
        coalesce(note, ""),
        coalesce(journal, ""),
        coalesce(publisher, ""),
        sep = " "
      )
    )
  )

# ---- Load keyword dictionary from Excel and lowercase keywords ----
sections <- read_excel(keyword_file) %>%
  mutate(
    keyword_list = map(str_split(keywords, ";"), ~str_to_lower(trimws(.x)))  # lowercase & trim whitespace
  )

# ---- Function: count keyword hits (case-insensitive) ----
count_hits <- function(text, keywords) {
  sum(str_detect(text, fixed(keywords)))  # text and keywords already lowercase
}

# ---- Rule-based classification ----
classification <- sections %>%
  select(section_id, section_name, keyword_list) %>%
  mutate(
    results = map(keyword_list, function(kw) {
      bib %>%
        mutate(hits = map_int(TEXT, ~count_hits(.x, kw)))
    })
  ) %>%
  unnest(results) %>%
  select(DOC_ID, TI, hits, section_id, section_name) %>%
  filter(hits >= min_keyword_hits)

# ---- Merge metadata for assignments ----
final_assignments <- classification %>%
  left_join(
    bib %>% select(DOC_ID, TI, author, year, journal, doi),
    by = c("DOC_ID", "TI")
  ) %>%
  arrange(desc(hits))

# ---- Primary section assignment (highest hit count per paper) ----
primary_assignment <- final_assignments %>%
  group_by(DOC_ID) %>%
  slice_max(hits, n = 1, with_ties = FALSE) %>%
  ungroup()

# ---- Summary table ----
summary_table <- final_assignments %>%
  count(section_name, name = "n_papers")

# ---- Write Excel outputs ----
write.xlsx(final_assignments,
           file = file.path(output_dir, "all_section_assignments.xlsx"),
           overwrite = TRUE, keepNA = TRUE)

write.xlsx(primary_assignment,
           file = file.path(output_dir, "primary_section_assignment.xlsx"),
           overwrite = TRUE, keepNA = TRUE)

write.xlsx(summary_table,
           file = file.path(output_dir, "section_summary_counts.xlsx"),
           overwrite = TRUE)

# ---- Section-specific Excel files for colleagues ----
sections$section_name %>% walk(function(sec) {
  sec_refs <- final_assignments %>%
    filter(section_name == sec) %>%
    select(TI, author, year, journal, doi)
  
  if(nrow(sec_refs) > 0) {
    write.xlsx(
      sec_refs,
      file = file.path(output_dir, paste0("references_", str_replace_all(sec, " ", "_"), ".xlsx")),
      overwrite = TRUE, keepNA = TRUE
    )
  }
})

message("✔ IPBES classification complete. Case-insensitive keyword search applied. Section-specific Excel files created.")