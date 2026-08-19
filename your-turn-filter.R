# Your Turn exercises: filter

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

# Filter operations

# Example: Keep only male patients
patient_male <- patient |>
  filter(gender == 1)

# Your turn

# Exercise 1: direct comparison
# Keep only patients born on or after 1990
patient_1990 <- patient |>
  filter()
  
# Check: nrow(patient_1990) should print 11115

# Exercise 2: date comparison
# Keep only observations recorded 2020 onwards
# Date comparisons require conversion as.Date("YYYY-MM-DD")
postcovid_obs <- observation |>
  filter()

# Check: nrow(postcovid_obs) should print 46202

# Exercise 3: multiple conditions
# Keep only observations recorded between the start of 2018 and the end 2020
# Use commas to separate multiple conditions AND
obs_2020 <- observation |>
  filter()

# Check: nrow(obs_2020) should print 485124
# alternatively: range(obs_2020$obsdate) to see the minimum and maximum obsdate

# Exercise 4: using %in% to look in a vector/list
# Useful if our list of things to find is small
# Example:
suspect_practices <- c(1, 7, 8)
# --
# Find observations from suspect_practices
# E.g. we think these practices could be systematically undercoding a condition
suspect_obs <- observation |>
  filter()

# Check: nrow(suspect_obs) should print 881122
  
# Exercise 5: missing values
# In R, an NA value is a missing value
# Some operations break or do not work if we have missing values
# We can use !is.na(column_name) or is.na(column_name) to look for
# non-missing or missing values respectively
# --
# Keep only observations with valid obsdate
# Missing obsdate does not allow us to do any kind of progression/temporal 
# analysis, so it's common practice to exclude them if the date matters

valid_obs <- observation |>
  filter()

# Check: nrow(valid_obs) should print 4485464

# Exercise 6: combining different types of comparison 
# Keep only patients alive until the end of 2020 and born between 1950 and 1960
# Hint: patients alive in 2020 might have died after 2020 or not at all
patient_example <- patient |>
  filter()

# Check: nrow(patient_example) should print 4457

# Extra challenge: filter with a small "codelist"
# Later in the workshop, we identify prescriptions belonging to a drug class
# by keeping only the rows whose prodcodeid appears in a codelist.
# Here's a small stand-in codelist (three made-up product codes):
mystery_codes <- drugissue |>
  distinct(prodcodeid) |>
  slice_head(n = 3) |>
  pull(prodcodeid)
# --
# Keep only drugissue rows whose prodcodeid is one of mystery_codes,
# AND that were issued in 2019 or later
mystery_prescriptions <- drugissue |>
  filter()

# Check: nrow(mystery_prescriptions) should be much smaller than nrow(drugissue),
# and all(mystery_prescriptions$prodcodeid %in% mystery_codes) should print TRUE


