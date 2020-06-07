# https://cran.r-project.org/web/packages/tfdeploy/vignettes/saved_models.html
# https://tensorflow.rstudio.com/deploy/shiny/

#install.packages('tensorflow')
library(tensorflow)
library(keras)
library(tfdeploy)
library(reticulate)
use_condaenv(condaenv = "r-reticulate")
getTriagePrediction <- function(savedmodel, age, gender, height, weight,
                           smoking, pregnancy,
                           avpu, gcs, rr, pulse,
                           heartrate, o2sat){
  
  # split gender: Male==1, Female==2
  male = 0
  female = 1
  
  if(gender==1){
    male = 1
    female = 0
  }

  instanceVars <- list(c(age, male, female, 
                       height, weight,
                       smoking, pregnancy,
                       avpu, gcs, rr, pulse,
                       heartrate, o2sat))
  
  
  result <- tfdeploy::predict_savedmodel(instances = instanceVars, savedmodel)
  
  return(result)
  
}

#use_miniconda("r-reticulate", required = T)
sess <- NULL
triagemodel <- tfdeploy::load_savedmodel(sess, "savedmodel")

# res <- getTriagePrediction(savedmodel = "savedmodel",
#                             age = 15,
#                              gender=1, height=173, weight=54,
#                              smoking=1, pregnancy=1,
#                              avpu=1, gcs=2, rr=56, pulse=23,
#                              heartrate=65, o2sat=99
#                              )
# print(res)
