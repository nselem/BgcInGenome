# Given a BGC and a sorted MiBiG fasta file 
# getSeq obtain the aminoacid sequence  at the begining and the end of the BGC
# input BGC_Id (E.g.BGC0000431) 
# output BGC_Id.i BGC_Id.f (E.g. BGC0000431.i, BGC0000431.f)

# bash getSeq.sh BGC0000431
#
# $1 BGCId 
# $2 MiBiG fasta db (default mibig_prot_seqs_2.0.fasta)
# $3 MiBig metadata including in third column genome Id if exist (antibiotics-metadata.tsv)
# $4 File with Rast Ids (Rast-ids.tsv)
# $5 Sliding Window size
# $6 Number of windows
# $7 Functional regexp to search
#
#echo BGC $1
#echo  MiBiG fasta file $2
#identificar que genoma es y obtener queries para el blast
#echo grep -a1 $1 mibig_prot_seqs_2.0.fasta.txt | head -n3 |tail -n2 > $1\.i 
grep -a1 $1 $2 | head -n3 |tail -n2 > $1\.i 
#echo grep -a1 $1 mibig_prot_seqs_2.0.fasta.txt | tail -n2  >$1\.f
grep -a1 $1 $2 | tail -n2  >$1\.f

#identificar que genoma es
genome=$(grep $1 $3 |cut -f3-4 | sed -e 's/^[ \t]*//' )
#echo genome $genome
# exit
file=$(grep $genome $4 |cut -f1)
#hacer blast en ese archivo, y obtener gwen id
echo BGC $1 genome $genome file $file
#exit

#identificar el geni, genf y BGC
#echo geni=blastp -db $file\.faa.db -query $1\.i -outfmt 7 -evalue 0.001 -num_threads 12 -max_target_seqs 1  
geni=$(blastp -db GENOMES/$file\.faa.db -query $1\.i -outfmt 7 -evalue 0.001 -num_threads 12 -max_target_seqs 1  |grep fig |cut -f 2|sed -e 's/fig|//')
#echo genf=$(blastp -db $file\.faa.db -query $1\.f -outfmt 7 -evalue 0.001 -num_threads 12 -max_target_seqs 1  |grep fig |cut -f 2| sed -e 's/fig|//')
genf=$(blastp -db GENOMES/$file\.faa.db -query $1\.f -outfmt 7 -evalue 0.001 -num_threads 12 -max_target_seqs 1  |grep fig |cut -f 2| sed -e 's/fig|//')

#echo initial gene $geni  border gene $genf

if [ -z "$geni" ]
then
      geni=$genf
fi

if [ -z "$genf" ]
then
      genf=$geni
fi


#echo initial gene $geni border gene $genf

#exit
numi=$(echo $geni|sed -e 's/[0-9]*\.[0-9]*\.peg\.//')
numf=$(echo $genf|sed -e 's/[0-9]*\.[0-9]*\.peg\.//')

#echo $numi
#echo $numf

#contigi=$(grep 422$'\t' $file\.txt |cut -f1)
#echo $contigi
#contigi=$(grep $geni$'\t' $file\.txt |cut -f1)
#contigf=$(grep $genf$'\t' $file\.txt|cut -f1)

#echo contig $contigi $contigf
#echo numero $numi $numf

echo src/getTrans.pl $numi $numf $file $1 $5 $6 $7
perl src/getTrans.pl $numi $numf $file $1 $5 $6 $7

# buscar anotaciones, if tranporter inside 0
# if +-5 5 until +-50 and same contig
