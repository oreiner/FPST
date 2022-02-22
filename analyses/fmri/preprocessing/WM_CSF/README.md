## Extract mean signal from tissue compartments (WM and CSF)

**sbatch**: extract mean signal from WM/CSF
1. The T1-weighted images underwent automated segmentation by SPM12. The segmentation yielded high-resolution (1 mm isotropic) masks of brain compartments. These were normalized and resampled to match the fMRI data (2 mm isotropic).
2. WM and CSF segments were binarized and eroded (WM by 9mm, CSF by 2mm)
3. The eroded segments were masked with a cerebral/ventricular mask
- run this step in terminal: `./slurm_loop.sh`
- output: means_wm.txt, means_cs.txt

### Background

**Cerebral mask:**
- Use FSL-standard: MNI152lin_T1_2mm_strucseg
- Make mask without cerebellum, brainstem (mask) and midbrain (mask2)
- get rid of holes in the middle: fslmaths cerebral_mask -kernel sphere 2 -dilM cerebral_maskDIL
- erode: fslmaths cerebral_maskDIL -kernel sphere 4 -ero cerebral_maskDILERO4
- Coregister to a wc1*-image to match image properties, binarize

**Ventricle mask:**
- Use ALVIN mask (Automatic Lateral Ventricle dellineatioN): Kempton et al., 2011, NeuroImage, A comprehensive testing protocol for MRI neuroanatomical segmentation techniques: Evaluation of a novel lateral ventricle segmentation method
- Note: FSL-standard, MNI152_T1_2mm_VentricleMask is more extended, not recommended
- Coregister mask to a wc3*-image to match image properties, binarize

**Literature**
- procedure similar to: Power, Plitt, Laumann, & Martin, 2017, Neuroimage. Sources and implications of whole-brain fMRI signals in humans
1.	The T1-weighted images underwent automated segmentation by FreeSurfer version 5.3. The segmentation yielded high-resolution (1 mm isotropic) masks of brain compartments.
2.	Masks of the white matter underwent 0-4 erosion cycles, and ventricle masks underwent 0-2 erosion cycles at 1 mm resolution prior to resampling to fMRI resolution.
3.	Lower resolution masks to match the fMRI data (2 mm isotropic) were created using nearest-neighbor resampling.
- Nuisance regressors used to denoise fMRI data: Motion parameters (realignment estimates, realignment estimate derivatives), nuisance signals (mean white matter signal (eroded 4×), mean ventricle signal (eroded 2×)), and more..
