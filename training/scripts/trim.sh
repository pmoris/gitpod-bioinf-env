#!/usr/bin/env bash

################################################
# Script to trim fastq files using trimmomatic #
################################################

# make sure to run this script from within the directory where it is stored!

# move to directory containing fastq files
# in many situations, using an absolute path would be safer than a relative one
# but since we are using gitpod, this will have to do
cd ../data/fastq

# create a directory to store the results and store the path as a variable
trim_output_dir="../../results/trimmomatic"
mkdir -p ${trim_output_dir}

# loop through the read pairs and trim them
for read_1 in *_R1_001.fastq.gz
do
    sample_name=$(basename ${read_1} _R1_001.fastq.gz)

    trimmomatic PE \
                -phred33 \
                -trimlog ${trim_output_dir}/${sample_name}_trimreport.txt \
                ${read_1} ${sample_name}_R2_001.fastq.gz \
                ${trim_output_dir}/${sample_name}_R1_001.trim.fastq.gz ${trim_output_dir}/${sample_name}_R1_001.trim.unpaired.fastq.gz \
                ${trim_output_dir}/${sample_name}_R2_001.trim.fastq.gz ${trim_output_dir}/${sample_name}_R2_001.trim.unpaired.fastq.gz \
                ILLUMINACLIP:${CONDA_PREFIX}/share/trimmomatic/adapters/NexteraPE-PE.fa:2:30:10 \
                LEADING:3 TRAILING:3 \
                SLIDINGWINDOW:4:15 \
                MINLEN:36
done
