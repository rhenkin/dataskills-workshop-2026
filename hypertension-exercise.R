# Antihypertensive escalation case study
#
# Research question: among newly-diagnosed hypertensive patients, what was
# their first-line antihypertensive class, and did they escalate to a
# second class within 12 months of starting treatment?

# Load packages
# If you get an error, remember to install the package:
# install.packages(tidyverse)
library(tidyverse)

# Data files
patient <- read_tsv("data/Patient.txt",  col_types = cols(patid = col_character())) |>
  mutate(regstartdate = dmy(regstartdate),
         regenddate = dmy(regenddate),
         emis_ddate = dmy(emis_ddate))
observation <- read_tsv("data/Observation.txt", col_types = cols(patid = col_character(), medcodeid = col_character())) |>
  mutate(obsdate = dmy(obsdate))
drugissue <- read_tsv("data/DrugIssue.txt", col_types = cols(patid = col_character(), prodcodeid = col_character())) |>
  mutate(issuedate = dmy(issuedate))

# Codelists
hypertension <- read_tsv("codelists/exeter_hypertension.txt", col_types = cols(MedCodeId = col_character())) |>
  rename(medcodeid = MedCodeId)
ras <- read_tsv("codelists/exeter_ras.txt", col_types = cols(ProdCodeId = col_character())) |>
  rename(prodcodeid = ProdCodeId)
ccb <- read_tsv("codelists/exeter_ccb.txt", col_types = cols(ProdCodeId = col_character())) |>
  rename(prodcodeid = ProdCodeId)
thiazide <- read_tsv("codelists/exeter_thiazide.txt", col_types = cols(ProdCodeId = col_character())) |>
  rename(prodcodeid = ProdCodeId)

# Add class name to codelist file:
ras <- ras |>
  mutate(drugclass = "RAS")

# Your turn: Repeat the drugclass annotation for the other two drug codelists
# CCB:

# Thiazides:

# Combine codelists
antihypertensives <- bind_rows(ras, ccb, thiazide) |>
  select(prodcodeid, drugclass)

study_start <- as.Date("2019-01-01")
study_end <- as.Date("2025-12-31")

# PART 1: Identify the hypertension cohort
# Find patients with an incident hypertension diagnosis (a matching medcodeid in
# `observation`), then apply the inclusion criteria:
#   - aged 18+ at the date of diagnosis (yob vs obsdate)
#   - exclude patients with diagnosis before the study start
#
# Goal: `hypertension_cohort` 
# one row per patient, columns `patid`, `diagnosis_date`
#

# PART 2: Annotate drugissue with class information
# Use the codelists to identify patients prescribed any of the antihypertensives
# Keep only the patients that have an incident hypertension diagnosis
#
# Goal: `di_antihyper`:
# columns `patid`, `issuedate`, `drugclass`.
#


# PART 3: Identify first anti-hypertensive date and class
# For each patient, find their earliest issuedate across any
# class and the drugclass of that earliest prescription.
#
# NICE guidance is stricter than our RQ: it branches step 1 partly on
# ethnicity (e.g. CCB first-line for patients of Black African/Caribbean
# family origin), which we don't have reliable data for. So `first_class`
# can legitimately be RAS, CCB, or thiazide — a patient starting on any of
# the three is a valid, expected pattern; we are not checking guideline
# concordance here.
# Goal: `patient_start`
# columns: `patid`, `start_date`, `first_class`
# 
# Hint: you can use arrange() and row_number() to find the first row for 
# a given group, instead of min()

# PART 4: Escalation to a second class within 12 months
# We want, for each patient, whether a new distinct class  appeared
# within 12 months (365 days) of `start_date`,  and if so, how many
# days after start_date that happened.
#
# Step A: for each patient, find the earliest issuedate of any class OTHER
# than their first_class. You'll need patient_start's `first_class` alongside
# class_issues to identify which rows are "a different class from the one
# they started on" — then, per patient, keep the earliest such date.
#
# Goal `second_class_date`: 
# columns `patid`, `next_class_date`, `next_class` (the class of that next prescription).
#
# Hint: this is the same shape of problem as Part 3 (join, filter, then
# "earliest row per patient" — group_by/summarise both work),
# just filtering to rows where drugclass != first_class instead of taking
# every row.



# PART 5: Assemble the final dataset
# Left-join patient_start and second_class_date into one row per patient
# (start from patient_start, so patients who never escalated still appear,
# with NA for the escalation columns).
#
# Then derive:
#   - `days_to_2nd_class` = next_class_date - start_date (numeric, NA if no
#     escalation)
#   - `escalated_12mo` = TRUE if days_to_2nd_class <= 365, else FALSE
#     (including FALSE, not NA, for patients who escalated later than 12
#     months — only patients with NO escalation at all should be NA here)
#
# Final columns should include at least:
#   patid, start_date, first_class, next_class, days_to_2nd_class,
#   escalated_12mo
#
# Hint: case_when() is a good fit for the escalated_12mo logic — think
# through the three cases (escalated within 12mo / escalated later /
# never escalated) as separate conditions.

hypertension_escalation_tidy <- patient_start |>
  ___

# Quick sanity check — one row per patient?
nrow(hypertension_escalation_tidy) == n_distinct(hypertension_escalation_tidy$patid)

# Peek at the final dataset
glimpse(hypertension_escalation_tidy)
