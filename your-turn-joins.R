# Your Turn exercises: joins

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
ras_codelist <- read_tsv("codelists/ras.txt")

# Join operations

# Example 1: inner_join
# Join drugissue with the ras_codelist
# Keeps only the rows from drugissue that are found in the codelist
ras_prescriptions <- drugissue |>
  inner_join(ras_codelist, by = "prodcodeid")

# Your turn

# Exercise 1: different codelist
# Load a CCB codelist and create a table for them
ccb_prescriptions <- drugissue |>
  

# Check: nrow(ccb_prescriptions) is smaller than nrow(drugissue)

# Exercise 2: join observation
# Load the depression codelist and join with observation
depression_obs <- observation 
  
# Check: nrow(depression_obs) is smaller than nrow(observation)
  
# Example 2: left_join
# Left join will keep rows from the first table (patient), even if
# the patid in question is not found in the second table. In this case,
# all the columns from drugissue will be NA
patient_di <- patient |>
  left_join(drugissue, by = "patid")

# We can check what happened here with:
patient_di |>
  filter(is.na(issueid)) |>
  select(patid, issueid)

# We can also confirm we were not expecting any issueid to be missing in
# the drugissue table:
any(is.na(drugissue$issueid))

# Exercise 3: left_join
# Using group by and summarise, create a table that counts prescriptions per patient
# Use a column called n_prescriptions
# Then use left_join to combine patient and the new table
prescription_counts <- drugissue |>
  group_by() |>
  summarise( , .groups = "drop")

patient_with_counts <- patient |>
  left_join()

# Check: summary(patient_with_counts$n_prescriptions) has median of 3 and 38693 NAs

# Example 3: inequality/non-equi joins
# The previous join operations worked on exact matching of values between tables
# Inequality joins are simply a way of relaxing the exact matching to use ranges, 
# which are useful for dates and values
#
# For example, we can use regstartdate from the patient table to select only
# the observations that were entered after the registration date
# If we use a normal join, we would only retrieve observations on the same date
# of registration

patient_simple <- patient |> select(patid, regstartdate)

# Note that the by argument is more complex now, we explicitly write the 
# conditions that should match between the rows in each table
observations_after_reg <- observation |>
  inner_join(
    patient_simple,
    by = join_by(patid == patid, obsdate > regstartdate)
  )

# Read the join_by() condition like this: "match rows where patid is
# equal, AND regstartdate is less than or equal to obsdate" — i.e. only
# keep observations that happened on or after the patient's
# registration start.
#
# With join_by, the variable names on the left-hand side of the formula should be
# from the first table (observation). If we wrote regstartdate <= obsdate we 
# would have got an error message

# Exercise 4: inequality joins
# Using the pattern above, find the prescriptions that were issued after
# the patient's registration start date. Use patient_simple above 

drugissue_after_reg <- drugissue |>

# Check: nrow(di_after_reg) prints 74012

# Extra challenge: finding what's NOT there with anti_join
# So far every join has kept rows that DO match. anti_join() does the
# opposite: it keeps rows from the first table that have NO match in the
# second table, and drops all the columns from the second table entirely.
# This is useful for cohort exclusions and documentation, e.g. "which 
# patients were never prescribed anything at all?"
# --
# Use anti_join to find the patients in `patient` that do NOT appear in
# drugissue (by patid)
untreated_patients <- patient |>
  anti_join(drugissue, by = "patid")

# Check: nrow(untreated_patients) + n_distinct(drugissue$patid) should be
# close to nrow(patient) -- "close to" because a patient could in principle
# appear in drugissue with a patid not present in patient, though that
# shouldn't happen in clean data

# --
# Now go the other way: use anti_join to find rows in drugissue whose
# prodcodeid does NOT appear in the ras_codelist loaded at the top of this
# file (i.e. prescriptions definitely not a RAS drug)
non_ras_prescriptions <- drugissue |>
  anti_join()

# Check: nrow(non_ras_prescriptions) + nrow(ras_prescriptions) prints
# nrow(drugissue)
