# filter for R2>0.8
cat *info | tr -s " " | awk 'BEGIN{FS=" "}{if ($7<0.8) print $1}' > variants_low_quality_imputed.temp
plink --bfile merged --exclude variants_low_quality_imputed.temp --make-bed --out merged_filtered
