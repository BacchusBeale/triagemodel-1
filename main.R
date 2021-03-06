#main program

processingSrc = "Data_preprocessing.R"
dataxls = "ED_Patients_Data.xlsx"

source(file = processingSrc)
start_time <- Sys.time()
inputdata <- loadData(fromAWS = FALSE, localPath = dataxls)
end_time <- Sys.time()
print(end_time - start_time)

csvoutfile = "processedData.csv"
rdatafile = "processedData.RData"
workspacefile = "processedWorkspace.RData"

start_time <- Sys.time()
processed <- preprocessData(data = inputdata, saveCSV = csvoutfile, saveRData = rdatafile, saveWorkspace = workspacefile)
end_time <- Sys.time()
print(end_time - start_time)

# need to define if stopped session

#csvoutfile = "processedData.csv"
rdatafile = "processedData.RData"
#workspacefile = "processedWorkspace.RData"
load(file = rdatafile)

library(dplyr)
# 
# source(file = "outliers.R")
# numericdata <- select_if(data, is.numeric)
# triageRange <- seq(from=1,to=5,by=1)
# triageData <- data$TRIAGE_CATEGORY
# for (triageNumber in triageRange) {
# 
#   filename = paste("outliersTriage", as.character(triageNumber), ".txt", sep = "")
#   plotPrefix <- paste("triage",as.character(triageNumber),sep = "")
# 
#   res <- outlierByTriageCategory(categoryVariable=triageData, 
#                           VariableColumns=numericdata,
#                           triageCatNumber = triageNumber,
#                           saveResultAs=filename,
#                           savePlotPrefix=plotPrefix)
#   print(res)
#   
# }
# 

svmTrainedModel = "model_svm.rds"
svmRData = "svmModelImage.Rdata"
truthtableFile = "svmTruthTable.txt"
svmSrc = "svmModelling_Bacchus.R"
source(file = svmSrc)
# NOTE load data named "data"

library(dplyr)
samplesize = 10000
sampledata = sample_n(data, samplesize)

start_time <- Sys.time()
# NOTE change variable ID, but not used in SVM model

runSVM(inputdata = sampledata, svmkernel = "radial", tableFile=truthtableFile,
       saveModelAs=svmTrainedModel, saveSVMRData=svmRData)

end_time <- Sys.time()

print(end_time - start_time)

