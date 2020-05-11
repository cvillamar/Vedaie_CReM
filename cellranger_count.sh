#!/bin/zsh

project_name="20_01_14_marally"
BASE="/restricted/projectnb/crem-bioinfo"
PW=$BASE/project_workspace/${project_name}
script_name="cellranger_count"

num_cores=8
localmem=128 # 16 cores * 6G = 96G is the minimum RAM recommendation (6G per core). Min cores: 8
GENOME_DIR=$BASE/reference_data/REFERENCES/GRCh38_tdtomato_GFP_10X/GRCh38_tdtomato_GFP_10X
output_dir=$PW/calculations/$script_name
input_dir=/restricted/projectnb/crem-bioinfo/project_workspace/20_01_14_leon/calculations/H2HYGBGXF/outs/fastq_path/H2HYGBGXF  

## Run cellranger

for sample_dir in ${input_dir}/MV-* ; do
  # Set up housekeeping variables
  output_prefix=`basename ${sample_dir}`  # get Lung from /restricted/projectnb/crem-bioinfo/project_workspace/18_09_27_rock/calculations/H52KCAFXY/outs/fastq_path/H52KCAFXY/Lung 
  name=${output_prefix}
  group="crem-seq"
  scripts_dir=$PW/qsub_scripts/$script_name
  script=$scripts_dir/${name}.qsub
  log_dir=$PW/logs/$script_name
  log=$log_dir/${name}.log
  err=$log_dir/${name}.err
  mkdir -p $scripts_dir $log_dir $output_dir
  echo > $log > $err # reset, because otherwise it appends
  
  
  # Create the script
  echo '#!/bin/zsh
module load bcl2fastq/2.20
module load cellranger/3.0.2
date
cd '$output_dir'
time cellranger count \
  --id='$output_prefix' \
  --transcriptome='$GENOME_DIR' \
  --fastqs='${sample_dir}' \
  --localcores='$num_cores' \
  --localmem='$localmem'
date
  ' > $script
  chmod +x $script

  # Submit
  qsub -P $group -N $name -o $log -e $err -V \
    -pe omp $num_cores \
    -l mem_total="${localmem}G" \
    $script
done

