# Your Turn exercises: mutate

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

# Mutate operations

# Example:
# Create column age_2020: approximate age in 2020
patient_with_age <- patient |>
  mutate(age_2020 = 2020 - yob)

# Your turn

# Exercise 1: Use two columns 
# Create a new column reg_duration that calculates how long the patient
# has been registered  Note: patients that have not ended registration will have
# reg_duration equal to NA
patient_reg_duration <- patient |>
  mutate()

# Check: summary(patient_reg_duration$reg_duration) prints median 1547, mean 3269
# and 16188 NAs

# Exercise 2: Creating binary flags (TRUE/FALSE)
# Annotate drugissue with a before_covid flag for prescriptions issued before
# 2020
# Note: we can use the same condition logic from the filter operation

di_before2020 <- drugissue |>
  mutate()

# Check: table(di_before2020$before_covid) prints 4220 FALSE and 83459 TRUE

# Exercise 3: Create flag from variable with missing values
# Create `died` flag: if emis_ddate is not NA, the flag should be TRUE
# The idea is similar to the above one
patient_flagged <- patient |>
  mutate()

# Check: table(patient_flagged$died) prints 42288 FALSE and 3374 TRUE

# Exercise 4: using if_else to edit a column
# We can use if_else within mutate to create a new variable that is not logical
# if_else(yob<1900, 1900, yob) would change possible invalid
# years of birth to 1900
# --
# Let's create a patient status 'alive' or 'died' using the died flag

patient_flagged <- patient_flagged |>
  mutate()

# Check: table(patient_flagged$status) prints alive 42288 and died 3374

# Exercise 4: create categories using case_when()
# if_else() can be used for simple categories
# case_when() can be used for more complex categories such as age groups:
# mutate(new_column = case_when(
#     yob == 1990 ~ "value1",
#     yob > 1990 ~ "value2",
#     yob < 1990 ~ "value3"
#     TRUE ~ "default_value"
#   )
# Use value between double quotes to create a category using text
# the condition before the tilde is similar to any used in filter() or the
# right side of mutate
# Each row that does not match one condition, is tested on the next one 
# Until the default one (TRUE ~ "default")
# --
# Using age_2020 from patient_with_age, classify patient in age bands
# Use 18-30,31-69,70+ categories
# Hint: some categories need to satisfy TWO conditions
# We can use & to combine these two conditions
# Example: yob > 1990 & yob < 1995 selects patients born in 91, 92, 93 and 94

patient_with_age_group <- patient_with_age |>
  mutate(age_group = case_when(
    condition ~ "category", # Edit from here
    ..,
    TRUE ~ "<18" # This is the value for patients 
                          # that do no match any previous condition
  ))

# Check: table(patient_with_age_group$age_group) prints 4941, 6174, 24520 and 10027

# Exercise 5: case_when with multiple variables
# case_when is not restricted to a single variable in the condition
# The variables tested can even be of different types
# We can use case_when and multiple conditions to create a follow_up_status
# Let's assume our study ended in 2020-01-01, use the following rules:
#  "died" = if emis_ddate is not NA (hint: status and died can be used here too)
#  "censored" = if emis_ddate is NA and regenddate is before 2020-01-01
#  "completed" = if emis_ddate is NA and regendddate is NA OR after study end
# Let's use the patient_flagged table which already has the variables 'status' and 'died'
# Hint: the last group does not need any condition tested

patient_flagged <- patient_flagged |>
  mutate()

# Check: table(patient_flagged$follow_up_status) prints 25871, 16417 and 3374

# Extra challenge: flagging short registration periods
# We'll later need to reason about how much time passed between two dates,
# and use that duration to create a flag -- similar to reg_duration in
# Exercise 1, but now turning the number into a TRUE/FALSE column
# --
# Using patient_reg_duration from Exercise 1, create a short_reg flag:
# TRUE if reg_duration is 180 days or fewer, FALSE otherwise
# Note: reg_duration is NA for patients who have not ended registration
# (see Exercise 1) -- short_reg will stay NA for those patients too, not
# become FALSE.
patient_reg_duration <- patient_reg_duration |>
  mutate()

# Check: table(patient_reg_duration$short_reg, useNA = "always") shows 3965
# TRUE, 25509 FALSE, and 16188 NA (matching the NA count from Exercise 1)
