## plink QC filtering and conversion to chr:position code for different chip comparison
# QC for hwe and genotypes call
plink --bfile Input --hwe 1e-10 --geno --make-bed --out Input_imputation.temp
# SNV position code conversion
awk 'BEGIN{FS="\t";OFS="\t"}{print $1,$1":"$4,$3=0,$4,$5,$6,$7}' Input_imputation.temp.bim > tempbim
rm Input_imputation.temp.bim
mv tempbim Input_imputation.temp.bim
