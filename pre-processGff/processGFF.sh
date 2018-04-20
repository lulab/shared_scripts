
#!/bin/bash

# Print help message if no parameter given
if [ "$#" == 0 ];then
echo "Usage: ./processGFF.sh input_dir output_dir
	1. separate specific biotypes 
	2. seperate 5' and 3' UTR
	3. define intergenic region
	4. clean gtf for cufflinks
	input: gencode.v19.annotation.gtf,gencode.v19.tRNAs.gtf,miRbase_hsa.gff3,gencode.v19.long_noncoding_RNAs.gtf et al 		
	output: output_dir/separate_gff  output_dir/merge_gff   output_dir/clean_gtf/  
"
exit;
fi
## input_dir=/data1/users1/chaodi/ncRNA/human/gff/Gencode19/Input
input_dir=$1
## specify your own output dir
output_dir=$2
gtf=$input_dir/gencode.v19.annotation.gtf
[[ -d $output_dir/separate_gff ]] || mkdir $output_dir/separate_gff

## look at genomic element types
sed '1,5d' $gtf | awk -F "\t" 'split($9,a,"; "){print $2"\t"$3"\t"a[6]}' | sort |uniq -c > $output_dir/feature+trtype
sed '1,5d' $gtf | awk -F "\t" 'split($9,a,"; "){print $2"\t"$3"\t"a[3]}' | sort |uniq -c > $output_dir/feature+genetype

######## 1. separate whole gtf file to gffs for each biotype ##########
### notice that "gencode.v10.annotation_updated_ncrna_host.gtf" do not include: tRNA, TE, and ancestral repeats, miRNA should get from mirBase
## tRNA in "gencode.v19.tRNAs.gtf", TE generated from RepeatMasker.txt(UCSC), ancestral repeats from hg19 multiple alingnments(maf file), use John's script
## all CDS(including cCDS)
awk '$3=="CDS"{print}'  $gtf  | grep  "transcript_type \"protein_coding\"" > $output_dir/separate_gff/CDS.gff 
## level1+2 CDS only in protein_coding as gold-standard
grep "level 1\|level 2" $output_dir/separate_gff/CDS.gff > $output_dir/separate_gff/CDS_gold.gff

## all UTR
awk '$3=="UTR"{print}'  $gtf  | grep  "transcript_type \"protein_coding\""  > $output_dir/separate_gff/UTR.gff 

####### ncRNA1 type: 7 types  ######
## rRNA(gene=transcript=exon)
grep "transcript_type \"rRNA\""  $gtf  | awk '$3=="transcript"{print}'|awk 'BEGIN{FS=OFS="\t"} $3="rRNA"{print}' > $output_dir/separate_gff/rRNA.gff 
## snoRNA(gene=transcript=exon)
grep "transcript_type \"snoRNA\""  $gtf  | awk '$3=="transcript"{print}'|awk 'BEGIN{FS=OFS="\t"} $3="snoRNA"{print}' > $output_dir/separate_gff/snoRNA.gff 
## snRNA(gene=transcript=exon)
grep "transcript_type \"snRNA\""  $gtf  | awk '$3=="transcript"{print}' |awk 'BEGIN{FS=OFS="\t"} $3="snRNA"{print}'> $output_dir/separate_gff/snRNA.gff 
## miRNA from mirBase
grep miRNA_primary_transcript $input_dir/miRbase_hsa.gff3 | sed 1d |awk 'BEGIN{FS=OFS="\t"} $2="miRBase"{print}'> $output_dir/separate_gff/miRNA.gff
## tRNA from tRNA genecode
sed '1,5d' $input_dir/gencode.v19.tRNAs.gtf |awk 'BEGIN{FS=OFS="\t"} $3="tRNA"{print}'> $output_dir/separate_gff/tRNA.gff
## Y_RNA and 7SK from miscRNA(gene=transcript=exon)
grep "transcript_type \"misc_RNA\""   $gtf  | awk '$3=="transcript"{print}' | grep Y_RNA |awk 'BEGIN{FS=OFS="\t"} $3="Y_RNA"{print}'> $output_dir/separate_gff/Y_RNA.gff
grep "transcript_type \"misc_RNA\""  $gtf | awk '$3=="transcript"{print}' | grep 7SK  |awk 'BEGIN{FS=OFS="\t"} $3="7SK_RNA"{print}'> $output_dir/separate_gff/7SK_RNA.gff
## combine
cd $output_dir/separate_gff/
cat rRNA.gff snoRNA.gff snRNA.gff miRNA.gff tRNA.gff Y_RNA.gff 7SK_RNA.gff > canonical_ncRNA.gff
cd ../../

##### level1+level2 lncRNAs, exclude overlapped with ncRNA1 as gold-standard lncRNA#####
## all lncRNA(transcript)
awk '$3=="transcript"{print}' $input_dir/gencode.v19.long_noncoding_RNAs.gtf > $output_dir/separate_gff/lncRNA.gff
grep "transcript_type \"lincRNA\"" $input_dir/gencode.v19.long_noncoding_RNAs.gtf | awk '$3=="transcript"{print}' > $output_dir/separate_gff/lincRNA.gff
intersectBed -a $output_dir/separate_gff/lncRNA.gff -b $output_dir/separate_gff/canonical_ncRNA.gff -v | grep "level 1\|level 2"  > Output/separate_gff/lncRNA_gold.gff

