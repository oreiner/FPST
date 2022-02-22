cd [Home Directory]/analyses/task
%'7873' doesn't have testphase, hardcoded exception into analyze_task
subjects = {'2899','4643','4806','7873','8159','8904','8909','8947', '9012','9013'}; %

for i = 1:numel(subjects)
        close all;

        analyze_task(subjects{i});
        cd [Home Directory]/analyses/task
end

close all;