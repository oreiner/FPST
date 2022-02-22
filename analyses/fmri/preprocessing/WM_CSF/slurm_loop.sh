#!/bin/bash
# run beforehand: chmod 775 *.sh
# run slurm: ./slurm_loop.sh

mkdir slogs

array1=(`awk '{print $1}' ../../../subjects_n24.m`)
#array1=(1234 5678)

for ((s=0; s<${#array1[@]}; s++)); do
  sub=${array1[s]}

  sbatch -J WMCS$sub -o slogs/WMCS_$sub.log sbatch.sh $sub

done