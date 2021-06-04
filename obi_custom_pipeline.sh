#!/bin/bash

fq_r1=$1
fq_r2=$2
sample=$3

if [ -z "$fq_r1"];
  then
    echo "You forgot to add Sample read 1!!!"
    exit 1;
fi

if [ -z "$fq_r2"];
  then
    echo "You forgot to add Sample read 2!!!"
    exit 1;
fi

if [ -z "$sample" ];
  then
    echo "You forgot to add Sample Name!!!"
    exit;
fi

rm -r $sample.obidms

echo "Finished importing $sample"

#To import reads
echo "Import read 1 of $sample"
obi import --fastq-input $fq_r1 $sample/reads1

echo "Import read 2 of $sample"
obi import --fastq-input $fq_r2 $sample/reads2

##To import ngfilter
echo "Import read 1 of $sample"
obi import --ngsfilter geans_ngsfile.txt $sample/ngsfile

obi alignpairedend -R $sample/reads2 $sample/reads1 $sample/aligned_reads

#Remove unaligned sequences
obi grep -a mode:alignment $sample/aligned_reads $sample/good_sequences

#Identify and annotate the sequences using the ngs file.
obi ngsfilter -t $sample/ngsfile -u $sample/unidentified_sequences --no-tags $sample/good_sequences $sample/identified_sequences

#Export the file

obi export $sample/identified_sequences -o identified_seqs/$sample\_identified.fq

#Add sample tag;
./add_sample_name_to_fq.pl identified_seqs/$sample\_identified.fq $sample > identified_seqs/$sample\_sample.fq

obi import --fastq-input identified_seqs/$sample\_sample.fq $sample/sample_sequences

#Dereplicate the sequences and provide a count tag with the number of sequences
obi uniq $sample/identified_sequences $sample/dereplicated_sequences

#Keep only the count and merged sample tags
obi annotate -k COUNT -k sample $sample/dereplicated_sequences $sample/cleaned_metadata_sequences

#Grep files that are longer than 100
obi grep -p "len(sequence)>=100" $sample/cleaned_metadata_sequences $sample/denoised_sequences
