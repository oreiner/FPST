%%cues were pseudorandomzied for reward probabilites, but that doesn't mean 
%%the users actually experienced the expected contigency. so get the real data to compare 

function get_contengencies()
    %%get all task log files
    cd '[Home Directory]/analyses/task';
    resultspath = '../../results/task';
    cd '../../results/task';
    %%config variables
    %numel pairs
    %nsum =   [276 120] ; %total number of pairs in learning and test
    %npairs =   [92 8] ; %number of old pairs in learning and test
    %nnovel =  96 ; %number of noval pairs in twst
   % nA_nB = 32; %number of choose A or Avoid B pairs (AC AD AE AF; BC BD BE BF) (not including AB) in test
    %nwinwin = 24; %number of winwin (AC AE CE) or loslose (BD BF FD) pairs in test
  
    if not(exist('imodel', 'var'))
        imodel = '_task_results_both_phases_asymmetrical_normal_temperature.mat' ;
    end
    
    %%initialize variables
    %get subjects
    d = dir(resultspath); %get the data for the main directory
    mainIndex = [d.isdir] & [~ismember({d.name}, {'.', '..'})] & [~isnan(str2double({d.name}))]; %find the index of the directories (exclude '.' and '..')
    subjects = {d(mainIndex).name};
    %all pairs
    contingencies = NaN(numel(subjects) , 6);
    choseCue = NaN(numel(subjects) , 6);
    
    for iS = 1 : numel(subjects) 
        
        load(fullfile(subjects{iS},[subjects{iS} imodel]));
        
        choices = end_results.trial.choice(:,1,1);
        feedback = end_results.trial.shake(:,1,1);
        
        for i=1:6
           contingencies(iS,i) = nansum(feedback(find(choices==i))) / nansum(choices==i);
           choseCue(iS,i) = nansum(choices==i);
        end
      
        close all;
        %{ 
        gcf = figure
        hold on
        bar(1:nBin_pair,learning_EF_correct(:,iS))
        title('experienced contingency');
        xticks(1:1:6);          yticks();
        saveas(gcf,fullfile(resultspath,'learning_curve_graphs',['learning-curve-EF_' subjects{iS}]),'jpg');
        %} 
    end

 
    contingencyT = table(subjects', contingencies(:,1),contingencies(:,2),contingencies(:,3),contingencies(:,4),contingencies(:,5),contingencies(:,6));
    contingencyT.Properties.VariableNames = {'Subject','A','B','C','D','E','F'};
            
    chosenCuesT = table(subjects', choseCue(:,1),choseCue(:,2),choseCue(:,3),choseCue(:,4),choseCue(:,5),choseCue(:,6));
    chosenCuesT.Properties.VariableNames = {'Subject','A','B','C','D','E','F'};
    
    save('contingencies.mat', 'contingencies', 'contingencyT','chosenCuesT');            
    writetable(contingencyT, ['experienced_contingencies.csv']);
    writetable(chosenCuesT, ['chosenCues.csv']);
    close all;
      
end