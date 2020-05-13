#main program
dataxls = "ED_Patients_Data.xlsx"

source(file = "Data_preprocessing.R")

inputdata <- loadData(fromAWS = FALSE, localPath = dataxls)

processed <- preprocessData(data = inputdata, saveCSV = T, saveRData = T, saveWorkspace = T)

