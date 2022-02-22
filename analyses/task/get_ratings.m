function get_ratings()
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
    taskpath = '[Home Directory]/data/task/';

    subjects = {'2899', '4643', '4806','7873', '8159','8904','8909','8947','9012','9013'}; %,'7873' has no post test results
    milkshake = [1,3,1,3,3,1,3,4,2,2];

    ratings = [];

    for i=1:numel(subjects)
        file = dir(fullfile(taskpath,['FPST_' subjects{i}],'*ratings.mat'));
        load(fullfile(file.folder,file.name));
        pretest(i).liking = output.rating(milkshake(i), 2);
        pretest(i).wanting = output.rating(milkshake(i), 6);
        pretest(i).hunger = output.state(1);
        pretest(i).satiety = output.state(2);
        pretest(i).thirst = output.state(3);
        if not(strcmp(subjects(i),'7873'))
            file = dir(fullfile(taskpath,['FPST_' subjects{i}],'*logs.mat'));
            load(fullfile(file.folder,file.name));
            posttest(i).liking = ratings.rating(2).rating;
            posttest(i).wanting = ratings.rating(3).rating(4);
            posttest(i).hunger = ratings.state(1);
            posttest(i).satiety = ratings.state(2);
            posttest(i).thirst = ratings.state(3);

            ratings_wanting(i) = posttest(i).wanting - pretest(i).wanting;
            ratings_liking(i) = posttest(i).liking - pretest(i).liking;

            pwanting(i) = posttest(i).wanting / pretest(i).wanting;
            pliking(i) = posttest(i).liking / pretest(i).liking;
            phunger(i) = posttest(i).hunger / pretest(i).hunger;
            psatiety(i) = posttest(i).satiety / pretest(i).satiety;
            pthirst(i) = posttest(i).thirst / pretest(i).thirst;
        else
            posttest(i).liking = NaN;
            posttest(i).wanting = NaN;
            posttest(i).hunger = NaN;
            posttest(i).satiety = NaN;
            posttest(i).thirst = NaN;

            ratings_wanting(i) = NaN;
            ratings_liking(i) = NaN;

            pwanting(i) = NaN;
            pliking(i) = NaN;
            phunger(i) = NaN;
            psatiety(i) = NaN;
            pthirst(i) = NaN;
        end
    end
    vmean = @ (v)[v' ; nanmean(v) ; nanstd(v)] ; %anonymous function to add mean & standard dev lines (also change row to column)
    ratings_table = table([subjects'; 'mean'; 'SD'], vmean([pretest(:).wanting]),vmean([posttest(:).wanting]),vmean(pwanting), ...
                                    vmean([pretest(:).liking]),vmean([posttest(:).liking]),vmean(pliking), ...
                                    vmean([pretest(:).hunger]), vmean([posttest(:).hunger]), vmean(phunger), ...
                                    vmean([pretest(:).satiety]), vmean([posttest(:).satiety]), vmean(psatiety), ...
                                    vmean([pretest(:).thirst]), vmean([posttest(:).thirst]), vmean(pthirst)...
                                    );
    ratings_table.Properties.VariableNames = {'Subjects', 'wanting_pretest', 'wanting_posttest', 'wanting_ratio', ...
                                                'liking_pretest', 'liking_posttest', 'liking_ratio', ...
                                                'hunger_pretest', 'hunger_posttest', 'hunger_ratio', ...
                                                'satiety_pretest',  'satiety_posttest', 'satiety_ratio', ...
                                                'thirst_pretest', 'thirst_posttest', 'thirst_ratio' ...
                                                };
    cd '[Home Directory]/results/task';
    
    save('ratings_results_new.mat', 'ratings_table');
    writetable(ratings_table, 'ratings_table_new.csv');
    close all;                                                                            
end