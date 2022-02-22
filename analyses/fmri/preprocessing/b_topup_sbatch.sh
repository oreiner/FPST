#!/bin/bash

# Usage: sbatch script.sh $subj $sequence (learning or transfer)

SUBJECT=$1
SEQUENCE=$2

shopt -s -o errexit errtrace

# is FSL available?
command -v fslinfo 2>/dev/null \
  || { printf "Error: FSL commands not in PATH; exiting.\n" >&2; exit 1; }

OUTDIR=[Home Directory]/results/fmri/nii
TMPDIR=[Home Directory]/tmp
dir=${OUTDIR}/${SUBJECT}

# adapt to data set
pha_forw=$dir/*sms8_AP.nii.gz
pha_back=$dir/*sms8_PA.nii.gz
pha_all_base=$dir/topup_APPA
pha_all_topup=${pha_all_base}_topup
pha_acqp_txt=${pha_all_base}_acqp.txt

# safety check
[[ -d $dir ]] \
|| { printf "Error: input path $dir not found; exiting.\n" >&2; exit 1; }

# create merged phase volume
if [[ ! -f ${pha_all_base}.nii.gz ]]; then
fslmerge -t $pha_all_base $pha_forw $pha_back
fi

# create AP - first volume
if [[ ! -f first_volume_topup_APPA.nii.gz ]]; then
fslroi $pha_all_base $dir/first_volume_topup_APPA.nii.gz 0 1
fi

# motion correct and register to AP
echo "Motion correcting ${SUBJECT}"
if [[ ! -f FPST_BOLD_${SEQUENCE}_${SUBJECT}_mcAP ]]; then
mcflirt -in $dir/FPST_BOLD_${SEQUENCE}_${SUBJECT}.nii -reffile ${dir}/first_volume_topup_APPA.nii.gz -mats -plots -out $dir/FPST_BOLD_${SEQUENCE}_${SUBJECT}_mcAP
fi

main_base=$dir/FPST_BOLD_${SEQUENCE}_${SUBJECT}_mcAP
main_acqp_txt=${main_base}_acqp.txt

# cf. FSL topup/eddy manual FAQ
# total readout time:   (0.001 * echo_spacing_ms * epi_factor)
# OR :                  (0.001 * echo_spacing_ms * (epi_factor-1))
# P>>A: 0 1 0
# A>>P: 0 -1 0

# FPST_BOLD: (0.001 * 0.93 * (140-1)) = 0.12927

main_acqp="0 -1 0 0.12927"
pha_forw_acqp="0 -1 0 0.12927"
pha_back_acqp="0 1 0 0.12927"

main_numvol=$(fslinfo $main_base | grep '^dim4' | awk '{print $2}')
pha_forw_numvol=$(fslinfo $pha_forw | grep '^dim4' | awk '{print $2}')
pha_back_numvol=$(fslinfo $pha_back | grep '^dim4' | awk '{print $2}')

# create main acqp.txt
if [[ ! -f $main_acqp_txt ]]; then
printf -- "$main_acqp\n" >> $main_acqp_txt
fi

# create phase correction acqp.txt
if [[ ! -f $pha_acqp_txt ]]; then
for (( i=0; i<$pha_forw_numvol; i++ )); do
  printf -- "$pha_forw_acqp\n" >> $pha_acqp_txt
done
for (( i=0; i<$pha_back_numvol; i++ )); do
  printf -- "$pha_back_acqp\n" >> $pha_acqp_txt
done
fi

if [[ ! -f ${pha_all_topup}_unwarped ]]; then
    echo "topup ${SUBJECT}"
    [ -f ${pha_all_topup}_fieldcoef.nii.gz ] \
    || time topup \
    --imain=$pha_all_base \
    --datain=$pha_acqp_txt \
    --config=b02b0.cnf \
    --out=${pha_all_topup} \
    --fout=${pha_all_topup}_field \
    --iout=${pha_all_topup}_unwarped
fi

if [[ ! -f ${main_base}_unwarped ]]; then
    echo "applytopup ${SUBJECT}"
    # applytopup
    [ -f ${main_base}_unwarped.nii.gz ] \
    || time applytopup \
    --verbose \
    --imain=$main_base \
    --datain=$main_acqp_txt \
    --inindex=1 \
   --topup=${pha_all_topup} \
    --out=${main_base}_unwarped \
    --method=jac
fi