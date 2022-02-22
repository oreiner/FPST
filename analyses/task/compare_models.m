%%compare models after running analyze_task for all subjects

%% script changed unexpectidally, try reverting to older version 

function get_action_values(model)
    %%get all task log files
    if(not(exist(model)))
        model = '';
    end
    
    resultspath = '../../results/task';
    cd '../../results/task';
    d = dir(resultspath);
    d = d(3:end); 
    d(find(strcmp({d.name}, '7873'))) = []; %delete 7873 because no test phase
    
    ActionValues = zeros(6,numel(d));
    
    for iS = 1 : numel (d)
       load(fullfile(d,[d.name '_' model]));
       ActionValues(:,iS) = posterior.muX(:,end);
    end
    
    meanActionValues = mean(ActionValues,2);
    
    stdActionValues = std(meanActionValues);
    
    
    save('actionvalues.mat', 'ActionValues');
    close all
    
end