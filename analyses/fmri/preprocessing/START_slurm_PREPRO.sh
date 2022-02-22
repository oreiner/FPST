#!/bin/bash
# run beforehand: chmod 775 *.sh
# run slurm: ./slurm_loop.sh
# shopt -s -o errexit errtrace

mkdir slogs

array1=(`awk '{print $1}' ../../subjects_n24.m`)
#array1=(2262)

for ((s=0; s<${#array1[@]}; s++)); do
    sub=${array1[s]}

    # preprocessing
    job1=$(sbatch --parsable -J prep$sub -o slogs/a_prepI_$sub.log a_prepImg_sbatch.sh $sub)  
    job2=$(sbatch --parsable --dependency=afterok:$job1 -J topu$sub -o slogs/b_topup_$sub.log b_topup_sbatch.sh $sub)
    job3=$(sbatch --parsable --dependency=afterok:$job2 -J ppro$sub -o slogs/c_pproc_$sub.log c_prepro_sbatch.sh $sub)
    # confound regression
    job4=$(sbatch --parsable --dependency=afterok:$job2 -J dvar$sub -o slogs/d_dvars_$sub.log dvars/dvars_sbatch.sh $sub)
    job5=$(sbatch --parsable --dependency=afterok:$job3 -J WMCS$sub -o slogs/e_WMCS_$sub.log WM_CSF/sbatch.sh $sub)
    job6=$(sbatch --parsable --dependency=afterok:$job4:$job5 -J multi$sub -o slogs/f_multireg_$sub.log multi_reg/sbatch.sh $sub)

done
