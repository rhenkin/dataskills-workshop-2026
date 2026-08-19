# Osteoarthritis and BMI case study

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
practice <- read_tsv("data/Practice.txt")
region <- read_tsv("data/Region.txt")

# Codelists
osteoarthritis <- read_tsv("codelists/oa.txt", col_types = cols(MedCodeId = col_character())) |>
  rename(medcodeid = MedCodeId)
bmi <- read_tsv("codelists/exeter_bmi.txt", col_types = cols(MedCodeId = col_character())) |>
  rename(medcodeid = MedCodeId)

# Study period
study_start <- as.Date("2022-01-01")
study_end <- as.Date("2025-12-31")

# Hint for finding the closest BMI: obsdate could fall before OR after diagnosis_date, so a plain
# subtraction could be negative. abs(as.numeric(date1 - date2)) gives you
# the distance in days regardless of direction:
#   as.numeric() turns the date difference into a plain number
#   abs() drops the sign