input_data_path = '[Home Directory]/results/task';
output_dir = '[Home Directory]/results/task/PE_graphs';

subjects = {};
if isempty(subjects)
    mainData = dir(input_data_path); %get the data for the main directory
    mainIndex = [mainData.isdir] & [~ismember({mainData.name}, {'.', '..'})] & [~isnan(str2double({mainData.name}))]; %find the index of the directories (exclude '.' and '..')
    subjects = {mainData(mainIndex).name}; %get a list of the directory names (IDs of the subjects)
end


for sub = 1:numel(subjects)
    sub_dir = fullfile(output_dir,'sorted_by_cue',subjects{sub});
    if not(exist(sub_dir,'dir'))
        mkdir(sub_dir);
    end
    PE_sorter(subjects{sub},sub_dir);
end
%{
for sub = 1:numel(subjects)
   load(fullfile(input_data_path,subjects{sub},[subjects{sub} '_task_results_both_phases_asymmetrical_normal_temperature'])); 
   close;
   graph = plot(end_results.model.pos_PE);
   gtitle = [subjects{sub} ' pos PE'];
   title(gtitle);
   saveas(graph,fullfile(output_dir, gtitle),'jpg');
   close;
   graph = plot(end_results.model.neg_PE);
   gtitle = [subjects{sub} ' neg PE'];
   title(gtitle);
   saveas(graph,fullfile(output_dir, gtitle),'jpg');
   close;
end
%}