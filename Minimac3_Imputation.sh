#convert phased input genotypes (obtained with SHAPEIT) into vcf
for i in `seq 1 22`;
        do
        shapeit -convert --input-haps chr$i\.phased --output-vcf chr$i\.phased.vcf &
        done
wait

# impute
for i in `seq 1 22`;
        do
        Minimac3 --refHaps /data0/DATA/Minimac3_reference/$i\.1000g.Phase3.v5.With.Parameter.Estimates.m3vcf.gz --haps chr$i\.phased.vcf --prefix chr$i\.imputed &
        done
wait
~            
