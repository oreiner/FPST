function c_prepro(subject, sequence)
% finish preprocessing: coreg t1 and t2 to bold, normalize and smooth
fprintf('starting c_prepro for subject %s with seqeunce %s\n',subject, sequence);
%% set paths
niipath   = '../../../results/fmri/nii';
jobfile =   'c_prepro_job.m';
filename = ['FPST_BOLD_' sequence '_' subject '_mcAP_unwarped.nii'];

%% spm settings
spm('defaults', 'fmri');
spm_jobman('initcfg');
jobs = repmat(jobfile, 1, 1);
inputs = cell(1, 1);

%% specify subject's paths
niipathsub      = fullfile(niipath, subject);
niipathAnatsub  = fullfile(niipathsub, 'anatomy');

count = 1;
%% Coregister: coregister t2 to bold
% reference: bold
if exist (fullfile(niipathsub, [filename '.gz']), 'file')
    gunzip(fullfile(niipathsub, [filename '.gz']));
    delete(fullfile(niipathsub, [filename '.gz']));
end
input_imgF = fullfile(niipathsub, [filename ',1']);
inputs{count, 1} = {input_imgF};
count = count+1;
% source: t2
input_imgT2 = dir(fullfile(niipathAnatsub, 'tANAT*t2*.nii'));
inputs{count, 1} = {fullfile(niipathAnatsub, input_imgT2.name)};
count = count+1;

%% Coregister: coregister t1 to t2
% reference: dependency - coregistered t2
% source: t1
input_imgT1 = dir(fullfile(niipathAnatsub, 'tANAT*t1*.nii'));
% check whether your t1 image has a differnt name
if size(input_imgT1,1)==0
    input_imgT1 = dir(fullfile(niipathAnatsub, 'tANAT*3D*.nii'));
end
inputs{count, 1} = {fullfile(niipathAnatsub, input_imgT1.name)};
count = count+1;

%% Normalize Write: write bold
input_imgF = fullfile(niipathsub, filename);
inputs{count, 1} = {input_imgF};

%% process  all input images for the current subject
clear matlabbatch
spm_jobman('serial', jobs, '', inputs{:});

end
