# Antidepressant prescription reviews case study

# Load packages
# If you get an error, remember to install the package:
# install.packages(tidyverse)
library(tidyverse)

# Data files
patient <- read_tsv("data/Patient.txt", col_types = cols(patid = col_character())) |>
  mutate(regstartdate = dmy(regstartdate),
         regenddate = dmy(regenddate),
         emis_ddate = dmy(emis_ddate))
observation <- read_tsv("data/Observation.txt", col_types = cols(patid = col_character(), medcodeid = col_character())) |>
  mutate(obsdate = dmy(obsdate))
drugissue <- read_tsv("data/DrugIssue.txt", col_types = cols(patid = col_character(), prodcodeid = col_character())) |>
  mutate(issuedate = dmy(issuedate))

# Codelists
depression <- read_tsv("codelists/depression.txt")
antidepressants <- read_tsv("codelists/antidepressants.txt")

# Study period
study_start <- as.Date("2022-01-01")
study_end <- as.Date("2025-12-31")

# PART 1: Identify patients with a depression diagnosis (any time), keeping
# the earliest per patient


# PART 2: Find eligible prescriptions -- post-2022, strictly after the
# patient's depression diagnosis, and aged 18+ at prescription


# PART 3: Find prescriptions without a preceding prescription in the past
# 12 months (washout) -- these are the incident prescriptions


# PART 4: Find the date of the first consultation after each incident
# prescription (there's no consultation table -- use any observation entry
# as a proxy for a GP contact)


# PART 5: Flag whether the consultation happened within the review target
# -- 1 week for patients aged 18-25 at prescription, 2 weeks for 26+
# Patients with no consultation at all should be flagged, not left as NA
#
# Fill in the blanks:

depression_review_tidy <- incident_presc |>
  left_join(next_consultation, by = c("patid", "issuedate")) |>
  mutate(
    has_consultation = ___,       # TRUE/FALSE -- did a consultation happen at all?
    days_to_consultation = ___,   # number of days between issuedate and consultation_date
    review_cutoff_days = if_else(___, 7, 14),  # 7 if aged 18-25 at prescription, else 14
    met_review_target = case_when(
      ___ ~ FALSE,   # no consultation at all -> target not met
      ___ ~ TRUE,    # consultation happened within the cutoff -> target met
      TRUE ~ FALSE   # consultation happened, but too late -> target not met
    )
  )
