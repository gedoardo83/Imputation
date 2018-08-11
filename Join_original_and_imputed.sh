# filter out genotyped SNP from imputed dataset
cat *info | grep -i genotyped | cut -f 1 > variants_to_remove.temp
plink --bfile merged_filtered --exclude variants_to_remove.temp --make-bed --out only_imputed.temp
# set family ID to 0 in both the initial dataset and the imputed dataset to avoid id matching issue (not sample related)
awk 'BEGIN{FS=" "}{$1=0; print $0}' only_imputed.temp.fam > only_imputed.temp.fam2
rm only_imputed.temp.fam
mv only_imputed.temp.fam2 only_imputed.temp.fam

awk 'BEGIN{FS=" "}{$1=0; print $0}' Input.fam  > Input.fam2
rm Input.fam
mv Input.fam2 Input.fam 


# try to merge detecting non-biallelic variant in imputed dataset
plink --bfile Input --bmerge only_imputed.temp --allow-no-sex
plink --bfile only_imputed.temp --exclude plink.missnp  --make-bed --out to_merge --allow-no-sex
plink --bfile to_merge --bmerge Input --make-bed --out Genotypes_after_imputation --allow-no-sex
plink --bfile Input --exclude Genotypes_after_imputation-merge.missnp --make-bed --out to_merge1 --allow-no-sex
plink --bfile to_merge1 --bmerge to_merge --make-bed --out Genotypes_after_imputation --allow-no-sex
