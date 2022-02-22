function get_ratings_all_shakes()
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
    flavor = {'Vanilla','Strawberry','Chocolate','Banana'};
    
    ratings = [];

    for i=1:numel(subjects)
        file = dir(fullfile(taskpath,['FPST_' subjects{i}],'*ratings.mat'));
        load(fullfile(file.folder,file.name));
        pretest(i).sweetness = output.rating(milkshake(i), 1);
        pretest(i).liking = output.rating(milkshake(i), 2);
        pretest(i).fatty = output.rating(milkshake(i), 3);
        pretest(i).creamy = output.rating(milkshake(i), 4);
        pretest(i).oily = output.rating(milkshake(i), 5);
        pretest(i).wanting = output.rating(milkshake(i), 6);
        pretest(i).hunger = output.state(1);
        pretest(i).satiety = output.state(2);
        pretest(i).thirst = output.state(3);
        
        others = [1,2,3,4];
        others = not(others==milkshake(i));
       pretest(i).othermilkshakes = reshape(output.rating(others,:),[1,18]); %sweet sweet sweet  like like like etc.
        
        if not(strcmp(subjects(i),'7873'))
            file = dir(fullfile(taskpath,['FPST_' subjects{i}],'*logs.mat'));
            load(fullfile(file.folder,file.name));
            posttest(i).sweetness = ratings.rating(1).rating;
            posttest(i).liking = ratings.rating(2).rating;
               posttest(i).fatty = ratings.rating(3).rating(1);
               posttest(i).creamy = ratings.rating(3).rating(2);
               posttest(i).oily = ratings.rating(3).rating(3);
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
            posttest(i).sweetness = NaN;
            posttest(i).liking = NaN;
           posttest(i).fatty = NaN;
           posttest(i).creamy = NaN;
           posttest(i).oily = NaN;
            posttest(i).wanting = NaN;
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
                                    vmean([pretest(:).thirst]), vmean([posttest(:).thirst]), vmean(pthirst), ...
                                    vmean([pretest(:).sweetness]),vmean([posttest(:).sweetness]),vmean([pretest(:).fatty]), vmean([posttest(:).fatty]), ...
                                    vmean([pretest(:).creamy]), vmean([posttest(:).creamy]), vmean([pretest(:).oily]) , vmean([posttest(:).oily]) ,...
                                    [vertcat(pretest.othermilkshakes);nan(1,18);nan(1,18)] ... %lazyness. compute mean and sd for othermilkshakes later
                                    );
    ratings_table.Properties.VariableNames = {'Subjects', 'wanting_pretest', 'wanting_posttest', 'wanting_ratio', ...
                                                'liking_pretest', 'liking_posttest', 'liking_ratio', ...
                                                'hunger_pretest', 'hunger_posttest', 'hunger_ratio', ...
                                                'satiety_pretest',  'satiety_posttest', 'satiety_ratio', ...
                                                'thirst_pretest', 'thirst_posttest', 'thirst_ratio', ...
                                                'sweetness_pretest', 'sweetness_posttest', 'fatty_pretest', 'fatty_posttest', ...
                                                'creamy_pretest', 'creamy_posttest','oily_pretest', 'oily_posttest', ...
                                                'others_sweetnessx3_likingx3_fattyx3_creamyx3x_oilyx3_wantingx3' ...
                                                };
    cd '[Home Directory]/results/task';
    
    save('ratings_results_allshakes.mat', 'ratings_table');
    writetable(ratings_table, 'ratings_table_all_shakes.csv');
    close all;                                                                            
end