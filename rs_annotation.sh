# split bim file for chromosome
for i in `seq 1 22`;
        do 
	#echo $i
	awk -v i=$i 'BEGIN{FS="\t";OFS="\t"}{if($1==i) print $0}' Genotypes_after_imputation.bim > $i\.temp &
	done
wait

# match input rs bed dbsnp
for i in `seq 1 22`
	do
	cp /data0/DATA/dbSNP/bed_files/hg19/bed_chr_$i\.bed $i\.rs_temp &
	wait
	sed -i.bak 's/chr//g' $i\.rs_temp &
	done
wait


# match with Rscript
for i in `seq 1 22`;
        do
	Rscript --no-save rs_annotation.R $i\.temp $i\.rs_temp &
	done
wait

# concatenate new file
cat *new.bim | sort -k 1n -k 4n > Genotypes_after_imputation_rs.bim 

# remove unmatched variants
#awk 'BEGIN{FS="\t"}{print $1":"$4}' Genotypes_after_imputation.bim | sort -u > variants_total.temp
awk 'BEGIN{FS="\t"}{print $1":"$4}' Genotypes_after_imputation_rs.bim | sort -u > variants_found.temp
awk 'BEGIN{FS=":";OFS="\t"}{print $1,$2,$2,NR}' variants_found.temp > temp
plink --bfile Genotypes_after_imputation --extract range temp --allow-no-sex --make-bed --out temp_
#comm -12 variants_found.temp variants_total.temp > to_keep.temp
#plink --bfile Genotypes_after_imputation --extract to_keep.temp --allow-no-sex --make-bed --out temp_
mv temp_.fam Genotypes_after_imputation_rs.fam
mv temp_.bed Genotypes_after_imputation_rs.bed
rm temp_.bim
plink --bfile Genotypes_after_imputation_rs --mind 0.02 --geno 0.02 --hwe 1e-10  --maf 0.01 --make-bed --out Genotypes_after_imputation_rs2
rm Genotypes_after_imputation_rs.bim
rm Genotypes_after_imputation_rs.fam
rm Genotypes_after_imputation_rs.bed

mv Genotypes_after_imputation_rs2.bim Imputed.bim
mv Genotypes_after_imputation_rs2.bed Imputed.bed
mv Genotypes_after_imputation_rs2.fam Imputed.fam                                                                                                        

# clean directory
#rm *temp*
