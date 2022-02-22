% List of open inputs
nrun = X; % enter the number of runs here
jobfile = {'[Home Directory]/analyses/fmri/2nd_level/tests/t_test_PE_job_job_job.m'};
jobs = repmat(jobfile, 1, nrun);
inputs = cell(0, nrun);
for crun = 1:nrun
end
spm('defaults', 'FMRI');
spm_jobman('run', jobs, inputs{:});
