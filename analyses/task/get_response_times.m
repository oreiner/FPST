function get_response_times(imodel)
    %%get all task log files
    cd '[Home Directory]/analyses/task';
    resultspath = '../../results/task';
    cd '../../results/task';
    %%config variables
    maxevents = [276 120 92 40 24 72 32];   %avoid matrix mismatch (from missed events) by setting matrix to max size 
                             %1: learning_total 2: test_total 3: learning_single_cue
                             %4: test_cue       5: test_winwin and loselose
                             %6: test_winlose   7: test_chooseA and test_AvoidB
    letters = {'A','B','C','D','E','F'};
    if not(exist('imodel', 'var'))
        imodel = '_task_results_both_phases_asymmetrical_normal_temperature.mat' ;
    end
    
    %%initialize variables
    %get subjects
    d = dir(resultspath); %get the data for the main directory
    mainIndex = [d.isdir] & [~ismember({d.name}, {'.', '..'})] & [~isnan(str2double({d.name}))]; %find the index of the directories (exclude '.' and '..')
    subjects = {d(mainIndex).name};
   
    
    resp_learning.all = NaN(maxevents(1),numel(subjects));
    resp_test.all     = NaN(maxevents(2),numel(subjects));
    for i = 1:6
        resp_learning.(letters{i}) = NaN(maxevents(3),numel(subjects));
        resp_test.(letters{i})     = NaN(maxevents(4),numel(subjects));
    end
    resp_test.winwin   = NaN(maxevents(5),numel(subjects));
    resp_test.loselose = NaN(maxevents(5),numel(subjects));
    resp_test.winlose  = NaN(maxevents(6),numel(subjects));
    resp_test.chooseA  = NaN(maxevents(7),numel(subjects));
    resp_test.avoidB   = NaN(maxevents(7),numel(subjects));
    
    for iS = 1 : numel(subjects) 
        load(fullfile(subjects{iS},[subjects{iS} imodel]));

        resp_learning.all(1:numel(end_results.onsets(1).resp_duration),iS) = end_results.onsets(1).resp_duration;
        
        %%sort resp_duration per cue
        %cleanup choices so indices line up
        choices_l = end_results.trial.choice(:,1,1);
        choices_l(find(choices_l==0)) = [];
        choices_l(find(choices_l==-9)) = [];
        choices_l(find(isnan(choices_l))) = [];
        for i= 1:6
            
            resps = end_results.onsets(1).resp_duration(find(choices_l==i));
            resp_learning.(letters{i})(1:numel(resps),iS)   = resps;
            %{
             %create graph response per cue
            figure
            hold on
            graph = scatter(1:numel(resp_learning.(letters{i})(:,iS)),resp_learning.(letters{i})(:,iS))
            title(['response speed learn-phase for cue ' letters{i} ' ' subjects{iS} ]);
            %xticks(1:1:23);
            ylim([0 1.8]);
            yticks(0:0.1:1.7); 
            ylabel('secs');
            xlabel('trial');
            saveas(graph,fullfile(resultspath,'response_graphs',['response_learning_cue_' letters{i} '_' subjects{iS}]),'jpg');
            %}
        end
        
        %create graph for response speed in learn-phase   
        %{ 
        figure
        hold on
        graph = bar(1:numel(resp_learning.all(:,iS)),resp_learning.all(:,iS))
        title(['response speed learn-phase ' subjects{iS}]);
        %xticks(1:1:23);
        %yticks(0:1:12);
        ylabel('secs');
         xlabel('trial');
        saveas(graph,fullfile(resultspath,'response_graphs',['response_learnphase_total_' subjects{iS}]),'jpg');
        %} 
        
        if not(strcmp(subjects(iS),'7873')) %no tranfer phase data
            resp_test.all(1:numel(end_results.onsets(2).resp_duration),iS)     = end_results.onsets(2).resp_duration;
            
            %%sort resp_duration per cue
            %cleanup choices so indices line up
            choices_t = end_results.trial.choice(:,1,2);
            choices_t(find(choices_t==0)) = [];
            choices_t(find(choices_t==-9)) = [];
            choices_t(find(isnan(choices_t))) = [];
            
            winwins   = find(not(isnan(end_results.trial.winwin(:,2))));
            resp_test.winwin(1:numel(winwins),iS)     = end_results.onsets(2).resp_duration(winwins);
            
            loseloses = find(not(isnan(end_results.trial.loselose(:,2))));
            resp_test.loselose(1:numel(loseloses),iS)   = end_results.onsets(2).resp_duration(loseloses);
            
            winloses = find(not(isnan(end_results.trial.winlose(1:maxevents(2),2))));
            resp_test.winlose(1:numel(winloses),iS)   = end_results.onsets(2).resp_duration(winloses);
            
            chooseA = find(not(isnan(end_results.trial.choose1(:,2))));
            resp_test.chooseA(1:numel(chooseA),iS)   = end_results.onsets(2).resp_duration(chooseA);
           
            avoidB = find(not(isnan(end_results.trial.avoid2(:,2))));
            resp_test.avoidB(1:numel(avoidB),iS)   = end_results.onsets(2).resp_duration(avoidB);
           
            for i= 1:6
                
                resps = end_results.onsets(2).resp_duration(find(choices_t==i));
                resp_test.(letters{i})(1:numel(resps),iS)   = resps;
                %{
                %create graph response per cue
                figure
                hold on
                graph = scatter(1:numel(resp_test.(letters{i})(:,iS)),resp_test.(letters{i})(:,iS))
                title(['response speed test-phase for cue ' letters{i} ' ' subjects{iS} ]);
                %xticks(1:1:23);
                ylim([0 1.8]);
                yticks(0:0.1:1.7); 
                ylabel('secs');
                xlabel('trial');
                saveas(graph,fullfile(resultspath,'response_graphs',['response_test_cue_' letters{i} '_' subjects{iS}]),'jpg');
                %}
            end
            %{
            %create graph response for win-win scenarios
            figure
            hold on
            graph = scatter(1:numel(resp_test.winwin(:,iS)),resp_test.winwin(:,iS))
            title(['response speed test-phase for win-win scenarios' subjects{iS} ]);
            %xticks(1:1:23);
            ylim([0 1.8]);
            yticks(0:0.1:1.7); 
            ylabel('secs');
            xlabel('trial');
            saveas(graph,fullfile(resultspath,'response_graphs',['response_test_winwin_' subjects{iS}]),'jpg');
            %create graph response for lose-lose scenarios
            figure
            hold on
            graph = scatter(1:numel(resp_test.loselose(:,iS)),resp_test.loselose(:,iS))
            title(['response speed test-phase for lose-lose scenarios' subjects{iS} ]);
            %xticks(1:1:23);
            ylim([0 1.8]);
            yticks(0:0.1:1.7); 
            ylabel('secs');
            xlabel('trial');
            saveas(graph,fullfile(resultspath,'response_graphs',['response_test_loselose_' subjects{iS}]),'jpg');
            %create graph response for win-lose scenarios ("non-intereseting events")
            figure
            hold on
            graph = scatter(1:numel(resp_test.winlose(:,iS)),resp_test.winlose(:,iS))
            title(['response speed test-phase for win-lose scenarios' subjects{iS} ]);
            %xticks(1:1:23);
            ylim([0 1.8]);
            yticks(0:0.1:1.7); 
            ylabel('secs');
            xlabel('trial');
            saveas(graph,fullfile(resultspath,'response_graphs',['response_test_winlose_' subjects{iS}]),'jpg');
            %}
            %{ 
            %create graph response for choose A scenarios
            figure
            hold on
            graph = scatter(1:numel(resp_test.chooseA(:,iS)),resp_test.chooseA(:,iS))
            title(['response speed test-phase for choose A scenarios' subjects{iS} ]);
            %xticks(1:1:23);
            ylim([0 1.8]);
            yticks(0:0.1:1.7); 
            ylabel('secs');
            xlabel('trial');
            saveas(graph,fullfile(resultspath,'response_graphs',['response_test_chooseA_' subjects{iS}]),'jpg');
            %create graph response for Avoid B scenarios
            figure
            hold on
            graph = scatter(1:numel(resp_test.avoidB(:,iS)),resp_test.avoidB(:,iS))
            title(['response speed test-phase for lose-lose scenarios' subjects{iS} ]);
            %xticks(1:1:23);
            ylim([0 1.8]);
            yticks(0:0.1:1.7); 
            ylabel('secs');
            xlabel('trial');
            saveas(graph,fullfile(resultspath,'response_graphs',['response_test_avoidB_' subjects{iS}]),'jpg');
            %} 
            %create graph for response speed in test-phase  
            %{ 
            figure
            hold on
            graph = bar(1:numel(resp_test.all(:,iS)),resp_test.all(:,iS))
            title(['response speed test-phase ' subjects{iS}]);
            %xticks(1:1:23);
            %yticks(0:1:12); 
            ylabel('secs');
            xlabel('trial');
            saveas(graph,fullfile(resultspath,'response_graphs',['response_test_total_' subjects{iS}]),'jpg');
            %} 
        else  %7873 exception no tranfer phase data
           
       
        end
        close all;
        
    end
        
    %%figures mean response curves
     %{
    meanLearning = nanmean(resp_learning.all,2);
    stdMeanLearning = nanstd(resp_learning.all,0,2);
    figure
    hold on
    graph = scatter(1:maxevents(1),meanLearning)
    errorbar(1:maxevents(1),meanLearning,stdMeanLearning,'.');
    title('mean response for learn-phase');
    ylabel('secs');
    xlabel('trial');
    %xticks(1:1:23);
    %yticks(0:1:12);
    saveas(graph,fullfile(resultspath,'response_graphs','means','response_learnphase_MEAN_total'),'jpg');
     
    meanTest = nanmean(resp_test.all,2);
    stdMeanTest = nanstd(resp_test.all,0,2);
    figure
    hold on
    graph = scatter(1:maxevents(2),meanTest)
    errorbar(1:maxevents(2),meanTest,stdMeanTest,'.');
    title('mean response for test-phase');
    ylabel('secs');
    xlabel('trial');
    %xticks(1:1:23);
    %yticks(0:1:12);
    saveas(graph,fullfile(resultspath,'response_graphs','means','response_testphase_MEAN_total'),'jpg');
     %}

    %%individual cue figures
    %{
    for i=1:6
        meanLearning_cue(:,i) = nanmean(resp_learning.(letters{i}),2);
        stdMeanLearning_cue(:,i) = nanstd(resp_learning.(letters{i}),0,2);
        figure
        hold on
        graph = scatter(1:maxevents(3),meanLearning_cue(:,i))
        errorbar(1:maxevents(3),meanLearning_cue(:,i),stdMeanLearning_cue(:,i),'.');
        title(['response time for learn-phase for cue ' letters{i}]);
        ylabel('secs');
        xlabel('trial');
        %xticks(1:1:23);
        ylim([0 1.8]);
        yticks(0:0.1:1.7);
        saveas(graph,fullfile(resultspath,'response_graphs','means',['response_learnphase_MEAN_' letters{i}]),'jpg');
        close all;
    end
    %graph for total cue with all cues on one figure
    graph = figure
    hold on
    title('mean response for all cues in learn phase');
    boxplot(meanLearning_cue,'Labels',{'A','B','C','D','E','F'})
    ylabel('secs');
    xlabel('Cue');
    ylim([0 1.8]);
    yticks(0:0.1:1.7);
    saveas(graph,fullfile(resultspath,'response_graphs','means','response_learnphase_ALL_CUES'),'jpg');
    

    for i=1:6
        meanTest_cue(:,i) = nanmean(resp_test.(letters{i}),2);
        stdMeanTest_cue(:,i) = nanstd(resp_test.(letters{i}),0,2);
        figure
        hold on
        graph = scatter(1:maxevents(4),meanTest_cue(:,i))
        errorbar(1:maxevents(4),meanTest_cue(:,i),stdMeanTest_cue(:,i),'.');
        title(['mean response for test-phase for cue ' letters{i}]);
        ylabel('secs');
        xlabel('trial');
        %xticks(1:1:23);
        ylim([0 1.8]);
        yticks(0:0.1:1.7);
        saveas(graph,fullfile(resultspath,'response_graphs','means',['response_testphase_MEAN_' letters{i}]),'jpg');
        close all;
    end

    graph = figure
    hold on
    title('response time for all cues in test phase');
    ylabel('secs');
    xlabel('Cue');
    boxplot(meanTest_cue,'Labels',{'A','B','C','D','E','F'})
    ylim([0 1.8]);
    yticks(0:0.1:1.7);
    saveas(graph,fullfile(resultspath,'response_graphs','means','response_testphase_ALL_CUES'),'jpg');
 %}
