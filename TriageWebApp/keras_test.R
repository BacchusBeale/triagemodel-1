#### load libraries ####
library(tidyverse)
library(tensorflow)
library(reticulate)
library(feather)
# make sure tensorflow is running in the right python environment
use_condaenv("py3.6", required = TRUE) # you might need to change this to your python environment name
library(keras)

#### load data ####
path = "AppTesting.RData" # this is an output of Data_preprocessing_all.R and saved locally
load(path)

#### Prepare multiclass response variables for neuralnet models ####
# convert response variable back to a categorical variable to enable one hot encoding
Numeric_test$TRIAGE_CATEGORY <- as.factor(Numeric_test$TRIAGE_CATEGORY)
# Add a dummy class to allow for all factors
levels(Numeric_test$TRIAGE_CATEGORY) <- c(levels(Numeric_test$TRIAGE_CATEGORY),"fake")
# relevel to make fake class the first factor
Numeric_test$TRIAGE_CATEGORY <- relevel(Numeric_test$TRIAGE_CATEGORY, ref = "fake")
# create dummy variables and remove the intercept
response_multinom <- model.matrix(~TRIAGE_CATEGORY, data=Numeric_test)[,-1]
# create final numeric response variables as a separate data frame
response_multinom <- as.data.frame(response_multinom)
## Create neural network Data with multiple classes as response ##
Numeric_allvars <- cbind(response_multinom, Numeric_test[,-1])
Numeric_allvars <- as.data.frame(Numeric_allvars)

#### Partition data ####
set.seed(123)
no_observations <- dim(Numeric_allvars)[1] 
test_index <- sample(no_observations, size=as.integer(no_observations*0.3), replace=FALSE) 
training_index <- -test_index 
train <- Numeric_allvars[training_index,]
test <- Numeric_allvars[test_index,]

#### Create data as matrices for Keras ####
Y_train = data.matrix(train[, 1:5])
X_train  = data.matrix(train[, 6:ncol(train)])

Y_test = data.matrix(test[, 1:5])
X_test  = data.matrix(test[, 6:ncol(train)])

# create tensor shape variable
k = ncol(X_train)
# create a vector with ground truth of test data
test.truth <- test[,1:5]
actual <- max.col(test.truth)

### keras_crossentropy, 1 Hidden layer, 100 nodes each, with L2 regularisation, tanh activation, softmax output, 20 epochs ####
keras_crossentropy <- keras_model_sequential() 
keras_crossentropy %>% 
  layer_dense(units = 100, activation = 'tanh', input_shape = k ) %>%
  layer_dense(units = 5, activation = 'softmax')

# check model structure
summary(keras_crossentropy)

## compile 
keras_crossentropy %>% compile(
  loss = 'categorical_crossentropy',
  optimizer = "adam",  
  metrics = c('accuracy')
)

# fit model and track history
tic()
track.keras_crossentropy = keras_crossentropy %>% fit(X_train, Y_train, epochs = 20, batch_size = 64,
                                                  validation_split = 0.25
)
runtime.keras_crossentropy <-toc()

plot(track.keras_crossentropy)

# check predictions
pred.keras_crossentropy <- keras_crossentropy %>% predict(X_test)
# summarise results
predictions.keras_crossentropy <- max.col(pred.keras_crossentropy)
# create a contingency table
tab.keras_crossentropy <- table(predictions.keras_crossentropy, actual)
tab.keras_crossentropy
# calculate accuracy 
mean(predictions.keras_crossentropy == actual)

# save model
export_savedmodel(keras_crossentropy, "savedmodel")

