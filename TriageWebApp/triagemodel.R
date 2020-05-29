# https://cran.r-project.org/web/packages/tfdeploy/vignettes/saved_models.html
# https://tensorflow.rstudio.com/deploy/shiny/

# test load model
# requires Miniconda for Python

#testingdata <- load(file = "AppTesting.RData")

library(keras)
library(tensorflow)
library(tfdeploy)

sess <- tensorflow::tf$Session()
triagemodel <- load_savemodel(sess, "savedmodel")

getTriagePrediction <- function(age, gender, height, weight,
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
  
  instanceVars <- list(age, male, female, 
                       height, weight,
                       smoking, pregnancy,
                       avpu, gcs, rr, pulse,
                       heartrate, o2sat)
  
  result <- predict_savedmodel(instances = instanceVars, triagemodel)
  
  return(result)
  
}
