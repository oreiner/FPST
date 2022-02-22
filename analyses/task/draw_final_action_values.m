function draw_final_action_values()
    %%get all task log files
    cd '[Home Directory]/analyses/task';
    resultspath = '../../results/task';
    cd '../../results/task';
    
    %get actionValues
    ActionValuesAsym = load('action_values_task_results_both_phases_asymmetrical_normal_temperature');
    ActionValuesUnitary = load('action_values_task_results_both_phases_unitary_normal_temperature'); 
    ActionValuesTraditional = load('action_values_task_results_only_learn_phase_unitary_normal_temperature');
    %with differenct priors: all zero and all ones
        ActionValuesAsymZeros = load('action_values_task_results_both_phases_asymmetrical_normal_temperature_priorX0_0_');
        ActionValuesAsymOnes = load('action_values_task_results_both_phases_asymmetrical_normal_temperature_priorX0_1_');
        
    load('contingencies.mat'); %contingencyT
    
    indx = [1,3,5,6,4,2]; %reordering action values by value
    
    meanUnitary = mean(ActionValuesUnitary.ActionValues,2);
    stdUnitary = std(ActionValuesUnitary.ActionValues,0,2);  
    meanUnitaryReorderd = meanUnitary(indx);
    stdUnitaryReorderd = stdUnitary(indx);
    semUnitary = stdUnitaryReorderd/sqrt(numel(stdUnitaryReorderd));
    
    meanTraditional = mean(ActionValuesTraditional.ActionValues,2);
    stdTraditional = std(ActionValuesTraditional.ActionValues,0,2);  
    meanTraditionalReorderd = meanTraditional(indx);
    stdTraditionalReorderd = stdTraditional(indx);
    semTraditional = stdTraditionalReorderd/sqrt(numel(stdTraditionalReorderd));
    
    meanAsym = mean(ActionValuesAsym.ActionValues,2);
    stdAsym = std(ActionValuesAsym.ActionValues,0,2);
    meanAsymReorderd = meanAsym(indx);
    stdAsymReorderd = stdAsym(indx);
    semAsym = stdAsymReorderd/sqrt(numel(stdAsymReorderd));
    %%%%%%%
        %with different priors. maybe not interesting
        meanAsymZeros = mean(ActionValuesAsymZeros.ActionValues,2);
        stdAsymZeros = std(ActionValuesAsymZeros.ActionValues,0,2);
        meanAsymReorderdZeros = meanAsymZeros(indx);
        stdAsymReorderdZeros = stdAsymZeros(indx);
        semAsymZeros = stdAsymReorderdZeros/sqrt(numel(stdAsymReorderdZeros));
        
        meanAsymOnes = mean(ActionValuesAsymOnes.ActionValues,2);
        stdAsymOnes = std(ActionValuesAsymOnes.ActionValues,0,2);
        meanAsymReorderdOnes = meanAsymOnes(indx);
        stdAsymReorderdOnes = stdAsymOnes(indx);
        semAsymOnes = stdAsymReorderdOnes/sqrt(numel(stdAsymReorderdOnes));
    %%%%%%
    meanContingencies = nanmean(contingencies);
    stdContingencies = nanstd(contingencies);
    meanContingenciesReorderd = meanContingencies(indx);
    stdContingenciesReorderd = stdContingencies(indx);
    semContingencies = stdContingenciesReorderd/sqrt(numel(stdContingenciesReorderd)); 
    
    %trim std to limit [0,1]
    sd_chopoff = meanContingenciesReorderd - stdContingenciesReorderd;
    sd_chopoff = min(sd_chopoff,0);
    sd_bot = stdContingenciesReorderd + sd_chopoff;
    
    hold off
    gcf = figure
    hold on
    %title('mean state-action values');
    xticks(1:6)
    xticklabels({'A (80%)','C (70%)', 'E (60%)', 'F (40%)','D (30%)','B (20%)'})
    %ylabel('final state-action value (mean + SEM)')
    ylabel('final state-action value (mean + SD)')
    %reorder action values 
    %{
    %without other priors
    y = [0.8, meanContingenciesReorderd(1) ,meanAsymReorderd(1), meanUnitaryReorderd(1); ...
         0.7, meanContingenciesReorderd(2) ,meanAsymReorderd(2), meanUnitaryReorderd(2); ...
         0.6, meanContingenciesReorderd(3) ,meanAsymReorderd(3), meanUnitaryReorderd(3); ...
         0.4, meanContingenciesReorderd(4) ,meanAsymReorderd(4), meanUnitaryReorderd(4); ...
         0.3, meanContingenciesReorderd(5) ,meanAsymReorderd(5), meanUnitaryReorderd(5); ...
         0.2, meanContingenciesReorderd(6) ,meanAsymReorderd(6), meanUnitaryReorderd(6)];
    err = [0, semContingencies(1) ,semAsym(1), semUnitary(1); ...
         0, semContingencies(2) ,semAsym(2), semUnitary(2); ...
         0, semContingencies(3) ,semAsym(3), semUnitary(3); ...
         0, semContingencies(4) ,semAsym(4), semUnitary(4); ...
         0, semContingencies(5) ,semAsym(5), semUnitary(5); ...
         0, semContingencies(6) ,semAsym(6), semUnitary(6)];
     %}
    %without other priors, std not sem
    y = [0.8, meanContingenciesReorderd(1) ,meanAsymReorderd(1), meanUnitaryReorderd(1), meanTraditionalReorderd(1); ...
         0.7, meanContingenciesReorderd(2) ,meanAsymReorderd(2), meanUnitaryReorderd(2), meanTraditionalReorderd(2); ...
         0.6, meanContingenciesReorderd(3) ,meanAsymReorderd(3), meanUnitaryReorderd(3), meanTraditionalReorderd(3); ...
         0.4, meanContingenciesReorderd(4) ,meanAsymReorderd(4), meanUnitaryReorderd(4), meanTraditionalReorderd(4); ...
         0.3, meanContingenciesReorderd(5) ,meanAsymReorderd(5), meanUnitaryReorderd(5), meanTraditionalReorderd(5); ...
         0.2, meanContingenciesReorderd(6) ,meanAsymReorderd(6), meanUnitaryReorderd(6), meanTraditionalReorderd(6)];
    err = [0, stdContingenciesReorderd(1) ,stdAsymReorderd(1), stdUnitaryReorderd(1), stdTraditionalReorderd(1); ...
         0, stdContingenciesReorderd(2) ,stdAsymReorderd(2), stdUnitaryReorderd(2), stdTraditionalReorderd(2); ...
         0, stdContingenciesReorderd(3) ,stdAsymReorderd(3), stdUnitaryReorderd(3), stdTraditionalReorderd(3); ...
         0, stdContingenciesReorderd(4) ,stdAsymReorderd(4), stdUnitaryReorderd(4), stdTraditionalReorderd(4); ...
         0, stdContingenciesReorderd(5) ,stdAsymReorderd(5), stdUnitaryReorderd(5), stdTraditionalReorderd(5); ...
         0, stdContingenciesReorderd(6) ,stdAsymReorderd(6), stdUnitaryReorderd(6), stdTraditionalReorderd(6)];
     
    err_top = err;
    err_bot = err; err_bot(:,2) = sd_bot;
    %{
    %comparing different prior AV x0=0,0.5,1
     y = [0.8, meanContingenciesReorderd(1) ,meanAsymReorderdZeros(1), meanAsymReorderd(1), meanAsymReorderdOnes(1), meanUnitaryReorderd(1); ...
         0.7, meanContingenciesReorderd(2) ,meanAsymReorderdZeros(2), meanAsymReorderd(2), meanAsymReorderdOnes(2), meanUnitaryReorderd(2); ...
         0.6, meanContingenciesReorderd(3) ,meanAsymReorderdZeros(3), meanAsymReorderd(3), meanAsymReorderdOnes(3), meanUnitaryReorderd(3); ...
         0.4, meanContingenciesReorderd(4) ,meanAsymReorderdZeros(4), meanAsymReorderd(4), meanAsymReorderdOnes(4), meanUnitaryReorderd(4); ...
         0.3, meanContingenciesReorderd(5) ,meanAsymReorderdZeros(5), meanAsymReorderd(5), meanAsymReorderdOnes(5), meanUnitaryReorderd(5); ...
         0.2, meanContingenciesReorderd(6) ,meanAsymReorderdZeros(6), meanAsymReorderd(6), meanAsymReorderdOnes(6), meanUnitaryReorderd(6)];
    err = [0, semContingencies(1) ,semAsymZeros(1),semAsym(1),semAsymOnes(1), semUnitary(1); ...
         0, semContingencies(2) ,semAsymZeros(2),semAsym(2),semAsymOnes(2), semUnitary(2); ...
         0, semContingencies(3) ,semAsymZeros(3),semAsym(3),semAsymOnes(3), semUnitary(3); ...
         0, semContingencies(4) ,semAsymZeros(4),semAsym(4),semAsymOnes(4), semUnitary(4); ...
         0, semContingencies(5) ,semAsymZeros(5),semAsym(5),semAsymOnes(5), semUnitary(5); ...
         0, semContingencies(6) ,semAsymZeros(6),semAsym(6),semAsymOnes(6), semUnitary(6)];
   %}
    graph = bar(y);
 %%error bar is shit in matlab. this is a workaround to decenter the error
 %%bars
    ngroups = size(y, 1);
    nbars = size(y, 2);
    % Calculating the width for each bar group
    groupwidth = min(0.8, nbars/(nbars + 1.5));
    for i = 1:nbars
        x = (1:ngroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*nbars);
        %errorbar(x, y(:,i), err(:,i), '.');
        errorbar(x, y(:,i), err_bot(:,i), err_top(:,i), '.'); %chopoff sd going under zero
    end
    legend('planned contigency','experienced contigency', 'SAV from asymmetrical learning', 'SAV from uniform learning', 'SAV from traditional model');
    %legend('planned contigency','experienced contigency', 'SAV from Asymmetrical learning X0=0', 'SAV from Asymmetrical learning X0=0.5','SAV from Asymmetrical learning X0=1','SAV from uniform learning');
   hold off
   
    saveas(graph,fullfile(resultspath,'action_values_graphs',['triple SAV with SD' ' color'] ),'png');
    saveas(graph,fullfile(resultspath,'action_values_graphs',['triple SAV with SD' ' color'] ),'svg');
    saveas(graph,fullfile(resultspath,'action_values_graphs',['triple SAV with SD' ' color'] ),'fig');
       
    %save(['action_values' imodel '.mat'], 'ActionValues', 'meanActionValues', 'stdActionValues', 'mloselose', 'stdloselose', 'mwinwin', 'stdwinwin');
    
    %close all;
    
end