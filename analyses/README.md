# Analyses

These are the scripts needed to analyse the task results and the fmri data.
Results are saved directly in the  ../results/ folder

> 1. Prepare the logs for each subject using [data] = format_data(1 (or 2), onsets, trial.shake). 
>> (no need to use format_choices, this is done intrinsically in demo_QlearningAsymetric)
> 2. Use VBA-Toolbox to analyze the data for behavioural results and to obtain PE times for format data [posterior, out] = demo_QlearningAsymetric (data) 
> 3. Prepare the logs of each subject for SPM using 

## behavioural task analysis:
>	1. Run analyse\_task\_loop().m with the respective participant ID numbers. This will format the logs and model the results with different Q-learning models using the VBA-Toolbox.
>	2. Use the get\_X.m functions to analyse behavior for non-model-based results : accuracy, response speed, milkshake rating as well as calculating the average state-action values from the models.
>   3. Use the draw\_X.m functions to draw graphs for the results

## fMRI preprocessing:
>	1. Prepare images by moving and unzipping data from data/data_mr/subject to
	results/fmri/nii/subject
>	2. Run preprocess_loop to preprocess each participant's fmri data. This would perform the following steps:
>>	1. Expand images to remove dummy scans in SPM
>>	2. Run topup & applytopup with FSL
>>	3. Realign, coregister, segment, normalize, smooth with SPM
>>	4. Calculate nuisance signals from motion outliers (DVARS), White Matter and CSF and merge this with the realigment parameters as a multiple regressor .

## fMRI statistical analyses using task results:
Once the fMRI fata has been preprocessed and the behavioural task results were formatted, run analysis\_loop with chosen models and phases to perform the statistical analysis. This would perform the following steps:
>	1. Load formatted task data
>	2. Perform 1st level analysis for each participant and for each chosen phase.
>	3. Perform 2nd level analysis for the group from the respective 1st level analysis.

## Jitter design efficiency analysis:
This is meant to be run before running the experiment, to choose the most efficient jitter design for later analysis of fMRI data. But I also used this for a post-hoc analysis using the actual decisions from the participants.
>	1. Run design\_efficiency\_X.m to simulate different jitter designs. Contrasts of interest most also be chosen beforehand
>	2. Run read_effall with the design name from design\_efficiency\_X.m to calculate efficiency and Laplace-Chernoff risk and draw the graph. Contrasts etc. need to be renamed manually. 
