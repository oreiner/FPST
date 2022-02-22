%% auxiliary function for get_learning_curves
% posterior.muX is the AV from VBA-Toolbox, however, it includes all
% trials, i.e. also other pairs (so 276 for learning phase plus 120 for
% test phase.) in the get_learning_curves I erase also trials were Cue was
% presented but not chosen - so the length between subjects change
% this function standarizes the trials to all presented. i.e. 92
function [formattedAV] = format_actionvalue_learningcurve(subjects,imodel, maxTrials)   
    %
     if not(exist('imodel', 'var'))
        %imodel = '_task_results_both_phases_asymmetrical_normal_temperature' ;
        imodel = '_task_results_both_phases_asymmetrical_normal_temperature_priorX0_0.5_binSize_1' ;
        binSize=1;
     end
    
     if not(exist('maxTrials', 'var'))
        maxTrials = 92;
     end
     
      if not(exist('learningTrials', 'var'))
        learningTrials = maxTrials*3;
     end
     
    if not(exist('subjects', 'var'))     
        %%get all task log files
        cd '[Home Directory]/analyses/task';
        resultspath = '../../results/task';
        cd '../../results/task';
        d = dir(resultspath); %get the data for the main directory
        mainIndex = [d.isdir] & [~ismember({d.name}, {'.', '..'})] & [~isnan(str2double({d.name}))]; %find the index of the directories (exclude '.' and '..')
        subjects = {d(mainIndex).name}; 
    end
    %initialize Matrix for AV, because some have less than maximal events
    formattedAV = nan(maxTrials,numel(subjects),6); 
    %some subjects missed the last trial, shortening the posterior.muX,
    %lengthen muX with duplicates to 276, so it would count all presented,
    %including missed trials 
    for iS = 1 : numel(subjects) 
        load(fullfile(subjects{iS},[subjects{iS} imodel '.mat']));
        while size(posterior.muX,2) < learningTrials
             posterior.muX = [posterior.muX , posterior.muX(:,end)] ;
        end
        close; %close the VBA-Toolbox figure   
         %get only learnphase to search the matrix more easily. one row is
        %enough because pairs are consistent
        trials = end_results.trial.cue(:,1,1);
        %filter null events because they don't appear in posterior.muX
        trials(find(trials==0)) = [];
        %get the indices
        idxAB = (find(trials==1 | trials==2));
        idxCD = (find(trials==3 | trials==4));
        idxEF = (find(trials==5 | trials==6));
        %return the A-V for each cue    
        %formattedAV(1:2,:,iS) = posterior.muX(1:2,idxAB);
        %formattedAV(3:4,:,iS) = posterior.muX(3:4,idxCD);
        %formattedAV(5:6,:,iS) = posterior.muX(3:4,idxEF);     
        %matching the format from reducedAV
        formattedAV(:,iS,1) = posterior.muX(1,idxAB)'; 
        formattedAV(:,iS,2) = posterior.muX(2,idxAB)';
        formattedAV(:,iS,3) = posterior.muX(3,idxCD)';
        formattedAV(:,iS,4) = posterior.muX(4,idxCD)';
        formattedAV(:,iS,5) = posterior.muX(5,idxEF)';
        formattedAV(:,iS,6) = posterior.muX(6,idxEF)';
    end
end