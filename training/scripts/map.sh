#!/usr/bin/env bash

##########################################################
# Script to map fastq files to reference genome with bwa #
##########################################################

# make sure to run this script from within the directory where it is stored!

# move to the directory containing the fastq files
cd ../data/fastq

# create a directory to store the results and store the path as a variable
output_dir="../../results/bwa"
mkdir -p ${output_dir}

# create a bwa index file
bwa index ../reference/PlasmoDB-65_Pfalciparum3D7_Genome.fasta

# loop through read pairs and map them using bwa
for read_1 in *_R1_001.fastq.gz
do
    sample_name=$(basename ${read_1} _R1_001.fastq.gz)

    bwa mem \
        ../reference/PlasmoDB-65_Pfalciparum3D7_Genome.fasta \
        ${read_1} \
        ${sample_name}_R2_001.fastq.gz \
        -t 4 \
        -k 30 \
        -R "@RG\tID:001\tSM:001\tPL:ILLUMINA" \
        | samtools sort -@ 4 -o ${output_dir}/${sample_name}.bam

    samtools flagstat -@ 4 ${output_dir}/${sample_name}.bam > ${output_dir}/${sample_name}.flagstat

done

