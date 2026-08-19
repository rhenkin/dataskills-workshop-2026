# Your Turn exercises: group by and summarise

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

# Group by and summarise operations

# Example: 
# Count prescriptions issued per prodcodeid
# n() counts the number of rows in the group
# group_by splits the original dataset based on the values of prodcodeid
product_counts <- drugissue |>
  group_by(prodcodeid) |>
  summarise(n_issues = n(), .groups = "drop")

# Your turn

# Exercise 1: counting
# Count the number of patients per gender in the patient table
gender_counts <- patient |>
  group_by() |>
  summarise(, .groups = "drop")

# Check: print(gender_counts) shows a table with 3 rows with values 21800, 23861
# and 1 for genders 1, 2 and 3 (we have not mapped gender to the lookup table)

# Exercise 2: multiple calculations 
# For each prodcodeid, find the earliest and latest issue date
# Hint 1: we can use commas to create multiple columns at the same time
# Hint 2: min() and max() also work with date columns
product_date_range <- drugissue |>
  group_by() |>
  summarise( , .groups = "drop")

# Check: print(product_date_range) prints three columns: prodcodeid, 
# and the two columns you created

# Exercise 3: counting distinct objects
# The example calculated the number of prescriptions issued
# Use the n_distinct() function to calculate the number of different patients
# that were prescribed each drug, using prodcodeid
patients_per_prodcode <- drugissue |>
  group_by() |>
  summarise(, .groups = "drop")

# Check: head(patients_per_prodcode) shows two columns: procodeid and the column you calculated
# alternatively: pick one prodcode id and filter drugissue by that procodeit and check the unique
# patids 

# Exercise 4: two grouping variables
# For each patient and procodeid, find the earliest issue date 
# group_by can contain as many variables as needed for group operations, 
# separated by commas
first_per_patient_prodcode <- drugissue |>
  group_by() |>
  summarise(, .groups = "drop")

# Check: head(first_per_patient_prodcode) prints a table with four rows
# for patient 1024, with one date in 2019 and 3 on the same day in 2016

# Exercise 5: using mutate with group by
# Summarise generates a single row per group
# Sometimes we want to work with patient data, but we do not want to create
# a summary for that group. We might simply want to calculate something for
# each patient. We can use mutate in that case, instead of summarise
# --
# For each patient, add two columns using mutate:
# earliest_issuedate: the first issuedate for that patient
# days_since_first_issue: difference between issuedate and earliest_issuedate
# Create each column in the order specified above: when creating the second
# column, the first one (earliest_issuedate) will be available for the calculation
drugissue_grouped <- drugissue |>
  group_by() |>
  mutate()

# Check: summary(drugissue_grouped$days_since_first_issue) prints median of 712

# Exercise 6: two-variable group and mutate
# Create a first_date_prodcode column which records the 
# earliest issuedate for each combination of patid and prodcodeid
# We will use mutate again to preserve all the prescriptions
# This exercise has a similar logic to the previous one, but operating at a more
# detailed grouping structure

finer_group <- drugissue |>
  group_by() |>
  mutate()

# Check: colnames(finer_group) should include all drugissue 
# columns with the addition of first_date_prodcode

# Extra challenge: sequence of events within a group
# So far we've pulled out the earliest date per group. Sometimes we need to
# know the ORDER of events for a patient (e.g. which drug was their second
# ever prescription) rather than just the first.
# --
# New function: arrange() sorts a table by one or more columns (ascending by
# default). We haven't used it yet, but it's simple: arrange(col1, col2)
# sorts by col1, then breaks ties using col2. It works outside of group_by
# too, on any table.
# --
# New function: row_number() gives each row a rank (1, 2, 3, ...) within its
# group, based on the order the rows are currently in. That's why we need to
# arrange() by date FIRST, so that rank 1 really is the earliest date.
# --
# For each patient, order their prescriptions by issuedate (earliest first)
# and add a column presc_order with their rank (1 = first ever prescription,
# 2 = second, etc). Ties (same issuedate) can end up in any order.
drugissue_ordered <- drugissue |>
  arrange(patid, issuedate) |>
  group_by(patid) |>
  mutate(presc_order = row_number())

# --
# Using drugissue_ordered, keep only each patient's second ever
# prescription -- this is the pattern we'll reuse later to
# find a patient's second drug class, when checking for treatment escalation
second_prescriptions <- drugissue_ordered |>
  filter()

# Note: second_prescriptions is still grouped by patid (mutate/filter don't
# drop groups the way summarise(.groups = "drop") does). It's good practice 
# to ungroup() once you no longer need the grouping, so later steps don't 
# silently operate per group.

# Check: nrow(second_prescriptions) prints 4643

