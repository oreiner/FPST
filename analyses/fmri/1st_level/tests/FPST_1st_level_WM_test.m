function FPST_1st_level_WM_test(subject, sequence, kernel, model)
	%%load analyzed task data (onsets, parametric modulator)
	%%perform 1st level analysis with preprocessed Data
	%% load task variables
	taskpath = '[Home Directory]/results/task';
	model = '_task_results_both_phases_asymmetrical_normal_temperature';	
	load(fullfile(taskpath, subject, [subject model '.mat']));
	%% set spm job	
	niipath   = '[Home Directory]/results/fmri/nii';	
    niipathsub  = fullfile(niipath, subject);
	jobfile = ['1st_level_job_' sequence '.m'];
    jobs = repmat(jobfile, 1, 1);
	inputs = cell(1, 1);
	count = 1;   
	%% config mri variables
	input_dir = fullfile('[Home Directory]/results/fmri/1st_level', subject, sequence, ['test WM' kernel ' 75p15']);  
    if not(exist(input_dir, 'dir'))
        mkdir(input_dir);
    end
    TR = 1.22; 
    %get multiple regressors (outliers, CSF+WM signals and motion
    %paramteres)
	txtname = dir(fullfile(niipathsub, ['75p15_24mp_WMCSF_' sequence '_' kernel '_WMtest.txt']));  
	motion_parameters = fullfile(txtname.folder, txtname.name);	

	%% spm settings	
	spm('defaults', 'fmri');
	spm_jobman('initcfg');

    %% set output dir
    inputs{count, 1} = {input_dir};	count = count+1; 
    %% set TR
    inputs{count,1} = TR; count = count+1;
	%% choose smoothed functional images as scans
	input_imgF = fullfile(niipathsub, ['swFPST_BOLD_' sequence '_' subject '_mcAP_unwarped.nii']); 
	inputs{count, 1} = {input_imgF}; count = count+1; 
	%% load task results into regressors
     
     if sequence == 'learning'
        %condition: cue
        inputs{count, 1} = 'cue' ; count = count+1; %name
        inputs{count, 1} = end_results.onsets(1).cue ; count = count+1; %onsets
        inputs{count, 1} = (end_results.onsets(1).choicescreen - end_results.onsets(1).cue + 0.3); count = count+1; %duration
         %condition: Positive feedback milkshake
        inputs{count, 1} = 'Milkshake' ; count = count+1; %name
        inputs{count, 1} = end_results.onsets(1).Pshake ; count = count+1;  %onsets
        inputs{count, 1} = (1.2 + 3.1 -0.3); count = count+1; %duration
        inputs{count, 1} = 'pos_PE' ; count = count+1;%name 
        inputs{count, 1} = end_results.model.pos_PE ; count = count+1; %values
        inputs{count, 1} = 1 ; count = count+1; %polynomial expanstion
         %condition: Negative feedback neutral solution
        inputs{count, 1} = 'Neutral' ; count = count+1; %name
        inputs{count, 1} = end_results.onsets(1).Nshake ; count = count+1;  %onsets
        inputs{count, 1} = (1.2 + 3.1 -0.3); count = count+1; %duration 
        inputs{count, 1} = 'neg_PE' ; count = count+1;%name 
        inputs{count, 1} = end_results.model.neg_PE ; count = count+1; %values
        inputs{count, 1} = 1 ; count = count+1; %polynomial expanstion
         %condition: null events
        inputs{count, 1} = 'null_events' ; count = count+1; %name
        inputs{count, 1} = end_results.onsets(1).null ; count = count+1; %onsets
        inputs{count, 1} = 1.7+3.1; count = count+1; %duration 
         %condition: missed events
        inputs{count, 1} = 'miss' ; count = count+1; %name
        inputs{count, 1} = end_results.onsets(1).miss ; count = count+1; %onsets
        inputs{count, 1} = 2; count = count+1; %duration 
     elseif sequence == 'transfer'
        %condition: cue
        inputs{count, 1} = 'cue' ; count = count+1; %name
        inputs{count, 1} = end_results.onsets(2).cue ; count = count+1; %onsets
        inputs{count, 1} = (end_results.onsets(2).choicescreen - end_results.onsets(2).cue); count = count+1; %duration
        %condition: choose A decisions
        inputs{count, 1} = 'choose1' ; count = count+1; %name
        inputs{count, 1} = end_results.onsets(2).choose1 ; count = count+1;  %onsets
        inputs{count, 1} = 0; count = count+1; %duration
         %condition: avoid B decisions
        inputs{count, 1} = 'avoid2' ; count = count+1; %name
        inputs{count, 1} = end_results.onsets(2).avoid2 ; count = count+1;  %onsets
        inputs{count, 1} = 0; count = count+1; %duration 
        %condition: winwin pairs
        inputs{count, 1} = 'winwin' ; count = count+1; %name
        inputs{count, 1} = end_results.onsets(2).winwin ; count = count+1;  %onsets
        inputs{count, 1} = 0; count = count+1; %duration
         %condition: loselose pairs
        inputs{count, 1} = 'loselose' ; count = count+1; %name
        inputs{count, 1} = end_results.onsets(2).loselose ; count = count+1;  %onsets
        inputs{count, 1} = 0; count = count+1; %duration 
         %condition: other decisions ()
        inputs{count, 1} = 'no_interest' ; count = count+1; %name
        inputs{count, 1} = end_results.onsets(2).notinteresting ; count = count+1;  %onsets
        inputs{count, 1} = 0; count = count+1; %duration 
         %condition: null events
        inputs{count, 1} = 'null_events' ; count = count+1; %name
        inputs{count, 1} = end_results.onsets(2).null ; count = count+1; %onsets
        inputs{count, 1} = 4; count = count+1; %duration 
         %condition: missed events
        inputs{count, 1} = 'miss' ; count = count+1; %name
        inputs{count, 1} = end_results.onsets(2).miss ; count = count+1; %onsets
        inputs{count, 1} = 2 ; count = count+1; %duration 
     end
    %% multiple regressor: Fristons motion parameters, CSF/WM nuisance signals, outliers
    inputs{count, 1} = {motion_parameters}; count = count+1; %onsets
    
    %% process  all input images for the current subject
    clear matlabbatch
    spm_jobman('serial', jobs, '', inputs{:});
end