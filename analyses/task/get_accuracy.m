function get_accuracy(imodel)
    %%get all task log files
    cd '[Home Directory]/analyses/task';
    resultspath = '../../results/task';
    cd '../../results/task';
    %%config variables
    %numel pairs
    nsum =   [276 120] ; %total number of pairs in learning and test
    npairs =   [92 8] ; %number of old pairs in learning and test
    nnovel =  96 ; %number of noval pairs in twst
    nA_nB = 32; %number of choose A or Avoid B pairs (AC AD AE AF; BC BD BE BF) (not including AB) in test
    nwinwin = 24; %number of winwin (AC AE CE) or loslose (BD BF FD) pairs in test
    nwinlose = 72; %number of low conflict (AB AD AF CB CD CF EB ED EF) pairs in test
    
    if not(exist('imodel', 'var'))
        imodel = '_task_results_both_phases_asymmetrical_normal_temperature.mat' ;
    end
    
    %%initialize variables
    %get subjects
    d = dir(resultspath); %get the data for the main directory
    mainIndex = [d.isdir] & [~ismember({d.name}, {'.', '..'})] & [~isnan(str2double({d.name}))]; %find the index of the directories (exclude '.' and '..')
    subjects = {d(mainIndex).name};
    %all pairs
    sum_correct = NaN(numel(subjects) , 2);
    psum_correct = NaN(numel(subjects) , 2);
    %learning pairs AB CD EF
    pairs_correct = NaN(numel(subjects) , 6);
    ppairs_correct = NaN(numel(subjects) , 6);
    %noval and old pairs in testphase sum
    old_correct = zeros(numel(subjects),1);
    pold_correct = zeros(numel(subjects),1);
    novel_correct = zeros(numel(subjects),1);
    pnovel_correct = zeros(numel(subjects),1);
    %testphase: choose A avoid B winwin loselose
    chooseA_correct = zeros(numel(subjects),1);
    AvoidB_correct = zeros(numel(subjects),1);
    pchooseA_correct = zeros(numel(subjects),1);
    pAvoidB_correct = zeros(numel(subjects),1);
    
    winwin_correct = zeros(numel(subjects),1);
    pwinwin_correct = zeros(numel(subjects),1);
    loselose_correct =  zeros(numel(subjects),1);
    ploselose_correct =  zeros(numel(subjects),1);
    
    winlose_correct =  zeros(numel(subjects),1);
    pwinlose_correct =  zeros(numel(subjects),1);
    
    for iS = 1 : numel(subjects) 
        load(fullfile(subjects{iS},[subjects{iS} imodel]));
        %%get learning rates and inverse temperature. 
        %functions from VBA-Toolbox needed
        pos_learning_rate(iS,1) = sigm(posterior.muTheta(1) + posterior.muTheta(2));
        neg_learning_rate(iS,1) = sigm(posterior.muTheta(1) - posterior.muTheta(2));
        inverse_temperature(iS,1) =  exp(posterior.muPhi);
        
        %%get accuracies 
		%skips NaNs (missed events). consider counting them as zeros (requires changing format_data_test)
		%reconsidered. changed NaNs to zeros because this makes dividing bins easier.
        nBin = numel(end_results.trial.correct_bins.all(:,1));
        learning_correct(:,iS) = end_results.trial.correct_bins.all(:,1); 
        
        nBin_pair = numel(end_results.trial.correct_bins.AB(:,1));
        learning_AB_correct(:,iS) = end_results.trial.correct_bins.AB(:,1); 
        learning_CD_correct(:,iS) = end_results.trial.correct_bins.CD(:,1); 
        learning_EF_correct(:,iS) = end_results.trial.correct_bins.EF(:,1); 
        
        AB = nansum(end_results.trial.AB);  
        CD = nansum(end_results.trial.CD);
        EF = nansum(end_results.trial.EF);
        
        if not(strcmp(subjects(iS),'7873')) %no tranfer phase data
            sum_correct(iS,:) = end_results.trial.correct;
            psum_correct(iS,:) = [end_results.trial.correct(1)/nsum(1) end_results.trial.correct(2)/nsum(2)];
           
            pairs_correct(iS,:)  = [ AB(1) AB(2) CD(1) CD(2) EF(1) EF(2)];
            ppairs_correct(iS,:) = [ AB(1)/npairs(1) AB(2)/npairs(2) CD(1)/npairs(1) CD(2)/npairs(2) EF(1)/npairs(1) EF(2)/npairs(2)];
            
            old_correct(iS,1) =  sum([AB(2) CD(2) EF(2)]);
            pold_correct(iS,1) =  old_correct(iS,1)/(npairs(2)*3);
           
            novel_correct(iS,1) = sum_correct(iS,2) - old_correct(iS,1); 
            pnovel_correct(iS,1) = novel_correct(iS,1)/nnovel;  
             
            chooseA_correct(iS,1) = nansum(end_results.trial.choose1(:,2));
            pchooseA_correct(iS,1) = chooseA_correct(iS,1)/nA_nB;
            AvoidB_correct(iS,1) = nansum(end_results.trial.avoid2(:,2));
            pAvoidB_correct(iS,1) = AvoidB_correct(iS,1)/nA_nB;
            
            winwin_correct(iS,1) = nansum(end_results.trial.winwin(:,2));
            pwinwin_correct(iS,1) = winwin_correct(iS,1)/nwinwin;
            loselose_correct(iS,1) = nansum(end_results.trial.loselose(:,2));
            ploselose_correct(iS,1) = loselose_correct(iS,1)/nwinwin;
            winlose_correct(iS,1) = nansum(end_results.trial.winlose(:,2));
            pwinlose_correct(iS,1) = winlose_correct(iS,1)/nwinlose;

        else  %7873 exception no tranfer phase data
            sum_correct(iS,:) = [end_results.trial.correct(1) NaN];
            psum_correct(iS,:) = [end_results.trial.correct(1)/nsum(1) NaN];
            
            pairs_correct(iS,:)  = [ AB(1) NaN CD(1)  NaN EF(1) NaN];
            ppairs_correct(iS,:) = [ AB(1)/npairs(1) NaN CD(1)/npairs(1) NaN EF(1)/npairs(1) NaN ];
            
            old_correct(iS,1) =  NaN;
            pold_correct(iS,1) =  NaN;
            
            novel_correct(iS,1) = NaN; 
            pnovel_correct(iS,1) = NaN;
            
            chooseA_correct(iS,1) = NaN;
            pchooseA_correct(iS,1) = NaN;
            AvoidB_correct(iS,1) = NaN;
            pAvoidB_correct(iS,1) = NaN;
            
            winwin_correct(iS,1) = NaN;
            pwinwin_correct(iS,1) = NaN;
            loselose_correct(iS,1) = NaN;
            ploselose_correct(iS,1) = NaN;
            winlose_correct(iS,1) = NaN;
            pwinlose_correct(iS,1) = NaN;
            
        end
        close all;
        %{ 
        %create bin graphs for learning curve    
        figure
        hold on
        graph = bar(1:nBin,learning_correct(:,iS))
        title('mean learning curve');
         xticks(1:1:23);
         yticks(0:1:12); 
        saveas(graph,fullfile(resultspath,'learning_curve_graphs',['learning-curve_total_' subjects{iS}]),'jpg');
         
        %create bin graphs seperated by pair  
        figure
        hold on
        graph = bar(1:nBin_pair,learning_AB_correct(:,iS))
        title('AB learning curve');
        xticks(1:1:23);          yticks(0:1:4);
        saveas(graph,fullfile(resultspath,'learning_curve_graphs',['learning-curve-AB_' subjects{iS}]),'jpg');
        
        figure
        hold on
        graph = bar(1:nBin_pair,learning_CD_correct(:,iS))
        title('CD learning curve');
        xticks(1:1:23);          yticks(0:1:4);
        saveas(graph,fullfile(resultspath,'learning_curve_graphs',['learning-curve-CD_' subjects{iS}]),'jpg');
        
        figure
        hold on
        graph = bar(1:nBin_pair,learning_EF_correct(:,iS))
        title('EF learning curve');
        xticks(1:1:23);          yticks(0:1:4);
        saveas(graph,fullfile(resultspath,'learning_curve_graphs',['learning-curve-EF_' subjects{iS}]),'jpg');
        %} 
    end
    
    %%create accuracy table
    vmean = @ (v)[v ; nanmean(v) ] ; %anonymous function to add mean line
    accuracy = table([subjects' ; 'mean'], ...
                    vmean(pos_learning_rate(:,1)), vmean(neg_learning_rate(:,1)), vmean(inverse_temperature(:,1)), ... 
                    vmean(sum_correct(:,1)), vmean(psum_correct(:,1)),vmean(sum_correct(:,2)),vmean(psum_correct(:,2)), ...
                    vmean(old_correct(:,1)), vmean(pold_correct(:,1)), vmean(novel_correct(:,1)),  vmean(pnovel_correct(:,1)), ...
                    vmean(pairs_correct(:,1)),vmean(ppairs_correct(:,1)),vmean(pairs_correct(:,3)),vmean(ppairs_correct(:,3)),vmean(pairs_correct(:,5)),vmean(ppairs_correct(:,5)), ...
                    vmean(pairs_correct(:,2)),vmean(ppairs_correct(:,2)),vmean(pairs_correct(:,4)),vmean(ppairs_correct(:,4)),vmean(pairs_correct(:,6)),vmean(ppairs_correct(:,6)), ...
                    vmean(chooseA_correct(:,1)), vmean(pchooseA_correct(:,1)), vmean(AvoidB_correct(:,1)),  vmean(pAvoidB_correct(:,1)), ...
                    vmean(winwin_correct(:,1)), vmean(pwinwin_correct(:,1)), vmean(loselose_correct(:,1)),  vmean(ploselose_correct(:,1)), vmean(winlose_correct(:,1)),  vmean(pwinlose_correct(:,1)) ...
                );
            %{ 
if only I had 2018a :( 
    accuracy = table([subjects' ; 'mean'], ...
                  vmean([ ...
                    pos_learning_rate(:,1), neg_learning_rate(:,1), inverse_temperature(:,1), ... 
                    sum_correct(:,1),psum_correct(:,1),sum_correct(:,2),psum_correct(:,2), ...
                    old_correct(:,1), pold_correct(:,1), novel_correct(:,1),  pnovel_correct(:,1), ...
                    pairs_correct(:,1),ppairs_correct(:,1),pairs_correct(:,3),ppairs_correct(:,3),pairs_correct(:,5),ppairs_correct(:,5), ...
                    pairs_correct(:,2),ppairs_correct(:,2),pairs_correct(:,4),ppairs_correct(:,4),pairs_correct(:,6),ppairs_correct(:,6), ...
                    chooseA_correct(:,1), pchooseA_correct(:,1), AvoidB_correct(:,1),  pAvoidB_correct(:,1), ...
                    winwin_correct(:,1), pwinwin_correct(:,1), loselose_correct(:,1),  ploselose_correct(:,1) ...
                   ]) ...
                );
    accuracy = splitvars(accuracy); %only available with version R2018a 
                %}   
    accuracy.Properties.VariableNames = {'Subject', ...
                                          'pos_learning_rate', 'neg_learning_rate', 'inverse_temperature', ...
                                          'learning_total_correct','learning_total_percent','test_total_correct','test_total_percent', ...
                                          'test_old_pairs_total_correct', 'test_old_pairs_percent','test_novel_pairs_total_correct', 'test_novel_pairs_percent', ... 
                                          'AB_learning_correct',  'AB_learning_percent', 'CD_learning_correct',  'CD_learning_percent', 'EF_learning_correct',  'EF_learning_percent',   ...
                                          'AB_test_correct',  'AB_test_percent', 'CD_test_correct',  'CD_test_percent', 'EF_test_correct',  'EF_test_percent',   ...
                                          'choose_A_correct', 'choose_A_percent', 'avoid_B_correct', 'avoid_B_percent', ...
                                          'winwin_correct', 'winwin_percent', 'loselose_correct', 'loselose_percent' 'winlose_correct', 'winlose_percent' ...
                                          }; 
    accuracy_summary = summary(accuracy);
    %{ 
    %%figures mean learning curves
    meanLearning = mean(learning_correct,2);
    stdMeanLearning = std(learning_correct,0,2);
    figure
    hold on
    graph = bar(1:nBin,meanLearning)
    errorbar(1:nBin,meanLearning,stdMeanLearning,'.');
    title('mean learning curve');
    xticks(1:1:23);
    yticks(0:1:12);
    saveas(graph,fullfile(resultspath,'learning_curve_graphs','learning-curve_MEAN_Total'),'jpg');
    
    meanLearning_AB = mean(learning_AB_correct,2);
    stdMeanLearning_AB = std(learning_AB_correct,0,2);
    figure
    hold on
    graph = bar(1:nBin_pair,meanLearning_AB)
    errorbar(1:nBin,meanLearning_AB,stdMeanLearning_AB,'.');
    title('mean AB learning curve ');
    xticks(1:1:23);
         yticks(0:1:12);
    saveas(graph,fullfile(resultspath,'learning_curve_graphs','learning-curve-MEAN_AB'),'jpg');
    
    
    meanLearning_CD = mean(learning_CD_correct,2);
    stdMeanLearning_CD = std(learning_CD_correct,0,2);
    figure
    hold on
    graph = bar(1:nBin_pair,meanLearning_CD)
    errorbar(1:nBin,meanLearning_CD,stdMeanLearning_CD,'.');
    title('mean CD learning curve ');
    xticks(1:1:23);
         yticks(0:1:12);
    saveas(graph,fullfile(resultspath,'learning_curve_graphs','learning-curve-MEAN_CD'),'jpg');
    
    meanLearning_EF = mean(learning_EF_correct,2);
    stdMeanLearning_EF = std(learning_EF_correct,0,2);
    figure
    hold on
    graph = bar(1:nBin_pair,meanLearning_EF)
    errorbar(1:nBin,meanLearning_EF,stdMeanLearning_EF,'.');
    title('mean EF learning curve ');
    xticks(1:1:23);
         yticks(0:1:12);
    saveas(graph,fullfile(resultspath,'learning_curve_graphs','learning-curve-MEAN_EF'),'jpg');
    %}
    %%new figures - as line plot
    meanLearning_AB = mean(learning_AB_correct,2);
    stdMeanLearning_AB = std(learning_AB_correct,0,2);
    
    meanLearning_CD = mean(learning_CD_correct,2);
    stdMeanLearning_CD = std(learning_CD_correct,0,2);
   
    meanLearning_EF = mean(learning_EF_correct,2);
    stdMeanLearning_EF = std(learning_EF_correct,0,2);
     
    figure
    hold on
    
    graph = plot(1:nBin_pair,meanLearning_AB);
    graph = plot(1:nBin_pair,meanLearning_CD);
    graph = plot(1:nBin_pair,meanLearning_EF);
    
    errorbar(1:nBin,meanLearning_AB,stdMeanLearning_AB,'.');
    errorbar(1:nBin,meanLearning_CD,stdMeanLearning_CD,'.');  
    errorbar(1:nBin,meanLearning_EF,stdMeanLearning_EF,'.');
 
    title('mean learning curves ');
    xticks(1:1:23);
    yticks(0:1:4);
    legend('AB','CD','EF');
    xlabel('bin number');
    ylabel('correct choices (mean )');
    ylim([0 4]);
    
    %saveas(graph,fullfile(resultspath,'learning_curve_graphs','learning-curve-MEAN_All'),'jpg');
    %}
    %%
     save(['accuracy' imodel], 'accuracy', 'accuracy_summary', 'learning_correct');
   
    writetable(accuracy, ['accuracy' imodel '.csv']);
    close all;
      
end