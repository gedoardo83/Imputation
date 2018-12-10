# create progress files (delete if present)
rm progress
echo "analysis started" >> progress
date >> progress
# detect duplicates 
plink --bfile Input_imputation.temp --list-duplicate-vars
plink --bfile Input_imputation.temp --exclude plink.dupvar --make-bed --out binary_temp
echo "duplicates removed" >> progress
date >> progress

# filter by chromosome plink files
for i in `seq 1 22`;
        do
        plink --bfile binary_temp --chr $i --make-bed --out input.chr$i &
        done
wait

# identify alignment issues with SHAPEIT (strand and missing values) (assume that in-house data are aligned to + strand)
for i in `seq 1 22`;
        do
        shapeit -check -B input.chr$i -M /data0/DATA/impute2.1Kgenome/ALL_1000G_phase1integrated_v3_impute/genetic_map_chr$i\_combined_b37.txt --input-ref /data0/DATA/impute2.1Kgenome/ALL_1000G_phase1integrated_v3_impute/ALL_1000G_phase1integrated_v3_chr$i\_impute.hap.gz /data0/DATA/impute2.1Kgenome/ALL_1000G_phase1integrated_v3_impute/ALL_1000G_phase1integrated_v3_chr$i\_impute.legend.gz /data0/DATA/impute2.1Kgenome/ALL_1000G_phase1integrated_v3_impute/ALL_1000G_phase1integrated_v3.sample --output-log chr$i\.alignment &
        done
wait

# prephase with SHAPEIT (excluding problematic positions)
for i in `seq 1 22`;
        do
        shapeit -B input.chr$i -M /data0/DATA/impute2.1Kgenome/ALL_1000G_phase1integrated_v3_impute/genetic_map_chr$i\_combined_b37.txt -R /data0/DATA/impute2.1Kgenome/ALL_1000G_phase1integrated_v3_impute/ALL_1000G_phase1integrated_v3_chr$i\_impute.hap.gz /data0/DATA/impute2.1Kgenome/ALL_1000G_phase1integrated_v3_impute/ALL_1000G_phase1integrated_v3_chr$i\_impute.legend.gz /data0/DATA/impute2.1Kgenome/ALL_1000G_phase1integrated_v3_impute/ALL_1000G_phase1integrated_v3.sample -O chr$i\.phased --exclude-snp chr$i\.alignment.snp.strand.exclude &
        done

wait

# remove temporary files
#rm shape*
#rm input*
