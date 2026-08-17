# Your Turn exercises: select

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

# Select operations

# Example:
# Keep only patid and gender from patient

patient_simple <- patient |>
  select(patid, gender)

# Your turn

# Exercise 1: Select and count columns
# Keep only patid, yob and gender

patient_subset <- patient |>
  select()
  
# Check: ncol(patient_subset) prints 3
  
# Exercise 2: Dropping columns
# Add a - in front a of column name to remove it
# select will keep every other column not named 
# --
# Select all columns EXCEPT regenddate

patient_no_regend <- patient |>
  select()

# Check: colnames(patient_no_regend) does not print regendddate
  
# Exercise 3:
# We can use new_name = old_name in select to rename a column while selecting it
# Select patid and yob, renaming yob to birth_year

patient_renamed <- patient |>
  select()
  
# Check: colnames(patient_renamed) prints patid and birth_year

# Exercise 4: complex operators
# We can use utility functions to select/exclude multiple columns 
# starts_with("prefix") keeps only the columns starting with prefix
# These operators are used inside select
# See all of them here: https://tidyselect.r-lib.org/reference/language.html
# --
# Select patid and the registration related columns
patient_reg <- patient |>
  select()

# Check: colnames(patient_reg)  prints patid, regstartdate and regenddate

# Extra challenge: shaping a table for a join
# Later, we'll join drugissue against a codelist and only need a few columns
# to do it efficiently
# --
# From drugissue, select just patid, prodcodeid and issuedate, and rename
# issuedate to prescription_date
drugissue_slim <- drugissue |>
  select()

# Check: colnames(drugissue_slim) prints patid, prodcodeid, prescription_date
# (in that order) and ncol(drugissue_slim) prints 3