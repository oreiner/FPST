datapath = '../../../../results/fmri/nii/';
mainData = dir(datapath); %get the data for the main directory
mainIndex = [mainData.isdir] & [~ismember({mainData.name}, {'.', '..'})]; %find the index of the directories (exclude '.' and '..')
subjects = {mainData(mainIndex).name}; %get a list of the directory names (IDs of the subjects)

for iSub = 1:numel(subjects)
    anatdir = ['../../../../results/fmri/nii/' subjects{iSub} '/anat'];
    delete(fullfile(anatdir, 'cs*'));
    delete(fullfile(anatdir, 'wm*'));
end