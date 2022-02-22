function a_prepImg(subject, sequence)
% prepare images for topup: copy, rename and delete first 10 EPI images

%% set paths
fprintf('starting a_prepImg for subject %s with seqeunce %s\n',subject, sequence);
transfer  = '/project/FPST/MRI/probands'; %only relevent for MPI-Server
transanat = '/project/ANAT/MRI/probands'; %only relevent for MPI-Server
datapath  = '../../../data/data_mr';
niipath   = '../../../results/fmri/nii';
jobfile   = 'a_prepImg_job.m';

%% spm settings
spm('defaults', 'fmri');
spm_jobman('initcfg');
jobs = repmat(jobfile, 1, 1);
inputs = cell(3, 1);

%% specify subject's paths
datapathsub     = fullfile(datapath, subject);
niipathsub      = fullfile(niipath, subject);
niipathAnatsub  = fullfile(niipathsub, 'anatomy');

%% specify subject's data
%% unzip subject's images
%%test for existing files and folders, skip if already unzipped
if not(exist(niipathsub, 'dir'))
    mkdir(niipathsub);
end
fprintf('unzipping files\n');
% unzip functionals, move to folder 'nii'
smart_gunzip ([datapathsub '/fmri'], ['*bold*' sequence '.nii.gz'], niipathsub);
% % unzip structurals, move to folder 'nii'
smart_gunzip ([datapathsub '/anatomy'], '*t1*.nii.gz', niipathAnatsub);
smart_gunzip ([datapathsub '/anatomy'], '*t2*.nii.gz', niipathAnatsub);
% copy AP/PA to folder 'nii'. only copy because fsl can handle .gz
smart_gunzip ([datapathsub '/fmri'], '*sms8_AP.nii.gz', niipathsub, 1);
smart_gunzip ([datapathsub '/fmri'], '*sms8_PA.nii.gz', niipathsub, 1);
% copy fullbrain AP/PA to folder 'nii'
%smart_gunzip ([datapathsub '/fmri'], '*fullbrain_AP.nii.gz', niipathsub);
%smart_gunzip ([datapathsub '/fmri'], '*fullbrain_PA.nii.gz', niipathsub);

%{
%% rename AP and PA
fprintf('renaming ap/pa files\n')
imgap      = ['tOF2_', subject,'*_AP.nii'];
orig       = dir(fullfile(niipathsub, imgap));
origpath   = fullfile(niipathsub, orig.name);
targetpath = fullfile(niipathsub, 'OF2_AP.nii');
movefile(origpath, targetpath);

imgap      = ['tOF2_', subject,'*_PA.nii'];
orig       = dir(fullfile(niipathsub, imgap));
origpath   = fullfile(niipathsub, orig.name);
targetpath = fullfile(niipathsub, 'OF2_PA.nii');
movefile(origpath, targetpath);
%}

%% specify subject's inputs for the job
fprintf('starting job\n')
count = 1;

bold_name = ['FPST_BOLD_' sequence '_' subject];
input_img = dir(fullfile(niipathsub, ['*bold*' sequence '.nii']));
inputs{count, 1} = {fullfile(niipathsub, input_img.name)};
count = count+1;
inputs{count, 1} = bold_name;
count = count+1;

%% process  all input images for the current subject
clear matlabbatch
spm_jobman('serial', jobs, '', inputs{:});

end
