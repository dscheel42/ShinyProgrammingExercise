packrat::on()

library(shinydashboard)
library(dplyr)
library(ggplot2)
library(forcats)
library(data.table)
library(reshape2)

sourceDir = function(path, trace = TRUE,...) {
  for (nm in list.files(path, pattern = "\\.[RrSsQq]$")) {
    if(trace) cat(nm,":")
    source(file.path(path, nm), ...)
    if(trace) cat("\n")
  }
}

sourceDir(path = "appFunctions/tab1Functions")
sourceDir(path = "appFunctions/tab2Functions")


PatientLevelInfo = fread("Random_PatientLevelInfo_2020.tsv", stringsAsFactors = T)
LabValuesInfo = fread("Random_LabValuesInfo_2020.tsv", stringsAsFactors = T)

#Cleaning Patient Level Info

#Extract potential region identifier and patient id from USUBJID and put back into table

splitFrame = tstrsplit(PatientLevelInfo$USUBJID,"-")

PatientLevelInfo$region = paste(splitFrame[[2]],splitFrame[[3]], sep = '-')
PatientLevelInfo$patientId = splitFrame[[5]]

#Recode a treatment arm variable to be a single word describing treatment

#Change the variable naming scheme of PatientLevelInfo to begin with lowercase and capitalize each subsequent concactenated word
#USUBJID remains the same because we will use it join LabValuesInfo and PatientLevelInfo

names(PatientLevelInfo) = c("studyId","USUBJID","age","sex","race","treatmentArm","actArmCd","region","patientId")

#Drop redundant columns

PatientLevelInfo = PatientLevelInfo %>%
  select(-c("actArmCd"))

#Before merging LabValuesInfo to the PatientLevelInfo we 
#reconstruct it so that a single row captures the patient's 3 laboratory value measurements at a particular visit
#calculate difference of measurements between visits for each patient
#calculate the difference betwee the last recorded value week 5 and the baseline value
#create a days from baseline variable
#metadata such as the long name of ALT is excluded from the frame but displayed in the application

PatientByVisit = LabValuesInfo %>% 
  #make screening the first level of ALT
  mutate(AVISIT = fct_relevel(AVISIT,"SCREENING")) %>% 
  group_by(USUBJID,AVISIT) %>%
  #Collect lab values by patient + visit 
  summarise(ALT = AVAL[which(LBTESTCD == 'ALT')],
            CRP = AVAL[which(LBTESTCD == 'CRP')],
            IGA = AVAL[which(LBTESTCD == "IGA")],
            BMRKR1 = unique(BMRKR1),
            BMRKR2 = unique(BMRKR2)) %>%
  #I want baseline to be 0 and screening to be negative (before the trial)
  mutate(VISIT_NUM = as.numeric(AVISIT) - 2,
         diffALT = c(NA,diff(ALT)),
         diffCRP = c(NA,diff(CRP)),
         diffIGA = c(NA,diff(IGA)),
         #-1 is assigned to SCREENING as it occurs before the baseline record.
         daysFromBaseline = recode(as.numeric(AVISIT),-1,0,7,14,21,28),
         endDiffBaselineALT = ALT[which(VISIT_NUM == 5)] - ALT[which(VISIT_NUM == 0)],
         endDiffBaselineCRP = CRP[which(VISIT_NUM == 5)] - CRP[which(VISIT_NUM == 0)],
         endDiffBaselineIGA = IGA[which(VISIT_NUM == 5)] - IGA[which(VISIT_NUM == 0)]
  ) %>%
  select(-c("VISIT_NUM","AVISIT"))

names(PatientByVisit) = c("USUBJID","ALT","CRP","IGA","firstBiomarker","secondBiomarker",
                          "diffALT","diffCRP","diffIGA","daysFromBaseline",
                          "endDiffBaselineALT","endDiffBaselineCRP","endDiffBaselineIGA")

#Join together the PatientLevelInfo and PatientByVisit (formerly LabValuesInfo) frames

TrialFrame = left_join(PatientLevelInfo,PatientByVisit,by = 'USUBJID') %>%
  mutate_if(is.integer,as.numeric)


#Changing the ordering and vlaues of some factor levels to be better formatted

#Changing the factor variable values to be formatted for the application display

#dplyr::glimpse(TrialFrame %>% select_if(is.factor))


TrialFrame = TrialFrame %>%
  mutate(sex = recode_factor(sex,
                             'F' = 'Female',
                             'M' = 'Male',
                             'UNDIFFERENTIATED' = 'Undifferentiated'),
         race = as.factor(paste(stringr::str_to_title(race))),
         secondBiomarker = recode_factor(secondBiomarker,
                                         "LOW" = 'Low',
                                         "MEDIUM" = 'Medium',
                                         "HIGH" = 'High'),
         treatmentArm = recode_factor(treatmentArm,
                                      'A: Drug X' = 'Arm A: Drug X',
                                      'B: Placebo' = 'Arm B: Placebo',
                                      'C: Combination' = 'Arm C: Combination'
                                      )
         )


#Global Frame for each tab so that it does not need to perform these operations when selected characteristics change
screeningFrame = TrialFrame %>% filter(daysFromBaseline == -1)

noScreenFrame = TrialFrame %>% 
  filter(daysFromBaseline >= 0) %>%
  mutate(daysFromBaseline = as.factor(daysFromBaseline))

# names(TrialFrame)

# variableDisplayNames = data.frame(shortname = c("age","sex","race","treatmentArm",
#                                                 "ALT","CRP","IGA","firstBiomarker",
#                                                 "secondBiomarker","diffALT","diffCRP",
#                                                 "diffIGA","daysFromBaseline",
#                                                 "endDiffBaselineALT","endDiffBaselineCRP",
#                                                 "endDiffBaselineIGA"))
# 
# variableDisplayNames$longname = c("Age","Sex","Race","Treatment Arm",
#                                   "")