clear all; clc;
thispath = pwd;
outputPath= ['/DATA/reinero/Dokumente/FPST/results/jitter design efficiency/output'];

clear effallloop
clear iJitter
%list='with_most_important_onlyshowncontrasts_500_corrected';
%list='_with_fine_exp_dissversion';
list='_with_fine_uniform_dissversion';
voxel = '_vox2';
count=1; 

for iJitter = 1:17
%for iJitter = [1,3,10,11,13] %most important 
    designName= ['vox2_' num2str(iJitter)];
    savePath=fullfile(outputPath,['With_real_subjects_bestjitt_list' list], designName);
    cd(savePath);
    
    load('efftest.mat')
    effallloop.c1(:,count) = effall(:,1);
    effallloop.c2(:,count) = effall(:,2);
    effallloop.c3(:,count) = effall(:,3);
    effallloop.c4(:,count) = effall(:,4);
    effallloop.c5(:,count) = effall(:,5);
    %effallloop.c6(:,count) = effall(:,6);
    %effallloop.c7(:,count) = effall(:,7);
    %nrscans(iJitter,:) = dur_scans;
    lc(:,count) = LC_risk;
    
    sumtime = zeros(size(jitter,2),1);
    %get time of jitter
    for j = 1:size(jitter,2)
        sumtime(j) = sum(sum(jitter(j).u,2));
    end
    meansumtime(count) = mean(sumtime)/60; 
    cd(thispath); 
    
    count= count+1;
end

%%export to excel
%efficiency = table(effallloop,lc);
cd('/archive/reinero/Dokumente/FPST/results/jitter design efficiency');
efficiency = table(effallloop.c1,effallloop.c2,effallloop.c3,effallloop.c4,effallloop.c5,lc, repmat(meansumtime,500,1), ...
                    'VariableNames', ...
                    {'cue','Qchosen','Positive_Feedback','Positive_Feedback_over_Negative_Feedback',...
                    'Positive_PE','General_Efficiency_ie_Laplace_Charnoff_Risk','mean_jitter_time_column_per_jitterlist_repeated_just_to_fit_csv'});
effallloop.meansumtime = meansumtime;
effallloop.lc = lc;
save(['efficiency_' list], 'effallloop');
writetable(efficiency, ['efficiency' list '.csv']);

i=1;
figure;
subplot(3,2,i);
boxplot(effallloop.c1)
%title(['effallloop.c1 ' list voxel])
title('Cue')
ylabel('efficiency')
%add time scale
yyaxis right

scatter(1:count-1, meansumtime,'diamond','MarkerFaceColor','black')
ylabel('time (min)')
i=i+1;

subplot(3,2,i);
boxplot(effallloop.c2)
%title(['effallloop.c2 ' list voxel])
title('Qchosen')
i=i+1;

subplot(3,2,i);
boxplot(effallloop.c3)
%title(['effallloop.c3 ' list voxel])
title('Positive Feedback')
i=i+1;

subplot(3,2,i);
boxplot(effallloop.c4)
%title(['effallloop.c4 ' list voxel])
title('Positive Feedback > Negative Feedback')
i=i+1;

subplot(3,2,i);
boxplot(effallloop.c5)
%title(['effallloop.c5 ' list voxel])
title('Positive PE')
i=i+1;

%{
subplot(3,2,i);
boxplot(effallloop.c6)
%title(['effallloop.c6 ' list voxel])
title('Positive PE > Negative PE')
i=i+1;

subplot(3,2,i);
boxplot(effallloop.c7)
%title(['effallloop.c7 ' list voxel])
title('Positive PE < Negative PE')
i=i+1;
%}

%{
subplot(3,2,i);
boxplot(nrscans')
title(['nrscans ' list voxel])
%}


subplot(3,2,i);
boxplot(lc)
%title(['LC_risk ' list voxel])
title(['General Efficiency - Laplace Charnoff Risk'])
i=i+1;
