# outlier analysis, cleaning
require(dplyr)

outlierByTriageCategory <- function(categoryVariable, VariableColumns, triageCatNumber=1, 
                                   saveResultAs="out.txt", savePlotPrefix="out.jpg"){
  
  df <- data.frame(TRIAGE_CATEGORY=categoryVariable, VariableColumns)
  print("df")
  str(df)
  
  triageGroupData <- filter(df, as.integer(df$TRIAGE_CATEGORY)==triageCatNumber)
  print("triage data")
  str(triageGroupData)
  
  numCols <- length(triageGroupData)
  varNames <- names(triageGroupData)
  
  results = list()
  
  for (i in seq(from=2,to=numCols,by=1)) {
    valVector <- triageGroupData[,i]
    valName <- varNames[i]
    
    boxstats <- boxplot.stats(valVector)
    
    outlier_stats <- boxstats$stats
    outlier_vals <- boxstats$out
    
    statName <- paste(valName,"_stats", as.character(i),"_",as.character(triageCatNumber),sep = "")
    outName <- paste(valName, "_out", as.character(i),"_",as.character(triageCatNumber), sep = "")
    
    labelA <- paste(valName, as.character(i),"A",as.character(triageCatNumber),sep = "")
    results[[labelA]] <- paste(valName," Stats",sep = "")
    results[[statName]] <- outlier_stats
    
    labelB <- paste(valName, as.character(i),"B",as.character(triageCatNumber),sep = "")
    results[[labelB]] <- paste(valName," Outliers",sep = "")
    results[[outName]] <- outlier_vals
    
    plotName <- paste(savePlotPrefix, "_" ,valName, ".jpg", sep = "")

    jpeg(filename = plotName)
    boxplot(valVector,
            main=paste("Triage Category vs ",as.character(triageCatNumber),valName, sep=""),
            ylab=valName)

    dev.off()
    
  }
   
  lapply(results, write, saveResultAs, append=TRUE)
  
  print("Outlier detection Completed!")
  
  return("OK")
}

