function plot_head_movement()
    %{
    2889 V 1
    4643 S 3
    4806 V 1
    7873 S 3 doesn't have posttest scores
    8159 S 3
    8904 V 1
    8909 S 3
    8947 B 4
    9012 E 2
    9013 E 2
    %}
    parpath = '[Home Directory]/results/fmri/nii';
    resultspath = '[Home Directory]/results/fmri/nii';
    
    subjects = {'2899', '4643', '4806','7873', '8159','8904','8909','9012','9013'}; %,'8947' has no fmri results

    for i=1:numel(subjects)
        for sequence = {'learning','transfer'}
            if strcmp(sequence{1},'transfer') && strcmp(subjects{i},'7873')
                continue;
            end
            file = dir(fullfile(parpath,subjects{i},['FPST_BOLD_' sequence{1} '_' subjects{i} '*.par']));
            headmovement = load(fullfile(file.folder,file.name));     
            
            gcf = figure
            hold on
            plot(headmovement);
            title([sequence{1} ' ' subjects{i} ' Head Movement']);
            saveas(gcf,fullfile(resultspath,'realigment_plots',['headmovement_' sequence{1} '_' subjects{i}]),'png');
        end
    end

    close all;                                                                            
end