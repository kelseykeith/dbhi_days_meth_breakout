
# Process Bisulfite Sequencing (BS-Seq) Data

Bismark documentation <https://felixkrueger.github.io/Bismark/quick_reference/>

## Step 0: If necessary, create a Bismark index for your genome

```bash
bismark_genome_preparation /path/to/folder/with/genome/fasta
```

## Step 1: Check Quality with FastQC

```bash
# run FastQC and output to the fastqc/ directory
fastqc *.fq.gz -o fastqc/
```
## Step 2: Trim

```bash
# make a directory to put the trimmed data in
mkdir ../01_trim

# trim the bisulfite data; use the --rrbs flag if you have reduced representation data, included in the example below
[kkeith]$ for i in *1.fq.gz; do trim_galore --rrbs --paired --fastqc -q 30 --illumina --output ../01_trim $i ${i/1.fq.gz/2.fq.gz}; done
```

## Step 3: Align

```bash
# from the RRBS data directory
# switch to the trim directory and make a new directory for the aligned files
cd ../01_trim/
mkdir ../02_align
# align with bismark using a modifed bowtie2
for i in *1_val_1.fq.gz; do bismark --bowtie2 /path/to/bismark/index --output ../02_align -1 $i -2 ${i/1_val_1.fq.gz/2_val_2.fq.gz}; done
```

## Step 4: Extract Methylation

```bash
# from trim directory
# switch to the align directory and make a new directory for the extracted files
cd ../02_align/
mkdir ../03_extract_meth
# extract methylation counts while simultaneously removing large intermediate files
for i in *.bam; do bismark_methylation_extractor --paired-end --include_overlap --bedGraph --output ../03_extract_meth $i; rm -f ../03_extract_meth/CHG_OB_${i/.bam/.txt} ../03_extract_meth/CHG_OT_${i/.bam/.txt} ../03_extract_meth/CHH_OB_${i/.bam/.txt} ../03_extract_meth/CHH_OT_${i/.bam/.txt} ../03_extract_meth/CpG_OB_${i/.bam/.txt} ../03_extract_meth/CpG_OT_${i/.bam/.txt}; done
```













