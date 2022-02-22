
%d = dir();
%d = d(3:end); 
%d(4) = []; %delete 7873 because no test phase
cd [Home Directory]/results/task
subjects = {'2899','4643','4806','7873','8159','8904','8909','8947', '9012','9013'}; % 

for iS = 1 : numel (subjects)
    %id = d(iS).name;
    id = subjects{iS};
    l(1) = load([id, filesep, id, '_task_results_both_phases_asymmetrical_fixed_temperature.mat']);
    l(2) = load([id, filesep, id, '_task_results_both_phases_asymmetrical_normal_temperature.mat']);
    l(3) = load([id, filesep, id, '_task_results_both_phases_unitary_fixed_temperature.mat']);
    l(4) = load([id, filesep, id, '_task_results_both_phases_unitary_normal_temperature.mat']);
    
    
 
    
    F(1,iS) = l(1).out.F;
    F(2,iS) = l(2).out.F;
    F(3,iS) = l(3).out.F;
    F(4,iS) = l(4).out.F;
    
    
     ll(1) = load([id, filesep, id, '_task_results_only_learn_phase_asymmetrical_fixed_temperature.mat']);
     ll(2) = load([id, filesep, id, '_task_results_only_learn_phase_asymmetrical_normal_temperature.mat']);
     ll(3) = load([id, filesep, id, '_task_results_only_learn_phase_unitary_fixed_temperature.mat']);
     ll(4) = load([id, filesep, id, '_task_results_only_learn_phase_unitary_normal_temperature.mat']);
%     
%       
      lt(1) = load([id, filesep, id, '_task_results_only_test_phase_asymmetrical_fixed_temperature.mat']);
      lt(2) = load([id, filesep, id, '_task_results_only_test_phase_unitary_fixed_temperature.mat']);
%      
     F(5,iS) = ll(1).out.F + lt(1).out.F;
     F(6,iS) = ll(2).out.F + lt(1).out.F;
     F(7,iS) = ll(3).out.F + lt(2).out.F;
     F(8,iS) = ll(4).out.F + lt(2).out.F;
% %     
    close all

%     try
%     CC = l(2).out.diagnostics.C;
%     CC(isnan(CC)) = 1;
%     C(:,:,iS) = VBA_fisher(CC);
%     catch err
%         err
%     end
end

VBA_groupBMC(F)