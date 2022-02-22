%{
2889 V 1
4643 S 3
4806 V 1
7873 S 3
8159 S 3
8904 V 1
8909 S 3
9012 E 2
9013 E 2
%}
taskpath = '[Home Directory]/data/task/';

subjects = {'2899', '4643', '4806','8159','8904','8909','8947','9012','9013'}; %,'7873' has no post test results
milkshake = [1,3,1,3,1,3,4,2,2];

ratings = [];

for i=1:numel(subjects)
    file = dir(fullfile(taskpath,['FPST_' subjects{i}],'*ratings.mat'));
    load(fullfile(file.folder,file.name));
    pretest(i).liking = output.rating(milkshake(i), 2);
    pretest(i).wanting = output.rating(milkshake(i), 6);
    
    file = dir(fullfile(taskpath,['FPST_' subjects{i}],'*logs.mat'));
    load(fullfile(file.folder,file.name));
    posttest(i).liking = ratings.rating(2).rating;
    posttest(i).wanting = ratings.rating(3).rating(4);

    
    ratings_wanting(i) = posttest(i).wanting - pretest(i).wanting;
    ratings_liking(i) = posttest(i).liking - pretest(i).liking;
    
    pwanting(i) = posttest(i).wanting / pretest(i).wanting;
    pliking(i) = posttest(i).liking / pretest(i).liking;
end

ratings_table = table(subjects', [pretest(:).wanting]',[posttest(:).wanting]',pwanting',[pretest(:).liking]',[posttest(:).liking]',pliking');
ratings_table.Properties.VariableNames = {'Subjects', 'wanting_pretest', 'wanting_posttest', 'wanting_ratio', 'liking_pretest', 'liking_posttest', 'liking_ratio'};
