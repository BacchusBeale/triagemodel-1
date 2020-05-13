library(readxl)
library(tidyverse)
library(lubridate)
library(reshape2)

#### load data ####
temp <- tempfile(fileext = ".xlsx")
download.file("https://jcudata.s3-ap-southeast-2.amazonaws.com/ED_Patients_Data.xlsx",temp)
data <- as.data.frame(read_excel(temp))

# review missing values
str(data)
missing <- as.data.frame(map(data, ~sum(is.na(.))))
# write.csv(missing, "missing.csv")

#### remove variables with no data ####
data$MEDICATION_USED_STEROIDS_DT_TM <- NULL
data$MEDICATION_USED_IMMUNO_DT_TM <- NULL 
data$MEDICATION_USED_ANTIB_DT_TM <- NULL
data$MEDICATION_USED_ANTINF_DT_TM <- NULL 
data$MEDICATION_USED_OTHER_DT_TM <- NULL 

#### convert datatypes ####

# factors
data$PATIENT_ID <- as.factor(data$PATIENT_ID)

# remove unknown genders
data <- data[ !data$GENDER %in% c("Indetermin", "Unknown"), ]
data$GENDER <- as.factor(data$GENDER)
data$HOSPITAL <- as.factor(data$HOSPITAL)
data$TRIAGE_CATEGORY <- as.factor(data$TRIAGE_CATEGORY)
data$MODEL_OF_CARE <- as.factor(data$MODEL_OF_CARE)
data$PRESENTING_PROBLEM <- as.factor(data$PRESENTING_PROBLEM)
data$AVPU_1 <- as.factor(data$AVPU_1)
data$AVPU_2 <- as.factor(data$AVPU_2)

# datetimes
data$TRIAGE_DT_TM <- as_datetime(data$TRIAGE_DT_TM, tz = "UTC", format = NULL)
data$AVPU_1_DT_TM <- as_datetime(data$AVPU_1_DT_TM, tz = "UTC", format = NULL)
data$AVPU_2_DT_TM <- as_datetime(data$AVPU_2_DT_TM, tz = "UTC", format = NULL)
data$GCS_1_DT_TM <- as_datetime(data$GCS_1_DT_TM, tz = "UTC", format = NULL)
data$GCS_2_DT_TM <- as_datetime(data$GCS_2_DT_TM, tz = "UTC", format = NULL)
data$RR_1_DT_TM <- as_datetime(data$RR_1_DT_TM, tz = "UTC", format = NULL)
data$RR_2_DT_TM <- as_datetime(data$RR_2_DT_TM, tz = "UTC", format = NULL)
data$O2SATS_1_DT_TM <- as_datetime(data$O2SATS_1_DT_TM, tz = "UTC", format = NULL)
data$O2SATS_2_DT_TM <- as_datetime(data$O2SATS_2_DT_TM, tz = "UTC", format = NULL)
data$FIO2_1_DT_TM <- as_datetime(data$FIO2_1_DT_TM, tz = "UTC", format = NULL)
data$FIO2_2_DT_TM <- as_datetime(data$FIO2_2_DT_TM, tz = "UTC", format = NULL)
data$PULSE_1_DT_TM <- as_datetime(data$PULSE_1_DT_TM, tz = "UTC", format = NULL)
data$PULSE_2_DT_TM <- as_datetime(data$PULSE_2_DT_TM, tz = "UTC", format = NULL)
data$HEART_RATE_1_DT_TM <- as_datetime(data$HEART_RATE_1_DT_TM, tz = "UTC", format = NULL)
data$HEART_RATE_2_DT_TM <- as_datetime(data$HEART_RATE_2_DT_TM, tz = "UTC", format = NULL)
data$SBP_1_DT_TM <- as_datetime(data$SBP_1_DT_TM, tz = "UTC", format = NULL)
data$SBP_2_DT_TM <- as_datetime(data$SBP_2_DT_TM, tz = "UTC", format = NULL)
data$DBP_1_DT_TM <- as_datetime(data$DBP_1_DT_TM, tz = "UTC", format = NULL)
data$DBP_2_DT_TM <- as_datetime(data$DBP_2_DT_TM, tz = "UTC", format = NULL)
data$MAP_1_DT_TM <- as_datetime(data$MAP_1_DT_TM, tz = "UTC", format = NULL)
data$MAP_2_DT_TM <- as_datetime(data$MAP_2_DT_TM, tz = "UTC", format = NULL)
data$TEMP_TYMP_1_DT_TM <- as_datetime(data$TEMP_TYMP_1_DT_TM, tz = "UTC", format = NULL)
data$TEMP_TYMP_2_DT_TM <- as_datetime(data$TEMP_TYMP_2_DT_TM, tz = "UTC", format = NULL)
data$TEMP_ORAL_1_DT_TM <- as_datetime(data$TEMP_ORAL_1_DT_TM, tz = "UTC", format = NULL)
data$TEMP_ORAL_2_DT_TM <- as_datetime(data$TEMP_ORAL_2_DT_TM, tz = "UTC", format = NULL)

# binary
data$SMOKING_STATUS <- as.logical(data$SMOKING_STATUS)

# Recode Pregnancy Status when it is = to 2
data$PREGNANCY_STATUS <- recode(data$PREGNANCY_STATUS, `2` = 1)
# convert Pregnancy Status to binary
data$PREGNANCY_STATUS <- as.logical(data$PREGNANCY_STATUS)


# create uniqueID
data <- data %>% mutate(ID = paste(PATIENT_ID, TRIAGE_DT_TM, sep = '_'))
# check distinct
n_distinct(data$ID, na.rm = FALSE)

# todo create age group variable (David is doing this)

# move unique ID to first column and Triage Category to second column
data <- data %>% select(ID, TRIAGE_CATEGORY, everything()) 

# Lists of variable types to use for indexing
Numeric_cols <- colnames(data %>% select_if(is.numeric))
Factor_cols <-colnames(data %>% select_if(is.factor))
Datetime_cols <- colnames(data %>% select_if(is.POSIXct))
Logical_cols <- colnames(data %>% select_if(is.logical))
Second_dt_cols <- Datetime_cols[endsWith(Datetime_cols, '_2_DT_TM')]
Second_obs_cols <- Numeric_cols[endsWith(Numeric_cols, '_2')]

# example of subsetting the data
# create a subset of numeric values
Numeric_data <- data[,Numeric_cols]
# create a subset of numeric values
Factor_data <- data[ ,Factor_cols]
# create a subset of numeric values minus the second observations
Numeric_data_initial <- Numeric_data[,Second_obs_cols]

# write processed data to new file
data.table::fwrite(data, "processedData.csv", row.names = F, sep = ",")
