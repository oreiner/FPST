function draw_ratings(ratings)
    %%get all task log files
    cd '[Home Directory]/analyses/task';
    resultspath = '../../results/task';
    cd '../../results/task';
    %%config variables
   
    if not(exist('ratings', 'var'))
       load(fullfile('ratings_results_new.mat'));
    end
     
     %% color scheme
    GrayColorOrder = [0,0,0 ; 0.2,0.2,0.2 ; 0.3,0.3,0.3 ; 0.35,0.35,0.35 ; 0.4,0.4,0.4 ; 0.45,0.45,0.45 ; 0.5,0.5,0.5 ; 0.55,0.55,0.55 ; 0.6,0.6,0.6 ; 0.65,0.65,0.65 ; 0.7,0.7,0.7  ; 0,0,0]; %[(ones(3,10).*(0.0:0.1:0.9))'];
    BlueColorOrder = [0,0,0 ; 0,0,0.2 ; 0,0,0.3 ; 0,0,0.4 ; 0,0,0.5 ; 0,0,0.55 ; 0,0,0.6 ; 0,0,0.65 ; 0,0,0.7 ; 0,0,0.75 ; 0,0,0.8 ; 0,0,0.9 ; 0,0,0 ];
    BrightColorOrder = [0,0,0 ; 51,34,136 ; 102,204, 238 ; 68,170,153 ; 34,136,51 ; 150,120,40 ; 201,184,99 ; 238,102,119 ; 136,34,85 ; 170,68,153 ; 120,120,120 ; 0,0,0 ]/256;
    
    CustomColorOrder = BrightColorOrder; colorname = '_bright';
    %CustomColorOrder = BlueColorOrder; colorname = '_blues';
    %CustomColorOrder = GrayColorOrder; colorname = '_grayscale';

    %save files in multiple extensions = png, svg, fig
    extensions ={'png','fig','svg'};
    
    %%initialize variables
    %get subjects
    %{
    d = dir(resultspath); %get the data for the main directory
    mainIndex = [d.isdir] & [~ismember({d.name}, {'.', '..'})] & [~isnan(str2double({d.name}))]; %find the index of the directories (exclude '.' and '..')
    subjects = {d(mainIndex).name};
 
    for iS = 1 : numel(subjects) 
        load(fullfile(subjects{iS},[subjects{iS} imodel]));
    end
    %}  
    
    close all;
    
    stdWantingFill = [ratings_table.wanting_pretest(11)+ratings_table.wanting_pretest(12) ratings_table.wanting_pretest(11)-ratings_table.wanting_pretest(12) ...
                      ratings_table.wanting_posttest(11)-ratings_table.wanting_posttest(12) ratings_table.wanting_posttest(11)+ratings_table.wanting_posttest(12)  ]
    stdWantingFill = min(stdWantingFill,110); stdWantingFill = max(stdWantingFill,0);
        
    stdLikingFill = [ratings_table.liking_pretest(11)+ratings_table.liking_pretest(12) ratings_table.liking_pretest(11)-ratings_table.liking_pretest(12) ...
                      ratings_table.liking_posttest(11)-ratings_table.liking_posttest(12) ratings_table.liking_posttest(11)+ratings_table.liking_posttest(12)  ]
    stdLikingFill = min(stdLikingFill,100); stdLikingFill = max(stdLikingFill,0);
    
     stdHungerFill = [ratings_table.hunger_pretest(11)+ratings_table.hunger_pretest(12) ratings_table.hunger_pretest(11)-ratings_table.hunger_pretest(12) ...
                      ratings_table.hunger_posttest(11)-ratings_table.hunger_posttest(12) ratings_table.hunger_posttest(11)+ratings_table.hunger_posttest(12)  ]
    stdHungerFill = min(stdHungerFill,100); stdHungerFill = max(stdHungerFill,0);
        
    stdSatietyFill = [ratings_table.satiety_pretest(11)+ratings_table.satiety_pretest(12) ratings_table.satiety_pretest(11)-ratings_table.satiety_pretest(12) ...
                      ratings_table.satiety_posttest(11)-ratings_table.satiety_posttest(12) ratings_table.satiety_posttest(11)+ratings_table.satiety_posttest(12)  ]
    stdSatietyFill = min(stdSatietyFill,100); stdSatietyFill = max(stdSatietyFill,0);
    
    stdThirstFill = [ratings_table.thirst_pretest(11)+ratings_table.thirst_pretest(12) ratings_table.thirst_pretest(11)-ratings_table.thirst_pretest(12) ...
                      ratings_table.thirst_posttest(11)-ratings_table.thirst_posttest(12) ratings_table.thirst_posttest(11)+ratings_table.thirst_posttest(12)  ]
    stdThirstFill = min(stdThirstFill,100); stdThirstFill = max(stdThirstFill,0);
    
    figure;
    hold on;
     title('Wanting');
    %set(gca, 'ColorOrder', CustomColorOrder(2:end,:)); %skip black, it's there because of the fill thing in the learning curves. I think
     set(gca, 'ColorOrder', CustomColorOrder);
     ylim([-100 102]);
     xlim([0.9 2.1]);
     xticks([1 2]);
     %ylabel('wanting');
     xticklabels({'pre-scan','post-scan'});
     stdWanting = fill([1,1,2,2], stdWantingFill, [0.8 0.8 0.8], 'edgeColor', [0.75 0.75 0.75]);
     for i=1:10
        wanting = plot([1,2],[ratings_table.wanting_pretest(i),ratings_table.wanting_posttest(i)],'-o', ... 
        'MarkerFaceColor',CustomColorOrder(1+i,:), 'LineWidth', 2, 'MarkerSize', 8);
     end
     mean =  plot([1,2],[ratings_table.wanting_pretest(11),ratings_table.wanting_posttest(11)],'-o', ... 
        'MarkerFaceColor',[0,0,0]);
     mean.LineWidth = 5;
    mean.MarkerSize = 10;
    for ext = 1:length(extensions)
     saveas(wanting,fullfile(resultspath,'ratings',['wanting' colorname ] ),extensions{ext});
    end
    hold off;
    
     figure;
     hold on;
     title('Liking');
     %set(gca, 'ColorOrder', CustomColorOrder(2:end,:)); %skip black, it's there because of the fill thing in the learning curves. I think
     set(gca, 'ColorOrder', CustomColorOrder);
     ylim([-100 102]);
     xlim([0.75 2.25]);
     xticks([1 2]);
     %ylabel('liking');
     xticklabels({'pre-scan','post-scan'});
     stdLiking = fill([1,1,2,2], stdLikingFill, [0.8 0.8 0.8], 'edgeColor', [0.75 0.75 0.75]);
     for i=1:10
        liking = plot([1,2],[ratings_table.liking_pretest(i),ratings_table.liking_posttest(i)],'-o', ... 
        'MarkerFaceColor',CustomColorOrder(1+i,:), 'LineWidth', 2, 'MarkerSize', 8);
     end
     mean =  plot([1,2],[ratings_table.liking_pretest(11),ratings_table.liking_posttest(11)],'-o', ... 
        'MarkerFaceColor',[0,0,0]);
    mean.LineWidth = 5;
    mean.MarkerSize = 10;
    for ext = 1:length(extensions)
     saveas(liking,fullfile(resultspath,'ratings',['liking' colorname ] ),extensions{ext});
    end
    hold off;
    
    figure;
    hold on;
     title('Hunger');
     %set(gca, 'ColorOrder', CustomColorOrder(2:end,:)); %skip black, it's there because of the fill thing in the learning curves. I think
     set(gca, 'ColorOrder', CustomColorOrder);
     ylim([-100 102]);
     xlim([0.75 2.25]);
     xticks([1 2]);
     %ylabel('hunger');
     xticklabels({'pre-scan','post-scan'});
     stdHunger = fill([1,1,2,2], stdHungerFill, [0.8 0.8 0.8], 'edgeColor', [0.75 0.75 0.75]);
     for i=1:10
        hunger = plot([1,2],[ratings_table.hunger_pretest(i),ratings_table.hunger_posttest(i)],'-o', ... 
        'MarkerFaceColor',CustomColorOrder(1+i,:), 'LineWidth', 2, 'MarkerSize', 8);
     end
     mean =  plot([1,2],[ratings_table.hunger_pretest(11),ratings_table.hunger_posttest(11)],'-o', ... 
        'MarkerFaceColor',[0,0,0]);
     mean.LineWidth = 5;
    mean.MarkerSize = 10;
    for ext = 1:length(extensions)
     saveas(hunger,fullfile(resultspath,'ratings',['hunger' colorname ] ),extensions{ext});
    end
    hold off;
    
    figure;
    hold on;
     title('Satiety');
     %set(gca, 'ColorOrder', CustomColorOrder(2:end,:)); %skip black, it's there because of the fill thing in the learning curves. I think
     set(gca, 'ColorOrder', CustomColorOrder);
     ylim([-100 102]);
     xlim([0.75 2.25]);
     xticks([1 2]);
     %ylabel('satiety');
     xticklabels({'pre-scan','post-scan'});
     stdSatiety = fill([1,1,2,2], stdSatietyFill, [0.8 0.8 0.8], 'edgeColor', [0.75 0.75 0.75]);
     for i=1:10
        satiety = plot([1,2],[ratings_table.satiety_pretest(i),ratings_table.satiety_posttest(i)],'-o', ... 
        'MarkerFaceColor',CustomColorOrder(1+i,:), 'LineWidth', 2, 'MarkerSize', 8);
     end
     mean =  plot([1,2],[ratings_table.satiety_pretest(11),ratings_table.satiety_posttest(11)],'-o', ... 
        'MarkerFaceColor',[0,0,0]);
     mean.LineWidth = 5;
    mean.MarkerSize = 10;
    for ext = 1:length(extensions)
     saveas(satiety,fullfile(resultspath,'ratings',['satiety' colorname ] ),extensions{ext});
    end
    hold off;
    
    
    figure;
    hold on;
     title('Thirst');
     %set(gca, 'ColorOrder', CustomColorOrder(2:end,:)); %skip black, it's there because of the fill thing in the learning curves. I think
     set(gca, 'ColorOrder', CustomColorOrder);
     ylim([-100 102]);
     xlim([0.75 2.25]);
     xticks([1 2]);
     %ylabel('thirst');
     xticklabels({'pre-scan','post-scan'});
     stdThirst = fill([1,1,2,2], stdThirstFill, [0.8 0.8 0.8], 'edgeColor', [0.75 0.75 0.75]);
     for i=1:10
        thirst = plot([1,2],[ratings_table.thirst_pretest(i),ratings_table.thirst_posttest(i)],'-o', ... 
        'MarkerFaceColor',CustomColorOrder(1+i,:), 'LineWidth', 2, 'MarkerSize', 8);
     end
     mean =  plot([1,2],[ratings_table.thirst_pretest(11),ratings_table.thirst_posttest(11)],'-o', ... 
        'MarkerFaceColor',[0,0,0]);
     mean.LineWidth = 5;
    mean.MarkerSize = 10;
    for ext = 1:length(extensions)
     saveas(thirst,fullfile(resultspath,'ratings',['thirst' colorname ] ),extensions{ext});
    end
    hold off;
    

   close all;
      
end