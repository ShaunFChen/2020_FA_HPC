library(ggplot2)

eigenvec_fp <- commandArgs()[3]
pop_fp <- commandArgs()[4]

df <- read.csv(eigenvec_fp, sep = ' ', header = 0)
pop <- read.csv(pop_fp, sep = '\t')
df_ <- merge(df, pop, by.x = 'V1', by.y = 'IID')

png("figure_tgp_pca.png", width = 6, height = 6, units = "in", res = 300)

print({
    ggplot(df_, aes(x = V3, y = V4, color = sup_pop)) + geom_point(size = 1, alpha = 0.5) + xlab("PC1") + ylab("PC2")
})
                    
dev.off()