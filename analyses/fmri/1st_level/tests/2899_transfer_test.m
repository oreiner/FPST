% List of open inputs
nrun = X; % enter the number of runs here
jobfile = {'[Home Directory]/analyses/fmri/1st_level/tests/2899_transfer_test_job.m'};
jobs = repmat(jobfile, 1, nrun);
inputs = cell(0, nrun);
for crun = 1:nrun
end
spm('defaults', 'FMRI');
spm_jobman('run', jobs, inputs{:});
