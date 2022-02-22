 if not(exist('imodel', 'var'))
        imodel = '_task_results_both_phases_asymmetrical_normal_temperature.mat' ;
    end
    
R=nan(1,10);
cd '[Home Directory]/analyses/task';
    resultspath = '../../results/task';
    cd '../../results/task';
    d = dir(resultspath); %get the data for the main directory
    mainIndex = [d.isdir] & [~ismember({d.name}, {'.', '..'})] & [~isnan(str2double({d.name}))]; %find the index of the directories (exclude '.' and '..')
    subjects = {d(mainIndex).name};
    for iS = 1 : numel(subjects) 
        load(fullfile(subjects{iS},[subjects{iS} imodel])); close all;
       subjects{iS};
       R(iS) = (1.7*276/60 - nansum(end_results.trial.RT(:,:,1))/60); 
    end