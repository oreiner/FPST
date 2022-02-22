function FPST_1st_results_WM_test(subject, sequence, kernel)
	%%load analyzed task data (onsets, parametric modulator)
	%%perform 1st level analysis with preprocessed Data
	%% set spm job	
	path = '[Home Directory]/results/fmri/1st_level';	
    pathsub  = fullfile(path, subject, sequence, ['test WM' kernel]);
	jobfile = 'FPST_1st_results_job.m';
    jobs = repmat(jobfile, 1, 1);
	inputs = cell(1, 1);
	count = 1;   

	%% spm settings	
	spm('defaults', 'fmri');
	spm_jobman('initcfg');

    %% set location of 1st_Level spm.mat
    inputs{count, 1} = {[pathsub '/SPM.mat']};	count = count+1;
    
    %% process  all input images for the current subject
    clear matlabbatch
    spm_jobman('serial', jobs, '', inputs{:});
end