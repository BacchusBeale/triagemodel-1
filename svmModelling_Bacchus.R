#SVM analysis by Bacchus Beale

# https://www.datacamp.com/community/tutorials/support-vector-machines-r

runSVM <- function(inputdata, svmkernel="radial", tableFile=NULL, saveModelAs=NULL, saveSVMRData=NULL){
  # csvfile <- "processedData.csv"
  # chunksize <- 10000
  # svmkernel <- "radial"
  # 
  # ERdata <- read.csv(csvfile, header = T, sep = ",",nrows = chunksize)
  # 
  # print("Before cleaning")
  # str(ERdata)
  
  # clean and transform  variables
  library(tidyverse)
  ERdata <- inputdata
  
  avg.age <- mean(ERdata$AGE, na.rm = T)
  ERdata$AGE <- replace_na(ERdata$AGE, avg.age)
  
  ERdata$GENDER <- as.factor(ERdata$GENDER)
  
  ERdata$TRIAGE_CATEGORY <- replace_na(ERdata$TRIAGE_CATEGORY,5)
  ERdata$TRIAGE_CATEGORY <- as.factor(ERdata$TRIAGE_CATEGORY)
  
  ERdata$SMOKING_STATUS <- as.factor(ERdata$SMOKING_STATUS)
  
  ERdata$PREGNANCY_STATUS <- as.factor(ERdata$PREGNANCY_STATUS)
  
  ERdata$MODEL_OF_CARE <- as.factor(ERdata$MODEL_OF_CARE)
  
  ERdata$AVPU_1 <- as.factor(ERdata$AVPU_1)
  
  ERdata$GCS_1 <- as.factor(ERdata$GCS_1)
  
  avg.rr1 <- mean(ERdata$RR_1, na.rm = T)
  ERdata$RR_1 <- replace_na(ERdata$RR_1,avg.rr1)
  
  avg.o21 <- mean(ERdata$O2SATS_1, na.rm = T)
  ERdata$O2SATS_1 <- replace_na(ERdata$O2SATS_1,avg.o21)
  
  
  avg.fio1 <- mean(ERdata$FIO2_1, na.rm = T)
  ERdata$FIO2_1 <- replace_na(ERdata$FIO2_1,avg.fio1)
  
  avgpulse1 = mean(ERdata$PULSE_1, na.rm = T)
  ERdata$PULSE_1 <- replace_na(ERdata$PULSE_1,avgpulse1)
  
  avgheart1 <- mean(ERdata$HEART_RATE_1, na.rm = T)
  ERdata$HEART_RATE_1 <- replace_na(ERdata$HEART_RATE_1,avgheart1)
  
  avgsbp1 = mean(ERdata$SBP_1, na.rm = T)
  ERdata$SBP_1 <- replace_na(ERdata$SBP_1,avgsbp1)
  
  avgdbp1 <- mean(ERdata$DBP_1, na.rm = T)
  ERdata$DBP_1 <- replace_na(ERdata$DBP_1,avgdbp1)
  
  avgmap1 <- mean(ERdata$MAP_1, na.rm = T)
  ERdata$MAP_1 <- replace_na(ERdata$MAP_1, avgmap1)
  
  avgtymp1 <- mean(ERdata$TEMP_TYMP_1, na.rm = T)
  ERdata$TEMP_TYMP_1 <- replace_na(ERdata$TEMP_TYMP_1,avgtymp1)
  
  avgoral1 <- mean(ERdata$TEMP_ORAL_1, na.rm = T)
  ERdata$TEMP_ORAL_1 <- replace_na(ERdata$TEMP_ORAL_1,avgoral1)
  
  avghgt <- mean(ERdata$PATIENT_HEIGHT, na.rm = T)
  ERdata$PATIENT_HEIGHT <- replace_na(ERdata$PATIENT_HEIGHT, avghgt)
  
  avgweight <- mean(ERdata$PATIENT_WEIGHT, na.rm = T)
  ERdata$PATIENT_WEIGHT <- replace_na(ERdata$PATIENT_WEIGHT,avgweight)
  
  print("After cleaning")
  str(ERdata)
  
  print("Select data")
  # target variable
  triage.category = ERdata$TRIAGE_CATEGORY
  
  # dependent variables
  svmdata <- select(ERdata,
                    TRIAGE_CATEGORY,
                    AGE,
                    GENDER,
                    PATIENT_WEIGHT,
                    PATIENT_HEIGHT,
                    PREGNANCY_STATUS,
                    SMOKING_STATUS,
                    AVPU_1,
                    GCS_1,
                    RR_1,
                    PULSE_1,
                    HEART_RATE_1,
                    O2SATS_1)
  
  str(svmdata)
  
  # split train and test data
  # https://rpubs.com/ID_Tech/S1
  
  print("Split data")
  require(caTools)
  set.seed(123)
  sample = sample.split(svmdata,SplitRatio = 0.75)
  traindata = subset(svmdata, sample==TRUE)
  testdata = subset(svmdata, sample==FALSE) # had = instead of == !!!

  
  # SVM
  print("Run SVM")
  library(e1071)
  # scale variables
  svmmodel = svm(traindata$TRIAGE_CATEGORY ~ ., data = traindata, 
                 scale = F, type="C-classification", 
                 kernel = svmkernel, cost = 1, probability = TRUE)
  
  print("svm model output")
  print(svmmodel)
  print("svm model summary")
  summary(svmmodel)
  
  #print vectors
  print("support vectors")
  supportvectors <- svmmodel$index
  print(supportvectors)
  
  # test
  print("predict")
  svm.pred <- predict(svmmodel, testdata, decision.values = TRUE, probability = TRUE)
  print(svm.pred)
  
  # accuracy
  # print("check")
  # values <- attr(svm.pred, "decision.values")
  # cat("decision-values: ", values, "\n")
  # probs <- attr(svm.pred, "probabilities")
  # cat("probabilities: ",probs, "\n")
  
  # errors
  print("errors")
  
  correctRate = sum(svm.pred==testdata$TRIAGE_CATEGORY)/length(testdata$TRIAGE_CATEGORY)
  misRate=1-correctRate
  
  cat("correctRate: ", correctRate, "\n")
  cat("misRate: ", misRate, "\n")
  
  
  #table
  print("table")
  # error must be same size: TO BE FIXED
  # truthtable <- table(prediction = svm.pred, truth = testdata$TRIAGE_CATEGORY)
  # print(truthtable)
  # 
  # if(!is.null(tableFile)){
  #   write.table(truthtable, file = tableFile, sep = ",", quote = F)
  # }
  
  #save model
  # https://www.mydatahack.com/how-to-save-machine-learning-models-in-r/
  
  if(!is.null(saveModelAs)){
    saveRDS(svmmodel, file = saveModelAs)  
  }
  
  if(!is.null(saveSVMRData)){
    save.image(file = saveSVMRData)
  }
  
  
}