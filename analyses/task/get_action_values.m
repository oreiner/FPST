function get_action_values(imodel)
    %%get all task log files
    cd '[Home Directory]/analyses/task';
    resultspath = '../../results/task';
    cd '../../results/task';
    
    if not(exist('imodel', 'var'))
        imodel = '_task_results_both_phases_asymmetrical_normal_temperature.mat' ;
    end
    
    %get subjects
    d = dir(resultspath); %get the data for the main directory
    mainIndex = [d.isdir] & [~ismember({d.name}, {'.', '..'})] & [~isnan(str2double({d.name}))]; %find the index of the directories (exclude '.' and '..')
    subjects = {d(mainIndex).name};
    nsubs = numel(subjects)
    
    ActionValues = zeros(6,9);
    cwinwin = zeros(1,9);
    closelose = zeros(1,9);
    
    for iS = 1 : nsubs
        load(fullfile(subjects{iS},[subjects{iS} imodel]));
        ActionValues(:,iS) = posterior.muX(:,end)  
        
        if not(strcmp(subjects(iS),'7873')) %no tranfer phase data
            winwin = end_results.trial.winwin(:,2);
            winwin(find(isnan(winwin))) = [];
            cwinwin(iS) = sum(winwin)/numel(winwin);

            loselose = end_results.trial.loselose(:,2);
            loselose(find(isnan(loselose))) = [];
            closelose(iS) = sum(loselose)/numel(loselose);
        end
        close all;
    end
    
    meanActionValues = mean(ActionValues,2);
    stdActionValues = std(ActionValues,0,2);
    
    mwinwin = mean(cwinwin);
    stdwinwin = std(cwinwin);
    
    mloselose = mean(closelose);
    stdloselose = std(closelose);
    
    figure
    hold on
    
    xticks(1:6)
    xticklabels({'A (80%)','C (70%)', 'E (60%)', 'F (40%)','D (30%)','B (20%)'})
    ylabel('final Q-Value (mean + SEM)')
    %reorder action values 
    indx = [1,3,5,6,4,2];
    meanActionValuesReorderd = meanActionValues(indx);
    stdActionValuesReorderd = stdActionValues(indx);
    semActionValues = stdActionValuesReorderd/sqrt(numel(stdActionValuesReorderd));
    bar(1:6,meanActionValuesReorderd)
    errorbar(1:6,meanActionValuesReorderd,semActionValues,'.');
    title('mean action values');
    
    
    figure
    hold on
    bar([mwinwin,mloselose])
    errorbar([mwinwin,mloselose],[stdwinwin,stdloselose],'.');
    set(gca,'xticklabel',{'','','win-win','','lose-lose','',''})
    title('mean high conflict correct choices'); 
    
    figure
    hold on
    boxplot([cwinwin,closelose],[repmat("win-win",nsubs,1)',repmat("lose-lose",nsubs,1)'])
    title('mean high conflict correct choices');
    
    save(['action_values' imodel '.mat'], 'ActionValues', 'meanActionValues', 'stdActionValues', 'mloselose', 'stdloselose', 'mwinwin', 'stdwinwin');
    
    %close all;
    
end