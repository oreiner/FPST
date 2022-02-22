#!/usr/bin/env bash

#SBATCH --mail-type=END
#SBATCH -n 1 # 1 per CPU
#SBATCH -c 10 # number of cpus per task
#SBATCH --mail-user=bkuzmanovic@sf.mpg.de

echo "working directory = "$SLURM_SUBMIT_DIR
if [[ -d $SLURM_SUBMIT_DIR ]]; then
	cd $SLURM_SUBMIT_DIR
fi

export OMP_NUM_THREADS=10
sub=$1

##################################################################
cd ~
srun /beegfs/bin/matlab_2014b -nodesktop -nodisplay -nosplash \
-r "spm_get_defaults('cmdline',true);tmp=spm_platform('tempdir');\
fprintf(['tmp=' tmp '\n']);cd $SLURM_SUBMIT_DIR;\
try, cd preprocessing, catch, end;\
c_prepro('${sub}')",quit

# if spm not found add:
# addpath(genpath('/beegfs/v1/share/opt/spm12'));