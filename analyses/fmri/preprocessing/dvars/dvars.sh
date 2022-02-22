#!/bin/bash

# this is just a test file

# Usage: sbatch script.sh $subj $sequence

SUBJECT=$1
SEQUENCE=$2

shopt -s -o errexit errtrace

# is FSL available?
command -v fslinfo 2>/dev/null \
  || { printf "Error: FSL commands not in PATH; exiting.\n" >&2; exit 1; }

OUTDIR=[Home Directory]/results/fmri/nii
TMPDIR=[Home Directory]/results/fmri/tmp
dir=${OUTDIR}/${SUBJECT}

# define the image
img=$dir/FPST_BOLD_${SEQUENCE}_${SUBJECT}_mcAP.nii.gz
imgFD=$dir/FPST_BOLD_${SEQUENCE}_${SUBJECT}.nii.gz

# define the matrix output
# calculate metrics for each volume, eg dvars or fd

# *dvars* = global measure of signal change (Power et al., 2011);
# the rate of change of BOLD signal across the entire brain at each frame of data;
# a measure of how much the intensity of a brain image changes 
# in comparison to the previous timepoint 
# (as opposed to the global signal, which is the average value of a brain image at a timepoint).

# *FD* = framewise displacement, summarizes 6 realignment parameters

# generate metrics
metric=$dir/moconf_metrics_dvars_${SEQUENCE}.txt
metricFD=$dir/moconf_metrics_fd_${SEQUENCE}.txt
# generate a confound matrix
matrix=$dir/moconf_matrix_dvars_${SEQUENCE}.txt
matrixFD=$dir/moconf_matrix_fd_${SEQUENCE}.txt

echo "motion_outliers dvars ${SUBJECT}"
# --nomoco only possible for dvars, not for fd
fsl_motion_outliers -i $img -o $matrix --dvars --nomoco -s $metric -t $TMPDIR -v
echo "motion_outliers fd ${SUBJECT}"
fsl_motion_outliers -i $imgFD -o $matrix --fd -s $metricFD -t $TMPDIR -v

echo END: `date`
