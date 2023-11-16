#!/usr/bin/env bash

# make sure to run this script from within the directory where it is stored!

# move to the directory containing aligned and sorted bam files
cd ../results/bwa

# create a directory to store the results and store the path as a variable
output_dir="../../results/picard"
mkdir -p ${output_dir}

# loop through read pairs and map them using bwa
for bam in *.bam
do
    sample_name=$(basename ${bam} .bam)

	picard MarkDuplicates \
	-REMOVE_DUPLICATES true \
	-I ${sample_name}.bam \
	-O ${output_dir}/${sample_name}.removeddups.bam \
	-M ${output_dir}/${sample_name}.markeddups_metrics.txt

	samtools index ${output_dir}/${sample_name}.removeddups.bam
	samtools flagstat -@ 4 ${output_dir}/${sample_name}.removeddups.bam > ${output_dir}/${sample_name}.removeddups.flagstat 
done
