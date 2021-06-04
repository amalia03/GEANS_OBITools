#!/bin/bash

query=$1
db="/location/to/database"
outfile=$2

blastn -db $db -task blastn -query $query -out $outfile -evalue 1E-30 \
       -outfmt '6 qseqid sseqid stitle qlen slen qstart qend sstart send evalue score lengt pident nident gapopen gaps qcovs' \
       -num_threads 10 -max_target_seqs 10 -perc_identity 97
