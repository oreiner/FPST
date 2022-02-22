#!/usr/bin/env bash

SUBJECT=$1
SEQUENCE=$2
kernelWM=9
kernelWM_test=6
kernelCS=2 

anatdir=[Home Directory]/results/fmri/nii/${SUBJECT}/anatomy
bolddir=[Home Directory]/results/fmri/nii/${SUBJECT}
maskdir=[Home Directory]/analyses/fmri/preprocessing/WM_CSF/mask
wmIMG=$anatdir/wc2tANAT*.nii
csIMG=$anatdir/wc3tANAT*.nii
fIMG=$bolddir/wFPST_BOLD_${SEQUENCE}_${SUBJECT}_mcAP_unwarped

# venticle and cerebral masks
# beforehead: coregister masks to wc1/3 with SPM to obtain same image properties
ventri_mask=$maskdir/rwc3_ALVINbin
cerebr_mask=$maskdir/rwc1_cerebral_mask2bin

# generate binary masks of WM and CSF segments
if [[ ! -f $anatdir/wmMASK.nii.gz ]]; then
    fslmaths $wmIMG -thr 0.5 -bin $anatdir/wmMASK
fi
if [[ ! -f $anatdir/csMASK.nii.gz ]]; then
fslmaths $csIMG -thr 0.5 -bin $anatdir/csMASK
fi

# overlay wm/csMASKs and the cerebral/ventricular masks
echo "masking by BRAIN for subject $SUBJECT"
if [[ ! -f $anatdir/wmMASK_BRAIN.nii.gz ]]; then
fslmaths $anatdir/wmMASK -mas $cerebr_mask $anatdir/wmMASK_BRAIN
fi
if [[ ! -f $anatdir/csMASK_BRAIN.nii.gz ]]; then
fslmaths $anatdir/csMASK -mas $ventri_mask $anatdir/csMASK_BRAIN
fi

# erode wm/csMASKs
echo "eroding WM/CSF for subject $SUBJECT"
if [[ ! -f $anatdir/wmMASK_BRAIN-${kernelWM}.nii.gz ]]; then
    fslmaths $anatdir/wmMASK_BRAIN -kernel sphere $kernelWM -ero $anatdir/wmMASK_BRAIN-${kernelWM}
fi
if [[ ! -f $anatdir/wmMASK_BRAIN-${kernelWM_test}.nii.gz ]]; then
    fslmaths $anatdir/wmMASK_BRAIN -kernel sphere $kernelWM_test -ero $anatdir/wmMASK_BRAIN-${kernelWM_test}
fi
if [[ ! -f $anatdir/csMASK_BRAIN-${kernelCS}.nii.gz ]]; then
    fslmaths $anatdir/csMASK_BRAIN -kernel sphere $kernelCS -ero $anatdir/csMASK_BRAIN-${kernelCS}
fi

# save average timeseries to a text file
# the average is taken over all voxels in the mask
echo "averaging timeseries for subject $SUBJECT"
if [[ ! -f $bolddir/means_wm_${SEQUENCE}.txt ]]; then
    fslmeants -i $fIMG -o $bolddir/means_wm_${SEQUENCE}.txt -m $anatdir/wmMASK_BRAIN-${kernelWM}
fi
if [[ ! -f $bolddir/means_wm_${SEQUENCE}_testwith${kernelWM_test}.txt ]]; then
    fslmeants -i $fIMG -o $bolddir/means_wm_${SEQUENCE}_testwith${kernelWM_test}.txt -m $anatdir/wmMASK_BRAIN-${kernelWM_test}
fi
if [[ ! -f $bolddir/means_cs_${SEQUENCE}.txt ]]; then
    fslmeants -i $fIMG -o $bolddir/means_cs_${SEQUENCE}.txt -m $anatdir/csMASK_BRAIN-${kernelCS}
fi

echo "done"
