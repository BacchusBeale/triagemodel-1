#### PCA ####
# identify numeric columns
Numeric_data <- data %>% select_if(is.numeric)
PCA_Predictors <- Numeric_data # (all numeric columns)
PCA_class <- data[,2] # Class labels (Triage Category)

# impute missing values with mean
impute_mean <- function(x) replace(x, is.na(x), mean(x, na.rm = TRUE))
PCA_Predictors[] <- lapply(PCA_Predictors, impute_mean)

# Find principal components and the proportion of variance explained
# Use prcomp() for PCA
PCA_Triage <- prcomp(PCA_Predictors, scale = TRUE)

prin_comp <- prcomp(PCA_Predictors, scale = TRUE)

# Print proportion of variance explained for each PC
(PVE <- (PCA_Triage$sdev^2)/sum(PCA_Triage$sdev^2))

# Show proportion of variance explained for first 10 PC
sum(prop_varex[1:33])

# Show proportion of variance explained for first 8 PC
sum(prop_varex[1:8])

# look at PCA vectors
PCA_Triage$rotation

#compute standard deviation of each principal component
std_dev <- prin_comp$sdev

#compute variance
pr_var <- std_dev^2

#proportion of variance explained
prop_varex <- pr_var/sum(pr_var)

#scree plot
plot(prop_varex, xlab = "Principal Component",
     ylab = "Proportion of Variance Explained",
     type = "b")

#cumulative scree plot
plot(cumsum(prop_varex), xlab = "Principal Component",
     ylab = "Cumulative Proportion of Variance Explained",
     type = "b")


prop_varex