### many kind of pseudogenes: CDS/UTR "polymorphic_pseudogene";"TR_J_pseudogene" ;"Mt_tRNA_pseudogene"
grep pseudogene $gtf | awk '$3=="transcript"{print}' > $output_dir/separate_gff/pseudogene.gff
## TE from reapmaskter of UCSC, class:LTR,SINE,LINE,DNA as transposable element	
awk '$6=="LTR"||$6=="SINE"||$6=="LINE"||$6=="DNA"{print}' $input_dir/RepeatMasker.bed | awk '{print $1"\thg19_rmsk\tTE\t"$2"\t"$3"\t.\t"$4"\t.\trepName="$5"; repClass="$6"; repFamily="$7";"}' | awk '$1!~/_/{print}' > $output_dir/separate_gff/TE.gff
## genes and transcripts (all types)
awk '$3=="gene"{print}'  $gtf > $output_dir/separate_gff/gene.gff
awk '$3=="exon"{print}'  $gtf > $output_dir/separate_gff/exon.gff
awk '$3=="transcript"{print}'  $gtf > $output_dir/separate_gff/transcript.gff
cd $output_dir/separate_gff/
# mRNA
grep "transcript_type \"protein_coding\"" transcript.gff > mRNA.gff
## exon (coding)
grep "transcript_type \"protein_coding\"" exon.gff > coding_exon.gff
## introns(coding)
sort -k1,1 -k12,12 -k4,4n coding_exon.gff >foo 
mv foo coding_exon.gff
python ../../bin/makeIntron.py coding_exon.gff coding_intron.gff
echo -e "separate gff done! \n"

##### merge for genic region and then get intergeic region 
cat gene.gff TE.gff | sort -k1,1 -k4,4n | mergeBed > merged_genic.bed

### get intergenic region
 
bedtools slop -i merged_genic.bed -b 2000 -g $input_dir/hg19.genome |  mergeBed > genic+2000_merge.bed
## download 
complementBed -i genic+2000_merge.bed -g $input_dir/hg19.genome > intergenic.bed
awk '{print $0"\tintergenic"}' intergenic.bed > foo
mv foo intergenic.bed
cd ../../

echo -e "get intergenic reigon done! \n"


########### 3. seperate UTR to 5' and 3', output: sepUTR.bed ########
## only transcripts type=="protein_coding", the UTR counts, not gene type="protein_coding"(some protein coding gene have "nonsense_mediated_decay" transcripts)
mkdir $output_dir/separate_gff/sepUTR/
cd $output_dir/separate_gff/sepUTR
Rscript ../../../bin/specify5-3UTR.R $gtf sepUTR.bed
python ../../../bin/specify5-3UTR.py sepUTR.bed ../UTR.gff  > sepUTR.gff 
awk '$3=="5UTR"{print}' sepUTR.gff > 5UTR.gff
awk '$3=="3UTR"{print}' sepUTR.gff > 3UTR.gff 
cd ../../../

echo -e "separate UTR done! \n"

###### 4.clean gtf for use of cufflinks  ############
mkdir -p $output_dir/clean_gtf
for i in rRNA snRNA snoRNA misc_RNA miRNA Mt_rRNA Mt_tRNA lincRNA non_coding sense_intronic sense_overlapping antisense 3prime_overlapping_ncrna; do
grep "gene_type \"$i\"" $gtf > $output_dir/clean_gtf/$i.gtf
done
grep "gene_type \"protein_coding\"" $gtf | grep -v Selenocysteine > $output_dir/clean_gtf/protein_coding.gtf
grep "IG_[CDJV]\|TR_[CDJV]" $gtf > $output_dir/clean_gtf/IG_TR.gtf
cp $output_dir/separate_gff/tRNA.gff $output_dir/clean_gtf/tRNA.gtf
cp $output_dir/separate_gff/pseudogene.gff $output_dir/clean_gtf/pseudogene.gtf
cd $output_dir/clean_gtf/
cat antisense.gtf non_coding.gtf sense_intronic.gtf sense_overlapping.gtf 3prime_overlapping_ncrna.gtf > otherType_ncRNA.gtf
cat rRNA.gtf snRNA.gtf snoRNA.gtf misc_RNA.gtf miRNA.gtf Mt_rRNA.gtf Mt_tRNA.gtf lincRNA.gtf non_coding.gtf  sense_intronic.gtf sense_overlapping.gtf antisense.gtf 3prime_overlapping_ncrna.gtf tRNA.gtf otherType_ncRNA.gtf > known_ncRNA.gtf
cat protein_coding.gtf pseudogene.gtf known_ncRNA.gtf |awk '$3!~/^gene/ && $3!~/^transcript/{print}'  > gencode19.lite.gtf
cd ../../

echo "clean gtf in Output/clean_gtf done!"





