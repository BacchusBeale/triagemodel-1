#main program

processingSrc = "Data_preprocessing.R"
svmSrc = "svmModelling_Bacchus.R"

dataxls = "ED_Patients_Data.xlsx"

source(file = processingSrc)

inputdata <- loadData(fromAWS = FALSE, localPath = dataxls)

csvoutfile = "processedData.csv"
rdatafile = "processedData.RData"
workspacefile = "processedWorkspace.RData"

processed <- preprocessData(data = inputdata, saveCSV = csvoutfile, saveRData = rdatafile, saveWorkspace = workspacefile)

load(file = rdatafile)

svmTrainedModel = "model_svm.rda"
svmRData = "svmModelImage.Rdata"
source(file = svmSrc)
# NOTE load data named "data"
runSVM(inputdata = data, svmkernel = "radial", saveModelAs=svmTrainedModel, saveSVMRData=svmRData)

# load model
load(file = svmTrainedModel)
svmModel <- readRDS(svmTrainedModel)