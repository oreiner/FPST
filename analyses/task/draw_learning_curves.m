%% calculate and draw cumulative accuracy and state-action value learning curves. Mean and individual

function draw_learning_curves(imodel)
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
  
    if not(exist('imodel', 'var'))
        %imodel = '_task_results_both_phases_asymmetrical_normal_temperature' ;
        imodel = '_task_results_both_phases_asymmetrical_normal_temperature_priorX0_0.5_binSize_1' ;
        binSize=1;
    end
    
    if not(exist('binSize', 'var'))
        binSize = 4 ;
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
    %matrix for SAV
    Actionvalues = nan(276,numel(subjects),6);   
        

    for iS = 1 : numel(subjects) 
        load(fullfile(subjects{iS},[subjects{iS} imodel '.mat']));

      
        %%get accuracies 
		%skips NaNs (missed events). consider counting them as zeros (requires changing format_data_test)
		%reconsidered. changed NaNs to zeros because this makes dividing bins easier.
        
        %% recount bins to get bins of 6 instead of 12
        %needed to recreate missed_events from format_test_phase because I didn't save it into the results
        A1 = nonzeros(end_results.trial.cue(:,1,1));
        A2 = nonzeros(end_results.trial.cue(:,2,1));
        Bb = nonzeros(end_results.trial.choice(:, 1, 1));
        missed_events = find(Bb==-9);
        
        [end_results.trial.correct_bins.all] = count_bins(end_results.trial.winlose(:,1), missed_events, binSize)'; %winlose in block 1 are all the pairs
        close; %close the VBA-Toolbox thing
        
        nBin = numel(end_results.trial.correct_bins.all(:,1));
        learning_correct(:,iS) = end_results.trial.correct_bins.all(:,1); 
        
        %split by bins. I need a stupid workaeround because I anaylsed the
        %events with fixed bins of 4 and lost track of info, like who the
        %missed events belong to
        %first change missed events to zero, then remove NAN 
        %[end_results.trial.correct_bins.AB_custombin] = count_bins(end_results.trial.AB(:,1), missed_events, binSize)'; %winlose in block 1 are all the pairs
        
        
        %this is somehow based on the original end_results analysis and not
        %the count_bins which makes not useful for non 4 bins?
        nBin_pair = numel(end_results.trial.correct_bins.AB(:,1));
        
        learning_AB_correct(:,iS) = end_results.trial.correct_bins.AB(:,1); 
        learning_CD_correct(:,iS) = end_results.trial.correct_bins.CD(:,1); 
        learning_EF_correct(:,iS) = end_results.trial.correct_bins.EF(:,1); 
        
        
        AB = nansum(end_results.trial.AB);  
        CD = nansum(end_results.trial.CD);
        EF = nansum(end_results.trial.EF);

        
        
        %%create bin graphs for learning curve 
 
            %{
         %}
        %saveas(graph,fullfile(resultspath,'learning_curve_graphs','plots',['learning-curve_total_' subjects{iS}]),'jpg');
         %{
        
        either remove fine bins (6 instead of 12) from above or add to path below
        
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
        hold off %hold off for individual plots
        
        %% get Action values - unlike accuracy, this is model dependent!
        %initialize the ReducedActionValues matrix
        %ReducedAV = NaN(npairs(1),numel(subjects),6);
        for iCue=1:6
            %not all subjects played all 276 trials in learning phase, so I
            %need to get filter the test phase in a differnetial way.
            %num of rows of winlose for learning phase is all of them 
            lastBin = size(end_results.trial.winlose,1);
            Actionvalues(1:lastBin,iS,iCue) = (posterior.muX(iCue,1:lastBin))';
            %remove duplicate AV, assuming these are trials were Cue was
            %not chosen, either because it was a different pair, OR:
            %this also excludes trials which had the Cue shown and
            %wasn't chosen. Don't I want those trials too?
            duplicateAV = [false posterior.muX(iCue,2:lastBin) == posterior.muX(iCue,1:lastBin-1)];
            testPhaseBins = size(posterior.muX,2)-lastBin;
            duplicateAV = [duplicateAV ones(1,testPhaseBins)];%padding with ones, so the values from the test phase won't be taken
            uniques = posterior.muX(iCue,~duplicateAV(1:92));
            ReducedAV(1:numel(uniques),iS,iCue) = uniques;
            ReducedAV(find(ReducedAV==0))= NaN;
            
        end
    end
    
    close all; %close all because there's a strange ghost figure appearing
    
    %% color scheme
    GrayColorOrder = [0,0,0 ; 0.2,0.2,0.2 ; 0.3,0.3,0.3 ; 0.35,0.35,0.35 ; 0.4,0.4,0.4 ; 0.45,0.45,0.45 ; 0.5,0.5,0.5 ; 0.55,0.55,0.55 ; 0.6,0.6,0.6 ; 0.65,0.65,0.65 ; 0.7,0.7,0.7  ; 0,0,0]; %[(ones(3,10).*(0.0:0.1:0.9))'];
    BlueColorOrder = [0,0,0 ; 0,0,0.2 ; 0,0,0.3 ; 0,0,0.4 ; 0,0,0.5 ; 0,0,0.55 ; 0,0,0.6 ; 0,0,0.65 ; 0,0,0.7 ; 0,0,0.75 ; 0,0,0.8 ; 0,0,0.9 ; 0,0,0 ];
    BrightColorOrder = [0,0,0 ; 51,34,136 ; 102,204, 238 ; 68,170,153 ; 34,136,51 ; 150,120,40 ; 201,184,99 ; 238,102,119 ; 136,34,85 ; 170,68,153 ; 120,120,120 ; 0,0,0 ]/256;
    
    CustomColorOrder = BrightColorOrder; colorname = '_bright';
    %CustomColorOrder = BlueColorOrder; colorname = '_blues';
    %CustomColorOrder = GrayColorOrder; colorname = '_grayscale';

    %save files in multiple extensions = png, svg, fig
    extensions ={'png','fig','svg'};
    %stopped working with fig for whatever reason
       extensions ={'png','svg'};
  %% figures for action values
    cuenames = ['A','B','C','D','E','F'];
    meanAV = mean(Actionvalues,2);
    stdAV = std(Actionvalues,0,2);
    stdAVtop = (meanAV + stdAV);
    stdAVbottom = (meanAV - stdAV); 
    x1AV = 1:size(Actionvalues,1);
    x2AV = [x1AV, fliplr(x1AV)]; %for gray std fill
    x2stairsAV = repmat(x2AV',1,2); x2stairsAV =reshape(x2stairsAV',1,numel(x2stairsAV)); x2stairsAV = horzcat(x2stairsAV,x2stairsAV(end),x2stairsAV(end)); %for stairs std fill
    %AV for presented cues
    formattedAV = format_actionvalue_learningcurve(subjects,imodel);
    meanAVpres = mean(formattedAV,2);
    stdAVpres = std(formattedAV,0,2);
    stdAVtoppres = (meanAVpres + stdAVpres);
    stdAVbottompres = (meanAVpres - stdAVpres); 
    x1AVpres = 1:size(formattedAV,1);
    x2AVpres = [x1AVpres, fliplr(x1AVpres)]; %for gray std fill
    x2stairsAVpres = repmat(x2AVpres',1,2); x2stairsAVpres =reshape(x2stairsAVpres',1,numel(x2stairsAVpres)); x2stairsAVpres = horzcat(x2stairsAVpres,x2stairsAVpres(end),x2stairsAVpres(end)); %for stairs std fill
    
    
    %AV shown across all trials 
    %{
    for iCue=1:6 
        %if mod(iCue,2)
            figure;
        %end
        hold on;
        title (['state-action value for cue ' cuenames(iCue)]);
        set(gca, 'ColorOrder', CustomColorOrder); 
        yticks(0:0.1:1);
        ylim([0 1.02]);
        xlabel("trials");xlim([0 276]);
        ylabel("state-action value");
        stdAVinbetween = min([stdAVtop(:,:,iCue); flip(stdAVbottom(:,:,iCue))],100); stdAVinbetween = max(stdAVinbetween,0);
        stdAVinbetweenStairs = repmat(stdAVinbetween,1,2); stdAVinbetweenStairs = reshape(stdAVinbetweenStairs',1, numel(stdAVinbetweenStairs)); stdAVinbetweenStairs = horzcat(stdAVinbetweenStairs(end),stdAVinbetweenStairs,stdAVinbetweenStairs(end));%format for stairs polygen fill SD
        stdgraph = fill(x2stairsAV, stdAVinbetweenStairs, [0.8 0.8 0.8], 'edgeColor', [0.75 0.75 0.75]);
        for iS = 1 : numel(subjects)  
             graph = stairs(1:numel(Actionvalues(:,1,1)), Actionvalues(:,iS,iCue));
        end   
        meangraph = stairs(1:numel(Actionvalues(:,1,1)), meanAV(:,:,iCue))
        meangraph.LineWidth=3;
        %if not(mod(iCue,2))
            hold off;
        %end
    %need to update save path, see presented AV below
        saveas(graph,fullfile(resultspath,'learning_curve_graphs','AV',['AV_learning_curves_' cuenames(iCue) '_long' colorname ] ),'png');
    end
    
    %only AV changes shown
    for iCue=1:6
        %if mod(iCue,2)
            figure;
        %end
        hold on;
        title (['state-action value for cue ' cuenames(iCue)]);
        yticks(0:0.1:1);
        ylim([0 1.02]);
        xlabel("trials");%xlim([0 92]);
        ylabel("state-action value");
        set(gca, 'ColorOrder', CustomColorOrder(2:end,:)); %skip black
        for iS = 1 : numel(subjects)  
             graph = stairs(1:numel(ReducedAV(:,1,1)), ReducedAV(:,iS,iCue));
        end   
        %if not(mod(iCue,2))
            hold off;
        %end
      %need to update save path, see presented AV below
        saveas(graph,fullfile(resultspath,'learning_curve_graphs','AV',['AV_learning_curves_' cuenames(iCue) '_reduced' colorname ] ),'png');
    end
    %}
     %AV for presented cues  
     %create folder for saved files
     modelnameshort = extractAfter(imodel,'_task_results_');
     if not(exist(fullfile(resultspath,'learning_curve_graphs','AV',modelnameshort), 'dir'))
         mkdir(fullfile(resultspath,'learning_curve_graphs','AV',modelnameshort));
     end
     for iCue=1:6
        %if mod(iCue,2)
            figure;
        %end
        hold on;
        title (['state-action value for cue ' cuenames(iCue)]);
        yticks(0:0.1:1);
        ylim([0 1.02]);
        xlabel("trials");xlim([0 92]);
        ylabel("state-action value");
        set(gca, 'ColorOrder', CustomColorOrder); 
        %set(gca, 'ColorOrder', CustomColorOrder(2:end,:)); %skip black if no mean
        stdAVinbetweenpres = min([stdAVtoppres(:,:,iCue); flip(stdAVbottompres(:,:,iCue))],100); stdAVinbetweenpres = max(stdAVinbetweenpres,0);
        stdAVinbetweenStairspres = repmat(stdAVinbetweenpres,1,2); stdAVinbetweenStairspres = reshape(stdAVinbetweenStairspres',1, numel(stdAVinbetweenStairspres)); stdAVinbetweenStairspres = horzcat(stdAVinbetweenStairspres(end),stdAVinbetweenStairspres,stdAVinbetweenStairspres(end));%format for stairs polygen fill SD
        stdgraph = fill(x2stairsAVpres, stdAVinbetweenStairspres, [0.8 0.8 0.8], 'edgeColor', [0.75 0.75 0.75]);  
        for iS = 1 : numel(subjects)  
             graph = stairs(1:numel(formattedAV(:,1,1)), formattedAV(:,iS,iCue));
        end  
        meangraph = stairs(1:numel(formattedAV(:,1,1)), meanAVpres(:,:,iCue));
        meangraph.LineWidth=3; 
        %if not(mod(iCue,2))
            hold off;
        %end
        for ext = 1:length(extensions)
            saveas(graph,fullfile(resultspath,'learning_curve_graphs','AV', modelnameshort,['AV_learning_curves_' imodel '_' cuenames(iCue) '_presented' colorname ] ),extensions{ext});
        end
    end
    
    close all;
    
    
    
    
    %calculations for individual cumulative plots
    cumsum_AB = cumsum(learning_AB_correct);
    cumsum_CD = cumsum(learning_CD_correct);
    cumsum_EF = cumsum(learning_EF_correct);
    cumbin = transpose([binSize:binSize:npairs(1)]);
    x1 = 1:nBin_pair;
    x2 = [x1, fliplr(x1)]; %for gray std fill
    x2stairs = repmat(x2',1,2); x2stairs =reshape(x2stairs',1,numel(x2stairs)); x2stairs = horzcat(x2stairs,x2stairs(end),x2stairs(end)); %for stairs std fill
    
    %calculations for cumulative mean plots
    meanAB = mean(learning_AB_correct,2);
    stdAB = std(learning_AB_correct,0,2);
    semAB = stdAB/sqrt(numel(stdAB));
     
    meanCD = mean(learning_CD_correct,2);
    stdCD = std(learning_CD_correct,0,2);
    semCD = stdCD/sqrt(numel(stdCD));
       
    meanEF = mean(learning_EF_correct,2);
    stdEF = std(learning_EF_correct,0,2);
    semEF = stdEF/sqrt(numel(stdEF));
    
    cumaccuracyAB = 100*cumsum_AB./cumbin;
    cummeanAB = mean(cumaccuracyAB,2);
    cumstdAB = std(cumaccuracyAB,0,2);
    ABtop = (cummeanAB + cumstdAB);
    ABbottom = (cummeanAB - cumstdAB);
    ABinbetween = min([ABtop; flip(ABbottom)],100); ABinbetween = max(ABinbetween,0); %calculate SD but limit it between 0% and 100%
    ABinbetweenStairs = repmat(ABinbetween,1,2); ABinbetweenStairs = reshape(ABinbetweenStairs',1, numel(ABinbetweenStairs)); ABinbetweenStairs = horzcat(ABinbetweenStairs(end),ABinbetweenStairs,ABinbetweenStairs(end));%format for stairs polygen fill SD
    
    cumaccuracyCD = 100*cumsum_CD./cumbin;
    cummeanCD = mean(cumaccuracyCD,2);
    cumstdCD = std(cumaccuracyCD,0,2);
    CDtop = (cummeanCD + cumstdCD);
    CDbottom = (cummeanCD - cumstdCD);
    CDinbetween = min([CDtop; flip(CDbottom)],100); CDinbetween = max(CDinbetween,0); %calculate SD but limit it between 0% and 100%
    CDinbetweenStairs = repmat(CDinbetween,1,2); CDinbetweenStairs = reshape(CDinbetweenStairs',1, numel(CDinbetweenStairs)); CDinbetweenStairs = horzcat(CDinbetweenStairs(end),CDinbetweenStairs,CDinbetweenStairs(end));%format for stairs polygen fill SD
     
    cumaccuracyEF = 100*cumsum_EF./cumbin;
    cummeanEF = mean(cumaccuracyEF,2);
    cumstdEF = std(cumaccuracyEF,0,2);
    EFtop = (cummeanEF + cumstdEF);
    EFbottom = (cummeanEF - cumstdEF);
    EFinbetween = min([EFtop; flip(EFbottom)],100); EFinbetween = max(EFinbetween,0); %calculate SD but limit it between 0% and 100%
    EFinbetweenStairs = repmat(EFinbetween,1,2); EFinbetweenStairs = reshape(EFinbetweenStairs',1, numel(EFinbetweenStairs)); EFinbetweenStairs = horzcat(EFinbetweenStairs(end),EFinbetweenStairs,EFinbetweenStairs(end));%format for stairs polygen fill SD
    
    
    %% individual cumulative sum plots
    hold off
    figure
    hold on
    title('individual learning curves A-B pairs')
    set(gca, 'ColorOrder', CustomColorOrder); 
    %yticks(0:1:binSize);
    yticks(0:10:100);
    ylim([0 101]);
    xlabel("trials");xlim([0 npairs(1)]);
    %xlabel("bins");xlim([0 npairs(1)]); 
    ylabel("cumulative accuracy (%)");
    %add cumulative mean
        fill(x2stairs, ABinbetweenStairs, [0.8 0.8 0.8], 'edgeColor', [0.75 0.75 0.75]);
        %fill(x2, ABinbetween, [0.8 0.8 0.8], 'edgeColor', [0.75 0.75 0.75]);  
            %legend('SD mean A-B','mean A-B','1','2','3','4','5','6','7','8','9','10');
    for iS = 1 : numel(subjects)  
         graph = stairs(x1, 100*cumsum_AB(:,iS)./cumbin);
         %graph.LineWidth = 2;
         %graph = plot(x1, 100*cumsum_AB(:,iS)./cumbin);
    end  
     meangraph = stairs(x1, cummeanAB);
        %meangraph = plot(x1, cummeanAB);
        meangraph.LineWidth=3;
   for ext = 1:length(extensions)
        saveas(graph,fullfile(resultspath,'learning_curve_graphs','cumulative',['cumulative_learning_curves_AB_stairs_binSize_' num2str(binSize) colorname ] ),extensions{ext});
   end
   hold off %hold off without the first onefor merged plot
    
    figure
    hold on
    title('individual learning curves C-D pairs')
    set(gca, 'ColorOrder', CustomColorOrder); 
    %yticks(0:1:binSize);
    yticks(0:10:100);
    ylim([0 101]);
    xlabel("trials");xlim([0 npairs(1)]);
    %xlabel("bins");xlim([0 npairs(1)]); 
    ylabel("cumulative accuracy (%)");
    %add cumulative mean
        fill(x2stairs, CDinbetweenStairs, [0.8 0.8 0.8], 'edgeColor', [0.75 0.75 0.75]);
        %fill(x2, CDinbetween, [0.8 0.8 0.8]);
        
        %legend('SD mean C-D','mean C-D','1','2','3','4','5','6','7','8','9','10');
     for iS = 1 : numel(subjects)  
         %graph = plot(x1, 100*cumsum_CD(:,iS)./cumbin);
         graph = stairs(x1, 100*cumsum_CD(:,iS)./cumbin);
     end    
     meangraph = stairs(x1, cummeanCD);
        %meangraph = plot(x1, cummeanCD);
        meangraph.LineWidth=3;
    for ext = 1:length(extensions)
        saveas(graph,fullfile(resultspath,'learning_curve_graphs','cumulative',['cumulative_learning_curves_CD_stairs_binSize_' num2str(binSize) colorname ] ),extensions{ext});
    end
    hold off %hold off without the first onefor merged plot
    
    figure
    hold on
    title('individual learning curves E-F pairs')
    set(gca, 'ColorOrder', CustomColorOrder); 
    %yticks(0:1:binSize);
    yticks(0:10:100);
    ylim([0 101]);
    xlabel("trials");xlim([0 npairs(1)]);
    %xlabel("bins");xlim([0 npairs(1)]); 
    ylabel("cumulative accuracy (%)");
    %add cumulative mean
        fill(x2stairs, EFinbetweenStairs, [0.8 0.8 0.8], 'edgeColor', [0.75 0.75 0.75]);
        %fill(x2, EFinbetween, [0.8 0.8 0.8]);  
         %legend('SD mean E-F','mean E-F','1','2','3','4','5','6','7','8','9','10');
    for iS = 1 : numel(subjects)  
         %graph = plot(x1, 100*cumsum_EF(:,iS)./cumbin);
         graph = stairs(x1, 100*cumsum_EF(:,iS)./cumbin);     
    end   
    meangraph = stairs(x1, cummeanEF);
        %meangraph = plot(x1, cummeanEF);
        meangraph.LineWidth=3;
    for ext = 1:length(extensions)
       saveas(graph,fullfile(resultspath,'learning_curve_graphs','cumulative',['cumulative_learning_curves_EF_stairs_binSize_' num2str(binSize) colorname ] ),extensions{ext});
    end
    hold off %hold off without the first onefor merged plot
     
    %cumulative mean learning curve for each pair
    
    figure
    hold on
    title('mean learning curve A-B pairs')
    set(gca, 'ColorOrder', CustomColorOrder); 
     %yticks(0:1:binSize);
   yticks(0:10:100);
    ylim([0 101]);
    xlabel("trials");xlim([0 npairs(1)]);
    %xlabel("bins");xlim([0 npairs(1)]); 
    ylabel("cumulative accuracy (%)");
    fill(x2, ABinbetween, [0.8 0.8 0.8], 'edgeColor', [0.75 0.75 0.75]); 
    graph = plot(x1, cummeanAB);  
    graph.LineWidth=3;
    for ext = 1:length(extensions)
        saveas(graph,fullfile(resultspath,'learning_curve_graphs','cumulative',['cumulative_mean_learning_curve_AB_binSize_' num2str(binSize) colorname ] ),extensions{ext});
    end
    hold off %hold off without the first onefor merged plot
 
    figure
    hold on
    title('mean learning curve C-D pairs')
    set(gca, 'ColorOrder', CustomColorOrder); 
    %yticks(0:1:binSize);  
    yticks(0:10:100);
    ylim([0 101]);
    xlabel("trials");xlim([0 npairs(1)]);
    %xlabel("bins");xlim([0 npairs(1)]); 
    ylabel("cumulative accuracy (%)");
    fill(x2, CDinbetween, [0.8 0.8 0.8], 'edgeColor', [0.75 0.75 0.75]); 
    graph = plot(x1, cummeanCD);    
    graph.LineWidth=3;
    for ext = 1:length(extensions)
        saveas(graph,fullfile(resultspath,'learning_curve_graphs','cumulative',['cumulative_mean_learning_curve_CD_binSize_' num2str(binSize) colorname ] ),extensions{ext});
    end
    hold off %hold off without the first onefor merged plot
 
    figure
    hold on
    title('mean learning curve E-F pairs')
    set(gca, 'ColorOrder', CustomColorOrder); 
    %yticks(0:1:binSize);  
    yticks(0:10:100);
    ylim([0 101]);
    xlabel("trials");xlim([0 npairs(1)]);
    %xlabel("bins");xlim([0 npairs(1)]); 
    ylabel("cumulative accuracy (%)");
    fill(x2, EFinbetween, [0.8 0.8 0.8], 'edgeColor', [0.75 0.75 0.75]); 
    graph = plot(x1, cummeanEF);  
    graph.LineWidth=3;
    for ext = 1:length(extensions)
        saveas(graph,fullfile(resultspath,'learning_curve_graphs','cumulative',['cumulative_mean_learning_curve_EF_binSize_' num2str(binSize) colorname] ),extensions{ext});
    end
    hold off %hold off without the first onefor merged plot
 
    
    
    
             
    y = [meanAB , meanCD , meanEF];
    sem =  [semAB , semCD , semEF];
    
    
    
       %%merged plot with all individual plots
    %{
    figure
    hold on
    title('individual learning curves A-B pairs');
    xticks(1:1:npairs(1)/binSize);
    yticks(0:1:binSize);
    for iS = 1 : numel(subjects)  
         graph = plot(1:nBin_pair,learning_AB_correct(:,iS));
    end     
    hold off %hold off without the first onefor merged plot
    
    figure
    hold on
    title('individual learning curves C-D pairs');
    xticks(1:1:npairs(1)/binSize);
    yticks(0:1:binSize);
    for iS = 1 : numel(subjects)  
         graph = plot(1:nBin_pair,learning_CD_correct(:,iS));
    end     
    hold off %hold off without the first onefor merged plot
    
    figure
    hold on
    title('individual learning curves E-F pairs');
    xticks(1:1:npairs(1)/binSize);
    yticks(0:1:binSize);
    for iS = 1 : numel(subjects)  
         graph = plot(1:nBin_pair,learning_EF_correct(:,iS));
    end     
    hold off %hold off without the first onefor merged plot
    %}
    
  
    
    %{
    %stackd version
    figure
    hold on
    graph = bar(1:size(meanAB,1),y, 'stack');
    errorbar(cumsum(y')',sem,'.k');
    %title('mean learning curve');
    legend('A-B pairs', 'C-D pairs', 'E-F pairs')
    xticks(1:1:276/binSize);
    yticks(0:1:binSize);
    ylabel(['correct choices per bin (mean' char(177) 'SEM)']);
    %saveas(graph,fullfile(resultspath,'learning_curve_graphs','fine_bins',['learning-curve_MEAN_Total_' binSize] ),'png');
    hold off
    
    %unstacked version
    figure
    hold on
    graph = bar(1:size(meanAB,1),y);
    %title('mean learning curve');
     xticks(1:1:276/binSize);
    yticks(0:1:binSize);
    xlabel(['bin number']);
    ylabel(['correct choices per bin (mean' char(177) 'SEM)']);
    %error bar is shit in matlab. this is a workaround to decenter the errorbars
    ngroups = size(y, 1);
    nbars = size(y, 2);
    % Calculating the width for each bar group
    groupwidth = min(0.8, nbars/(nbars + 1.5));
    for i = 1:nbars
        x = (1:ngroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*nbars);
        errorbar(x, y(:,i), sem(:,i), '.');
    end
    legend('A-B pairs', 'C-D pairs', 'E-F pairs')
    saveas(graph,fullfile(resultspath,'learning_curve_graphs','fine_bins',['learning-curve_MEAN_Total_notstacked'] ),'png');
    %}
    
    
    %%figures mean learning curves
    %{
    meanLearning = mean(learning_correct,2);
    stdMeanLearning = std(learning_correct,0,2);
    semMeanLearning = stdMeanLearning/sqrt(numel(stdMeanLearning));
    figure
    hold on
    graph = bar(1:nBin,meanLearning)
    errorbar(1:nBin,meanLearning,semMeanLearning,'.');
    title('mean learning curve');
    xticks(1:1:23);
    yticks(0:1:12);
    %saveas(graph,fullfile(resultspath,'learning_curve_graphs','fine_bins','learning-curve_MEAN_Total'),'png');
    %}
    %{ 
    
    either remove fine bins (6 instead of 12) from above or add to path below
    
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

    close all;
      
end