phenos <- read.table("Tratti_personalita.csv", header=T, as.is=T)
PCA <- read.table("../../../Genotypes/imputed_genotypes/AFFY_NEW/AFFY_NEW.Imputed.filtered.pca.eigenvec", header=T, as.is=T)
mydf <- merge(phenos, PCA[,2:22], by="IID")

factors <- paste0("PC", seq(1,20,1))
formula <- paste0("NS1 ~ ", paste(factors, collapse="+"))
results <- as.data.frame(summary(lm(formula=formula, data=mydf))$coefficients[,4])
colnames(results)[ncol(results)] <- "NS1_Pval"

for (n in colnames(mydf)[7:36]) {
  formula <- paste0(n," ~ ", paste(factors, collapse="+"))
  temp_df <- as.data.frame(summary(lm(formula=formula, data=mydf))$coefficients[,4])
  colnames(temp_df)[ncol(temp_df)] <- paste0(n,"_Pval")
  results <- cbind(results,temp_df)
}

results <- results[-1,]
sig_PCs <- names(apply(results,1,function(x) sum(x<0.05)))[apply(results,1,function(x) sum(x<0.05)) > 0]
covars_tab <- mydf[,c(2,1,3,4,which(colnames(mydf) %in% sig_PCs))]
