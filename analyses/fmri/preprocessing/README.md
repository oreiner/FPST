## This Readme is for MPI Server with Slurm. not everything applicable to NUK-Server

## Preprocess MR data before the analyses

### PREPROCESSING

**A prepImg**: prepare images for topup with SPM
- copy data from the transfer server, unzip, delete 10 dummy images from functional data
- run this step in terminal: `./a_prepImg_slurm_loop.sh`
- output: OF2_bold.nii

**B topup**: distortion correction with FSL
- motion correct functional data, register to AP-first volume
- estimate distortion parameters, apply to functional data
- run this step in terminal: `./b_topup_slurm_loop.sh`
- output: OF2_bold_mcAP_unwarped.nii.gz

**C prepro**: finish preprocessing with SPM
- coregister structural to functional data
- normalize data to MNI space using segmentation of the t1 image
- smooth with 8mm FWHM kernel
- run this step in terminal: `./c_prepro_slurm_loop.sh`
- output: swOF2_bold_mcAP_unwarped.nii

### CONFOUND REGRESSION

**DVARS**: identify outlier volumes with FSL (scrubbing)
- metric = DVARS = global measure of signal change (Power et al., 2011)
- run this step in terminal: `cd dvars, ./d_dvars_slurm_loop.sh`
- output: moconf_metrics_dvars.txt

**Extract tissue compartment signal**: WM and CSF
- extract eigenvariates for 4 VOIs: WMr, WMl, CSFr, CSFl
- run this step in terminal: `cd WM_CSF, ./START_slurm_VOI.sh`
- output: VOI_*1.mat

**Confound regression**:
- save all confounds into one text file, input for multiple regressors
- confounds: 12 motion regressors (6xrealignment & 6xrealignment^2), scrubbing, 4 tissue compartment regressors
- for original confounds (submitted paper), see orig (6 motion regressors, scrubbing)
- run this step in terminal: `cd multi_reg, ./slurm_loop.sh`
- output: multi_reg*.txt

### START ALL
- run in  terminal: `./START_slurm_PREPRO.sh`
