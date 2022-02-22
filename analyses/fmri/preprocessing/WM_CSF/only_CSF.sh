#!/usr/bin/env bash

SUBJECT=$1
SEQUENCE=$2
kernelWM=9
kernelCS=2 

anatdir=[Home Directory]/results/fmri/nii/${SUBJECT}/anatomy
bolddir=[Home Directory]/results/fmri/nii/${SUBJECT}/
maskdir=[Home Directory]/analyses/fmri/preprocessing/WM_CSF/mask
#wmIMG=$anatdir/wc2tANAT*.nii
csIMG=$anatdir/wc3tANAT*.nii
fIMG=$bolddir/wFPST_BOLD_${SEQUENCE}_${SUBJECT}_mcAP_unwarped

# venticle and cerebral masks
# beforehead: coregister masks to wc1/3 with SPM to obtain same image properties
ventri_mask=$maskdir/rwc3_ALVIN_bin_ero
#cerebr_mask=$maskdir/rwc1_cerebral_mask2bin

# generate binary masks of WM and CSF segments
#fsl5.0-fslmaths $wmIMG -thr 0.5 -bin $anatdir/wmMASK
fsl5.0-fslmaths $csIMG -thr 0.5 -bin $anatdir/csMASK

# overlay wm/csMASKs and the cerebral/ventricular masks
echo "masking by BRAIN for subject $SUBJECT"
#fsl5.0-fslmaths $anatdir/wmMASK -mas $cerebr_mask $anatdir/wmMASK_BRAIN
fsl5.0-fslmaths $anatdir/csMASK -mas $ventri_mask $anatdir/csMASK_BRAIN

# erode wm/csMASKs
echo "eroding WM/CSF for subject $SUBJECT"
#fsl5.0-fslmaths $anatdir/wmMASK_BRAIN -kernel sphere $kernelWM -ero $anatdir/wmMASK_BRAIN-${kernelWM}
fsl5.0-fslmaths $anatdir/csMASK_BRAIN -kernel sphere $kernelCS -ero $anatdir/csMASK_BRAIN-${kernelCS}

# save average timeseries to a text file
# the average is taken over all voxels in the mask
echo "averaging timeseries for subject $SUBJECT"
#fsl5.0-fslmeants -i $fIMG -o $bolddir/means_wm.txt -m $anatdir/wmMASK_BRAIN-${kernelWM}
fsl5.0-fslmeants -i $fIMG -o $bolddir/means_cs.txt -m $anatdir/csMASK_BRAIN-${kernelCS}

echo "done"