%{ 
    %%mean winwin loselose winlose graphs
    meanWinWin = nanmean(resp_test.winwin,2);
    stdMeanWinWin = nanstd(resp_test.winwin,0,2);
    figure
    hold on
    graph = scatter(1:maxevents(5),meanWinWin)
    errorbar(1:maxevents(5),meanWinWin,stdMeanWinWin,'.');
    title('mean response for win-win scenarios');
    ylabel('secs');
    xlabel('trial');
    %xticks(1:1:23);
    ylim([0 1.8]);
    yticks(0:0.1:1.7);
    saveas(graph,fullfile(resultspath,'response_graphs','means','response_testphase_MEAN_WINWIN'),'jpg');
    close all;
    
    meanLoseLose = nanmean(resp_test.loselose,2);
    stdMeanLoseLose = nanstd(resp_test.loselose,0,2);
    figure
    hold on
    graph = scatter(1:maxevents(5),meanLoseLose)
    errorbar(1:maxevents(5),meanLoseLose,stdMeanLoseLose,'.');
    title('mean response for lose-lose scenarios');
    ylabel('secs');
    xlabel('trial');
    %xticks(1:1:23);
    ylim([0 1.8]);
    yticks(0:0.1:1.7);
    saveas(graph,fullfile(resultspath,'response_graphs','means','response_testphase_MEAN_LOSELOSE'),'jpg');
    close all;
    
    meanWinLose = nanmean(resp_test.winlose,2);
    stdMeanWinLose = nanstd(resp_test.winlose,0,2);
    figure
    hold on
    graph = scatter(1:maxevents(6),meanWinLose)
    errorbar(1:maxevents(6),meanWinLose,stdMeanWinLose,'.');
    title('mean response for win-lose ("non-interesting") scenarios');
    ylabel('secs');
    xlabel('trial');
    %xticks(1:1:23);
    ylim([0 1.8]);
    yticks(0:0.1:1.7);
    saveas(graph,fullfile(resultspath,'response_graphs','means','response_testphase_MEAN_WINLOSE'),'jpg');
    close all;
    
    col=@(x)reshape(x,numel(x),1);
    boxplot_smart=@(C,varargin)boxplot(cell2mat(cellfun(col,col(C),'uni',0)),cell2mat(arrayfun(@(I)I*ones(numel(C{I}),1),col(1:numel(C)),'uni',0)),varargin{:});
    %graph high conflict scenarios together
    graph = figure
    hold on
    title('response time for high and low conflict scenarios in test phase');
    ylabel('secs');
    xlabel('conflict type');
    boxplot_smart({meanWinWin, meanLoseLose, meanWinLose},'Labels',{'win-win','lose-lose','win-lose'})
    ylim([0 1.8]);
    yticks(0:0.1:1.7);
    saveas(graph,fullfile(resultspath,'response_graphs','means','response_testphase_ALL_CONFLICTS'),'jpg');
%}
    %{ 
    %%mean Choose A Avoid B graphs
    meanChooseA = nanmean(resp_test.chooseA,2);
    stdMeanChooseA = nanstd(resp_test.chooseA,0,2);
    figure
    hold on
    graph = scatter(1:maxevents(7),meanChooseA)
    errorbar(1:maxevents(7),meanChooseA,stdMeanChooseA,'.');
    title('mean response for choose A scenarios');
    ylabel('secs');
    xlabel('trial');
    %xticks(1:1:23);
    ylim([0 1.8]);
    yticks(0:0.1:1.7);
    saveas(graph,fullfile(resultspath,'response_graphs','means','response_testphase_MEAN_CHOOSEA'),'jpg');
    close all;
    
    meanAvoidB = nanmean(resp_test.avoidB,2);
    stdMeanAvoidB = nanstd(resp_test.avoidB,0,2);
    figure
    hold on
    graph = scatter(1:maxevents(7),meanAvoidB)
    errorbar(1:maxevents(7),meanAvoidB,stdMeanAvoidB,'.');
    title('mean response for avoid B scenarios');
    ylabel('secs');
    xlabel('trial');
    %xticks(1:1:23);
    ylim([0 1.8]);
    yticks(0:0.1:1.7);
    saveas(graph,fullfile(resultspath,'response_graphs','means','response_testphase_MEAN_AVOIDB'),'jpg');
    close all;
    
    
    col=@(x)reshape(x,numel(x),1);
    boxplot_smart=@(C,varargin)boxplot(cell2mat(cellfun(col,col(C),'uni',0)),cell2mat(arrayfun(@(I)I*ones(numel(C{I}),1),col(1:numel(C)),'uni',0)),varargin{:});
    %graph high conflict scenarios together
    graph = figure
    hold on
    title('response time for high and low conflict scenarios in test phase');
    ylabel('secs');
    xlabel('conflict type');
    boxplot_smart({meanChooseA, meanAvoidB},'Labels',{'choose A','Avoid B'})
    ylim([0 1.8]);
    yticks(0:0.1:1.7);
    saveas(graph,fullfile(resultspath,'response_graphs','means','response_testphase_CHOOSEAVOID'),'jpg');
    %} 
    
    %cues_median_learning = nanmedian(meanLearning_cue);
    %cues_median_test = nanmedian(meanTest_cue);
    
    %%create response times table
    v2mean = @ (v)[v' ; nanmean(v) ] ; %anonymous function to add mean line. note unlike in get_accuracy transverses column
    responses = table([subjects'; 'mean']  , ...
                     v2mean(nanmean(resp_learning.all)), ...
                     v2mean(nanmean(resp_learning.A)), v2mean(nanmean(resp_learning.B)), v2mean(nanmean(resp_learning.C)), v2mean(nanmean(resp_learning.D)), v2mean(nanmean(resp_learning.E)), v2mean(nanmean(resp_learning.F)), ...
                     v2mean(nanmean(resp_test.all)), ...
                     v2mean(nanmean(resp_test.A)), v2mean(nanmean(resp_test.B)), v2mean(nanmean(resp_test.C)), v2mean(nanmean(resp_test.D)), v2mean(nanmean(resp_test.E)), v2mean(nanmean(resp_test.F)), ...
                     v2mean(nanmean(resp_test.winwin)), v2mean(nanmean(resp_test.loselose)), v2mean(nanmean(resp_test.winlose)), v2mean(nanmean(resp_test.chooseA)), v2mean(nanmean(resp_test.avoidB)) ...             
                 );
    responses.Properties.VariableNames = {'Subject', ...
                                          'mean_response_time_learning_total', ...
                                          'mean_response_time_learning_A','mean_response_time_learning_B', 'mean_response_time_learning_C','mean_response_time_learning_D','mean_response_time_learning_E', 'mean_response_time_learning_F',  ...
                                          'mean_response_time_test_total', ...
                                          'mean_response_time_test_A','mean_response_time_test_B', 'mean_response_time_test_C','mean_response_time_test_D','mean_response_time_test_E', 'mean_response_time_test_F',  ...
                                           'mean_response_time_test_winwin','mean_response_time_test_loselose', 'mean_response_time_test_winlose','mean_response_time_test_chooseA','mean_response_time_test_avoidB' ...
                                          }; 
    responses_summary = summary(responses);
    
    save(['response' imodel], 'responses', 'responses_summary', 'resp_learning', 'resp_test');
    writetable(responses, 'responses.csv');
    close all;
      
end