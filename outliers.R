# outlier analysis, cleaning
require(dplyr)

outlierByTriageCategory <- function(categoryVariable, VariableColumns, triageCatNumber=1, 
                                    removeNA=F, imputeMeans=T, saveResultAs=NULL){
  
  df <- data.frame(categoryVariable, VariableColumns)
  #str(df)
  
  triageGroupData <- filter(df, as.integer(df$TRIAGE_CATEGORY)==triageCatNumber)
  str(triageGroupData)
  
  numCols <- length(triageGroupData)
  varNames <- names(triageGroupData)
  
  results = list()
  
  for (i in seq(from=2,to=numCols,by=1)) {
    valVector <- select(triageGroupData, i)
    valName <- varNames[i]
    outlier_vals <- boxplot.stats(valVector)$out
    results[[valName]] <- outlier_vals
    
    if(is.null(saveResultAs)==FALSE){
      save(results, file = saveResultAs)
    }
  }
   
  
  print("Outlier detection Completed!")
}

