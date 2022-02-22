%%sorted the PEs according to the chosen cue it belongs to

function [sorted_PE] = PE_sorter(subject, output_dir)
   
    taskpath = '[Home Directory]/results/task';
    %model = '_task_results_only_learn_phase_asymmetrical_normal_temperature';
	model = '_task_results_both_phases_asymmetrical_normal_temperature';	
	load(fullfile(taskpath, subject, [subject model '.mat']));
    
    %convert negative feedbacks to minus one for clearer plotting
    feedbacks = data.feedbacks;
    feedbacks(find(feedbacks==0)) = -1;
    
    PEs(1,:) = data.choices;
    PEs(2,:) = feedbacks; 
    PEs(3,:) = posterior.PE;
    PEs(4:9,:) = posterior.muX; %Q-Value
    
    for i=1:6
        close all
        sorted_PE(i).cue = PEs(:,find(PEs(1,:)==i));
        gcf = sorted_PE(i).cue;
        
        graph = scatter(1:size(gcf,2),gcf(2,:)); %feedbacks
        hold on
        plot (1:size(gcf,2),gcf(3,:)); % PE
        gtitle = ['Cue number ' int2str(i) ' PE' ];
        title(gtitle);
        xlabel('trial number')
        legend({'feedback','PE'},'location','southeast')
        saveas(graph,fullfile(output_dir,['PE_' int2str(i)]),'jpg');
        hold off
        
        graph = scatter(1:size(gcf,2),gcf(2,:)); %feedbacks
        hold on
        plot (1:size(gcf,2),gcf(3+i,:)); % Q-Value
        gtitle = ['Cue number ' int2str(i) ' Q-Value' ];
        title(gtitle);
        xlabel('trial number')
        legend({'feedback','Q-Value'},'location','southeast') 
        saveas(graph,fullfile(output_dir,['Q-Value_' int2str(i)]),'jpg');
        hold off
    end
   
end