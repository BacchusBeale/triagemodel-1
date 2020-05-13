#### Correlations and distance ####
library(ggcorrplot)
library(cluster)
# Create a matrix of numeric variables
Numeric_data <- data %>% select_if(is.numeric)
# Check correlations
Triage.cor = cor(Numeric_data, method = "spearman", use = "pairwise.complete.obs")
# Create a correlation plot
par(mfrow=c(1,1))
g1 <- ggcorrplot(Triage.cor, type = "lower", insig = "blank", show.legend=T, tl.cex =7,
                  ggtheme = ggplot2::theme_bw(), colors = c("red","white","green")) +
  theme(text=element_text(size=7)) 
g1
# Create a dissimilarity matrix #
# use scale()  to normalise by columns - exclude classifier column 
#Numeric_scaled <- as.data.frame(apply(Numeric_data, 2, 
                                                 #function(x) (scale(x, center = TRUE, scale = TRUE))))
#Gower.distance <- daisy(Numeric_scaled, metric = c("gower")) 
# convert Dist to a matrix
#Dist <- as.matrix(Gower.distance)
# Visualise Dissimilarity matrix #
#Dist_melt <- melt(Dist)
#g2 <- ggplot(data = Dist_melt, aes(x=Var1, y=Var2, fill=value)) + 
#geom_raster() + theme_bw()+ theme(axis.title = element_blank()) + 
#theme(text=element_text(size=8))  + theme(legend.position = "none") +
# scale_fill_gradientn(colours = terrain.colors(100))
# Output plots
#grid.arrange(g1, g2, nrow=1, ncol=2)