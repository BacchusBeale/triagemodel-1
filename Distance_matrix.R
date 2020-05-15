# Create a dissimilarity matrix #
library(cluster)
# use scale()  to normalise by columns - exclude classifier column 
Numeric_initial_scaled <- as.data.frame(apply(Numeric_data_initial, 2, 
                  function(x) (scale(x, center = TRUE, scale = TRUE))))
Gower.distance <- daisy(Numeric_initial_scaled, metric = c("gower")) 
# convert Dist to a matrix
Dist <- as.matrix(Gower.distance)
# Visualise Dissimilarity matrix #
Dist_melt <- melt(Dist)
g2 <- ggplot(data = Dist_melt, aes(x=Var1, y=Var2, fill=value)) + 
geom_raster() + theme_bw()+ theme(axis.title = element_blank()) + 
theme(text=element_text(size=8))  + theme(legend.position = "none") +
scale_fill_gradientn(colours = terrain.colors(100))
# Output plots
g2

#grid.arrange(g1, g2, nrow=1, ncol=2)