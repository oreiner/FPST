cd [Home Directory]/analyses/fmri
%'4643' doesn't work. why!?! works with SPM12 v7 on home PC
%'7873' doens't have a transfer phase 
%'8947' doesn't have one of the blips for topup and can't be corrected for
%distortion
%subjects = {'2899','4643','4806','7873','8159','8904','8909','9012','9013'}; %'8947' 

%sequences = {'learning', 'transfer'};
%subjects = {'2899', '4643', '4806','7873','8159','8904','8909','9012','9013'};
%subjects = {'2899','4806','7873','8159','8904','8909','9012','9013'};
%subjects={'4643'};
%subjects = {'8909','9012'};
%sequences = {'learning', 'transfer'};
%sequences = { 'learning'};
subjects = {'2899','4643','4806','8159','8904','8909','9012','9013'}; sequences = { 'transfer'};
analysis2 = 'cross';



for i = 1:numel(subjects)
    for j = 1:numel(sequences)
        fprintf('\nstarting analysis loop for subject %s sequence %s\n', subjects{i}, sequences{j});
        startclock = datetime('now');
        if strcmp(sequences{j},'learning')
           %the last number stiming is do correct for the pause (about
           %1.2s, but I already buffered 0.3s in the formatting of the task data! so 0.9s) from decision time to the time the shake arrives
           %the prelast number is sduration - duration of event. either
           %0 seconds or 3.1 seconds for the full time subjects were given
           %to swallow etc.
    
           
           %% this are all wih missed events but no null events regressor
           %redoing this analysis with seperate shakes to show S->S+ in my
           %most "correct" regressor. also use Qchosen and remove side. add 0.3 choice time
           %to cue instead of reward. 
           FPST_1st_level_new(subjects{i}, sequences{j}, 'cue_Qchosen_no_null_PE_last_asymmetrical_learning_with_shake_duration_31', '_2_derivative',  'cue_Qchosen', 'PE_last','_task_results_both_phases_asymmetrical_normal_temperature', 3.1, 0.9); 
           FPST_1st_results_new(subjects{i}, sequences{j}, 'cue_Qchosen_no_null_PE_last_asymmetrical_learning_with_shake_duration_31', '_2_derivative', 'Qchosen_PE_last');
           cd [Home Directory]/analyses/fmri
          % 
         %  FPST_1st_level_new(subjects{i}, sequences{j}, 'cue_Qchosen_no_null_PE_last_unitary_model_with_shake_duration_31', '_2_derivative',  'cue_Qchosen', 'PE_last','_task_results_only_learn_phase_unitary_normal_temperature', 3.1, 0.9); 
         % FPST_1st_results_new(subjects{i}, sequences{j}, 'cue_Qchosen_no_null_PE_last_unitary_model_with_shake_duration_31', '_2_derivative', 'Qchosen_PE_last');
        %    cd [Home Directory]/analyses/fmri
            
        % FPST_1st_level_new(subjects{i}, sequences{j}, 'cue_Qchosen_no_null_PE_last_initStateZero_with_shake_duration_31', '_2_derivative',  'cue_Qchosen', 'PE_last','_task_results_only_learn_phase_unitary_normal_temperature_priorX0_0_', 3.1, 0.9); 
         % FPST_1st_results_new(subjects{i}, sequences{j}, 'cue_Qchosen_no_null_PE_last_initStateZero_with_shake_duration_31', '_2_derivative', 'Qchosen_PE_last');
         %  cd [Home Directory]/analyses/fmri
           
          
          
          
            
            
            %FPST_1st_level_new(subjects{i}, sequences{j}, 'cue_Qdelta_side_no_null_PE_last_modified_outcome_asymmetrical_learning_with_shake_duration', '_2_derivative',  'cue_Qdelta', 'side_PE_last','_task_results_both_phases_asymmetrical_normal_temperature', 3.1, 1.2); 
            %FPST_1st_results_new(subjects{i}, sequences{j}, 'cue_Qdelta_side_no_null_PE_last_modified_outcome_asymmetrical_learning_with_shake_duration', '_2_derivative', 'Qboth_sided_PE_last');
            %cd [Home Directory]/analyses/fmri
             
            %I wanted to try less eroded WM-Masks because the 2nd level
            %looks noisy. but I deleted the non smoothed images so I would
            %need to repeat the whole preprocess loop
            %FPST_1st_level_new(subjects{i}, sequences{j}, 'cue_Qdelta_no_null_PE_last_asymmetrical_learning_with_shake_duration_higher_WM_kernal', '_2_derivative',  'cue_Qdelta', 'PE_last','_task_results_both_phases_asymmetrical_normal_temperature', 3.1, 1.2, '_6_WMtest'); 
            %FPST_1st_results_new(subjects{i}, sequences{j}, 'cue_Qdelta_no_null_PE_last_asymmetrical_learning_with_shake_duration_higher_WM_kernal', '_2_derivative', 'Qboth_PE_last');
            %cd [Home Directory]/analyses/fmri
            
            %FPST_1st_level_new(subjects{i}, sequences{j}, 'cue_Qboth_side_no_null_PE_last_modified_outcome_asymmetrical_learning_with_shake_duration', '_2_derivative',  'cue_Qboth', 'side_PE_last','_task_results_both_phases_asymmetrical_normal_temperature', 3.1, 1.2); 
            %FPST_1st_results_new(subjects{i}, sequences{j}, 'cue_Qboth_side_no_null_PE_last_modified_outcome_asymmetrical_learning_with_shake_duration', '_2_derivative', 'Qboth_sided_PE_last');
            %cd [Home Directory]/analyses/fmri
            
            %%trying now with uniform learning
            
            %FPST_1st_level_new(subjects{i}, sequences{j}, 'cue_Qdelta_side_no_null_PE_last_modified_outcome_unitary_model_with_shake_duration', '_2_derivative',  'cue_Qdelta', 'side_PE_last','_task_results_only_learn_phase_unitary_normal_temperature', 3.1, 1.2); 
            %FPST_1st_results_new(subjects{i}, sequences{j}, 'cue_Qdelta_side_no_null_PE_last_modified_outcome_unitary_model_with_shake_duration', '_2_derivative', 'Qboth_sided_PE_last');
            %cd [Home Directory]/analyses/fmri
            
            %FPST_1st_level_new(subjects{i}, sequences{j}, 'cue_Qboth_side_no_null_PE_last_modified_outcome_unitary_model_with_shake_duration', '_2_derivative',  'cue_Qboth', 'side_PE_last','_task_results_only_learn_phase_unitary_normal_temperature', 3.1, 1.2); 
            %FPST_1st_results_new(subjects{i}, sequences{j}, 'cue_Qboth_side_no_null_PE_last_modified_outcome_unitary_model_with_shake_duration', '_2_derivative', 'Qboth_sided_PE_last');
            %cd [Home Directory]/analyses/fmri
            
            %FPST_1st_level_new(subjects{i}, sequences{j}, 'cue_Qdelta_side_no_null_PE_last_modified_outcome_unitary_model_with_shake_duration', '_2_derivative',  'cue_Qdelta', 'side_PE_last','_task_results_only_learn_phase_unitary_normal_temperature', 3.1, 1.2); 
            %FPST_1st_results_new(subjects{i}, sequences{j}, 'cue_Qdelta_side_no_null_PE_last_modified_outcome_unitary_model_with_shake_duration', '_2_derivative', 'Qboth_sided_PE_last');
            %cd [Home Directory]/analyses/fmri
            
            %FPST_1st_level_new(subjects{i}, sequences{j}, 'cue_Qboth_side_single_regressor_no_null_PE_last_modified_outcome_unitary_model_with_shake_duration', '_2_derivative',  'cue_Qboth', 'side_PE_last','_task_results_only_learn_phase_unitary_normal_temperature', 3.1, 1.2); 
            %FPST_1st_results_new(subjects{i}, sequences{j}, 'cue_Qboth_side_single_regressor_no_null_PE_last_modified_outcome_unitary_model_with_shake_duration', '_2_derivative', 'Qboth_single_regressor_PE_last');
            %cd [Home Directory]/analyses/fmri
            
            %% old analyses ------------------
            %FPST_1st_level_new currently set to Qunchosen
            %FPST_1st_level_new(subjects{i}, sequences{j}, 'reversed_PE_cue_Qboth_side_single_regressor_no_null_PE_last_modified_outcome', '_2_derivative',  'cue_Qboth', 'side_PE_last','_task_results_both_phases_asymmetrical_normal_temperature', 0, 1.2); 
            %FPST_1st_results_new(subjects{i}, sequences{j}, 'reversed_PE_cue_Qboth_side_single_regressor_no_null_PE_last_modified_outcome', '_2_derivative', 'Qboth_single_regressor_PE_last');
            %cd [Home Directory]/analyses/fmri
           
           % FPST_1st_level_new(subjects{i}, sequences{j}, 'cue_Qboth_side_single_regressor_no_null_PE_last_modified_outcome', '_2_derivative',  'cue_Qboth', 'side_PE_last','_task_results_both_phases_asymmetrical_normal_temperature', 0, 1.2); 
           % FPST_1st_results_new(subjects{i}, sequences{j}, 'cue_Qboth_side_single_regressor_no_null_PE_last_modified_outcome', '_2_derivative', 'Qboth_single_regressor_PE_last');
           % cd [Home Directory]/analyses/fmri
          %----------------
            
           % FPST_1st_level_new(subjects{i}, sequences{j}, 'cue_Qdelta_choice_side_PE_last_modified_outcome_no_null', '_2_derivative',  'cue_Qboth', 'side_PE_last','_task_results_both_phases_asymmetrical_normal_temperature', 0, 1.2); 
           % FPST_1st_results_new(subjects{i}, sequences{j}, 'cue_Qdelta_choice_side_PE_last_modified_outcome_no_null', '_2_derivative', 'Qboth_sided_PE_last');
           % cd [Home Directory]/analyses/fmri
            
           % FPST_1st_level_new(subjects{i}, sequences{j}, 'choice_onset_Qdelta_choice_side_PE_last_modified_outcome_no_null', '_2_derivative',  'cue_Qboth', 'side_PE_last','_task_results_both_phases_asymmetrical_normal_temperature', 0, 1.2); 
            %FPST_1st_results_new(subjects{i}, sequences{j}, 'choice_onset_Qdelta_choice_side_PE_last_modified_outcome_no_null', '_2_derivative', 'Qboth_sided_PE_last');
           % cd [Home Directory]/analyses/fmri
            
       %{     
           % FPST_1st_level_corrected_order(subjects{i}, sequences{j}, 'cue_Qboth_side_single_regressor_no_ortho_corrected_order_PE_last', '_1_derivative',  'cue_Qboth', 'side_single_regressor_PE_last');
          % FPST_1st_results_corrected_order(subjects{i}, sequences{j}, 'cue_Qboth_side_single_regressor_no_ortho_corrected_order_PE_last', '_1_derivative', 'Qboth_single_regressor_PE_last');
          % cd [Home Directory]/analyses/fmri
        
         % FPST_1st_level_corrected_order(subjects{i}, sequences{j}, 'cue_Qboth_side_single_regressor_no_ortho_corrected_order_PE_last', '_2_derivative',  'cue_Qboth', 'side_single_regressor_PE_last');
          % FPST_1st_results_corrected_order(subjects{i}, sequences{j}, 'cue_Qboth_side_single_regressor_no_ortho_corrected_order_PE_last', '_2_derivative', 'Qboth_single_regressor_PE_last');
          % cd [Home Directory]/analyses/fmri
           
         %  FPST_1st_level_corrected_order(subjects{i}, sequences{j}, 'cue_Qboth_side_single_regressor_corrected_order_Qs_last', '_1_derivative',  'cue_Qboth', 'side_single_regressor_Qs_last');
        %   FPST_1st_results_corrected_order(subjects{i}, sequences{j}, 'cue_Qboth_side_single_regressor_corrected_order_Qs_last', '_1_derivative', 'Qboth_single_regressor_Qs_last');
        %   cd [Home Directory]/analyses/fmri
        
        %   FPST_1st_level_corrected_order(subjects{i}, sequences{j}, 'cue_Qboth_side_single_regressor_corrected_order_Qs_last', '_2_derivative',  'cue_Qboth', 'side_single_regressor_Qs_last');
        %   FPST_1st_results_corrected_order(subjects{i}, sequences{j}, 'cue_Qboth_side_single_regressor_corrected_order_Qs_last', '_2_derivative', 'Qboth_single_regressor_Qs_last');
        %   cd [Home Directory]/analyses/fmri
           % FPST_1st_level_corrected_order(subjects{i}, sequences{j}, 'cue_Qboth_side_single_regressor_corrected_order_PE_last_modified_outcome', '_2_derivative',  'cue_Qboth', 'side_single_regressor_PE_last','_task_results_both_phases_asymmetrical_normal_temperature', 0); 
           %FPST_1st_results_corrected_order(subjects{i}, sequences{j}, 'cue_Qboth_side_single_regressor_corrected_order_PE_last_modified_outcome', '_2_derivative', 'Qboth_single_regressor_PE_last');
           %cd [Home Directory]/analyses/fmri
               
           %FPST_1st_level_corrected_order(subjects{i}, sequences{j}, 'cue_Qboth_side_single_regressor_corrected_order_PE_last_modified_outcome_duration_31', '_2_derivative',  'cue_Qboth', 'side_single_regressor_PE_last','_task_results_both_phases_asymmetrical_normal_temperature', 3.1); 
           %FPST_1st_results_corrected_order(subjects{i}, sequences{j}, 'cue_Qboth_side_single_regressor_corrected_order_PE_last_modified_outcome_duration_31', '_2_derivative', 'Qboth_single_regressor_PE_last');
           %cd [Home Directory]/analyses/fmri
        %{   
           FPST_1st_level_new(subjects{i}, sequences{j}, 'cue_Qdelta_side_single_regressor_corrected_order_PE_last_modified_outcome', '_2_derivative',  'cue_Qboth', 'side_single_regressor_PE_last','_task_results_both_phases_asymmetrical_normal_temperature', 0); 
           FPST_1st_results_new(subjects{i}, sequences{j}, 'cue_Qdelta_side_single_regressor_corrected_order_PE_last_modified_outcome', '_2_derivative', 'Qboth_single_regressor_PE_last');
           cd [Home Directory]/analyses/fmri
               
           FPST_1st_level_new(subjects{i}, sequences{j}, 'cue_Qdelta_side_single_regressor_corrected_order_PE_last_modified_outcome_duration_31', '_2_derivative',  'cue_Qboth', 'side_single_regressor_PE_last','_task_results_both_phases_asymmetrical_normal_temperature', 3.1); 
          FPST_1st_results_new(subjects{i}, sequences{j}, 'cue_Qdelta_side_single_regressor_corrected_order_PE_last_modified_outcome_duration_31', '_2_derivative', 'Qboth_single_regressor_PE_last');
           cd [Home Directory]/analyses/fmri
          %} 
           
           FPST_1st_level_new(subjects{i}, sequences{j}, 'cue_Qdelta_side_single_regressor_corrected_order_PE_last_modified_outcome', '_1_derivative',  'cue_Qboth', 'side_single_regressor_PE_last','_task_results_both_phases_asymmetrical_normal_temperature', 0, 1.2); 
           FPST_1st_results_new(subjects{i}, sequences{j}, 'cue_Qdelta_side_single_regressor_corrected_order_PE_last_modified_outcome', '_1_derivative', 'Qboth_single_regressor_PE_last');
           cd [Home Directory]/analyses/fmri
               
           FPST_1st_level_new(subjects{i}, sequences{j}, 'cue_Qdelta_side_single_regressor_corrected_order_PE_last_modified_outcome_duration_31', '_1_derivative',  'cue_Qboth', 'side_single_regressor_PE_last','_task_results_both_phases_asymmetrical_normal_temperature', 3.1, 1.2); 
          FPST_1st_results_new(subjects{i}, sequences{j}, 'cue_Qdelta_side_single_regressor_corrected_order_PE_last_modified_outcome_duration_31', '_1_derivative', 'Qboth_single_regressor_PE_last');
           cd [Home Directory]/analyses/fmri
           
           FPST_1st_level_new(subjects{i}, sequences{j}, 'cue_Qdelta_side_single_regressor_corrected_order_PE_last_modified_outcome_time_1', '_1_derivative',  'cue_Qboth', 'side_single_regressor_PE_last','_task_results_both_phases_asymmetrical_normal_temperature', 0, 1.0); 
           FPST_1st_results_new(subjects{i}, sequences{j}, 'cue_Qdelta_side_single_regressor_corrected_order_PE_last_modified_outcome_time_1', '_1_derivative', 'Qboth_single_regressor_PE_last');
           cd [Home Directory]/analyses/fmri
               
           FPST_1st_level_new(subjects{i}, sequences{j}, 'cue_Qdelta_side_single_regressor_corrected_order_PE_last_modified_outcome_duration_33_time_1', '_1_derivative',  'cue_Qboth', 'side_single_regressor_PE_last','_task_results_both_phases_asymmetrical_normal_temperature', 3.3, 1.0); 
          FPST_1st_results_new(subjects{i}, sequences{j}, 'cue_Qdelta_side_single_regressor_corrected_order_PE_last_modified_outcome_duration_33_time_1', '_1_derivative', 'Qboth_single_regressor_PE_last');
           cd [Home Directory]/analyses/fmri
           
             FPST_1st_level_new(subjects{i}, sequences{j}, 'cue_Qdelta_side_single_regressor_corrected_order_PE_last_modified_outcome_time_14', '_1_derivative',  'cue_Qboth', 'side_single_regressor_PE_last','_task_results_both_phases_asymmetrical_normal_temperature', 0, 1.4); 
           FPST_1st_results_new(subjects{i}, sequences{j}, 'cue_Qdelta_side_single_regressor_corrected_order_PE_last_modified_outcome_time_14', '_1_derivative', 'Qboth_single_regressor_PE_last');
           cd [Home Directory]/analyses/fmri
               
           FPST_1st_level_new(subjects{i}, sequences{j}, 'cue_Qdelta_side_single_regressor_corrected_order_PE_last_modified_outcome_duration_29_time_14', '_1_derivative',  'cue_Qboth', 'side_single_regressor_PE_last','_task_results_both_phases_asymmetrical_normal_temperature', 2.9, 1.4); 
          FPST_1st_results_new(subjects{i}, sequences{j}, 'cue_Qdelta_side_single_regressor_corrected_order_PE_last_modified_outcome_duration_29_time_14', '_1_derivative', 'Qboth_single_regressor_PE_last');
           cd [Home Directory]/analyses/fmri
           
           %
           FPST_1st_level_new(subjects{i}, sequences{j}, 'cue_Qdelta_side_single_regressor_corrected_order_PE_last_modified_outcome_time_1', '_2_derivative',  'cue_Qboth', 'side_single_regressor_PE_last','_task_results_both_phases_asymmetrical_normal_temperature', 0, 1.0); 
           FPST_1st_results_new(subjects{i}, sequences{j}, 'cue_Qdelta_side_single_regressor_corrected_order_PE_last_modified_outcome_time_1', '_2_derivative', 'Qboth_single_regressor_PE_last');
           cd [Home Directory]/analyses/fmri
               
           FPST_1st_level_new(subjects{i}, sequences{j}, 'cue_Qdelta_side_single_regressor_corrected_order_PE_last_modified_outcome_duration_33_time_1', '_2_derivative',  'cue_Qboth', 'side_single_regressor_PE_last','_task_results_both_phases_asymmetrical_normal_temperature', 3.3, 1.0); 
          FPST_1st_results_new(subjects{i}, sequences{j}, 'cue_Qdelta_side_single_regressor_corrected_order_PE_last_modified_outcome_duration_33_time_1', '_2_derivative', 'Qboth_single_regressor_PE_last');
           cd [Home Directory]/analyses/fmri
           
             FPST_1st_level_new(subjects{i}, sequences{j}, 'cue_Qdelta_side_single_regressor_corrected_order_PE_last_modified_outcome_time_14', '_2_derivative',  'cue_Qboth', 'side_single_regressor_PE_last','_task_results_both_phases_asymmetrical_normal_temperature', 0, 1.4); 
           FPST_1st_results_new(subjects{i}, sequences{j}, 'cue_Qdelta_side_single_regressor_corrected_order_PE_last_modified_outcome_time_14', '_2_derivative', 'Qboth_single_regressor_PE_last');
           cd [Home Directory]/analyses/fmri
               
           FPST_1st_level_new(subjects{i}, sequences{j}, 'cue_Qdelta_side_single_regressor_corrected_order_PE_last_modified_outcome_duration_29_time_14', '_2_derivative',  'cue_Qboth', 'side_single_regressor_PE_last','_task_results_both_phases_asymmetrical_normal_temperature', 2.9, 1.4); 
          FPST_1st_results_new(subjects{i}, sequences{j}, 'cue_Qdelta_side_single_regressor_corrected_order_PE_last_modified_outcome_duration_29_time_14', '_2_derivative', 'Qboth_single_regressor_PE_last');
           cd [Home Directory]/analyses/fmri
           
            %FPST_1st_level(subjects{i}, sequences{j}, 'cue_Qchosen' ,'_1_derivative', 'cue_Qchosen'); 
            %FPST_1st_results(subjects{i}, sequences{j}, 'cue_Qchosen', '_1_derivative', 'Qchosen_no_cue'');
            %cd [Home Directory]/analyses/fmri
        
           % FPST_1st_level(subjects{i}, sequences{j}, 'cue_Qboth_sided', '_2_derivative',  'cue_Qboth_sided');
           % FPST_1st_results(subjects{i}, sequences{j}, 'cue_Qboth_sided', '_2_derivative', 'Qboth_sided_no_cue');
           % cd [Home Directory]/analyses/fmri
            
           %FPST_1st_level(subjects{i}, sequences{j}, 'cue_Qboth', '_2_derivative',  'cue_Qboth');
           %FPST_1st_results(subjects{i}, sequences{j}, 'cue_Qboth', '_2_derivative', 'Qboth_no_cue');
           %cd [Home Directory]/analyses/fmri
            
           
           %FPST_1st_level(subjects{i}, sequences{j}, 'cue_Qboth_side_single_regressor', '_2_derivative',  'cue_Qboth_sided', 'single_regressor');
           %FPST_1st_results(subjects{i}, sequences{j}, 'cue_Qboth_side_single_regressor', '_2_derivative', 'Qboth_sided_single_regressor');
           %cd [Home Directory]/analyses/fmri
            
           %FPST_1st_level(subjects{i}, sequences{j}, 'cue_Qboth_side_single_regressor', '_1_derivative',  'cue_Qboth_sided', 'single_regressor');
           %FPST_1st_results(subjects{i}, sequences{j}, 'cue_Qboth_side_single_regressor', '_1_derivative', 'Qboth_sided_single_regressor');
           %cd [Home Directory]/analyses/fmri
           
           %FPST_1st_level(subjects{i}, sequences{j}, 'cue_Qboth_single_regressor', '_2_derivative',  'cue_Qboth', 'single_regressor');
           %FPST_1st_results(subjects{i}, sequences{j}, 'cue_Qboth_single_regressor', '_2_derivative', 'Qboth_single_regressor');
           %cd [Home Directory]/analyses/fmri
            
           %FPST_1st_level(subjects{i}, sequences{j}, 'cue_Qboth_single_regressor', '_1_derivative',  'cue_Qboth', 'single_regressor');
           %FPST_1st_results(subjects{i}, sequences{j}, 'cue_Qboth_single_regressor', '_1_derivative', 'Qboth_single_regressor');
           %cd [Home Directory]/analyses/fmri
           
            %     FPST_1st_level(subjects{i}, sequences{j}, 'cue_Qboth', '_2_derivative',  'cue_Qboth', 'single_regressor');
           %FPST_1st_results(subjects{i}, sequences{j}, 'cue_Qboth', '_2_derivative', 'Qboth_sided_single_regressor'');
           %cd [Home Directory]/analyses/fmri
            
           
           
           
           %{
            FPST_1st_level(subjects{i}, sequences{j}, 'Qchosen_no_cue' ,'_1_derivative', 'no_cue');
            FPST_1st_results(subjects{i}, sequences{j}, 'Qchosen_no_cue', '_1_derivative', 'Qchosen');
            cd [Home Directory]/analyses/fmri

            FPST_1st_level(subjects{i}, sequences{j}, 'Qchosen_no_cue', '_2_derivative',  'no_cue');
            FPST_1st_results(subjects{i}, sequences{j}, 'Qchosen_no_cue', '_2_derivative', 'Qchosen');
            cd [Home Directory]/analyses/fmri
            
            FPST_1st_level(subjects{i}, sequences{j}, 'Qboth_no_cue' ,'_1_derivative', 'Qboth_no_cue');
            FPST_1st_results(subjects{i}, sequences{j}, 'Qboth_no_cue', '_1_derivative', 'Qboth');
            cd [Home Directory]/analyses/fmri
        
            FPST_1st_level(subjects{i}, sequences{j}, 'Qboth_no_cue', '_2_derivative',  'Qboth_no_cue');
            FPST_1st_results(subjects{i}, sequences{j}, 'Qboth_no_cue', '_2_derivative', 'Qboth');
            cd [Home Directory]/analyses/fmri
           %}
            %FPST_1st_level(subjects{i}, sequences{j}, 'unitary' ,'_1_derivative', 'with_cue', '' ,'_task_results_only_learn_phase_unitary_normal_temperature');
            %FPST_1st_results(subjects{i}, sequences{j}, 'unitary', '_1_derivative');
            %cd [Home Directory]/analyses/fmri

            %FPST_1st_level(subjects{i}, sequences{j}, 'unitary', '_2_derivative',  'with_cue', '', '_task_results_only_learn_phase_unitary_normal_temperature');
            %FPST_1st_results(subjects{i}, sequences{j}, 'unitary', '_2_derivative');
            %cd [Home Directory]/analyses/fmri
            
            
            %FPST_1st_level(subjects{i}, sequences{j}, 'Qboth_choice_side_no_cue' ,'_1_derivative', 'Qboth_choice_side_no_cue'); 
            %FPST_1st_results(subjects{i}, sequences{j}, 'Qboth_choice_side_no_cue', '_1_derivative', 'Qboth_sided_no_cue');
            %cd [Home Directory]/analyses/fmri
        
            %FPST_1st_level(subjects{i}, sequences{j}, 'Qboth_choice_side_no_cue', '_2_derivative',  'Qboth_choice_side_no_cue');
            %FPST_1st_results(subjects{i}, sequences{j}, 'Qboth_choice_side_no_cue', '_2_derivative', 'Qboth_sided_no_cue');
            %cd [Home Directory]/analyses/fmri
            
            %FPST_1st_level(subjects{i}, sequences{j}, 'Qboth_choice_side' ,'_1_derivative', 'Qboth_choice_side'); 
            %FPST_1st_results(subjects{i}, sequences{j}, 'Qboth_choice_side', '_1_derivative', 'Qboth_sided');
            %cd [Home Directory]/analyses/fmri
        
            %FPST_1st_level(subjects{i}, sequences{j}, 'Qboth_choice_side', '_2_derivative',  'Qboth_choice_side');
            %FPST_1st_results(subjects{i}, sequences{j}, 'Qboth_choice_side', '_2_derivative', 'Qboth_sided');
            %cd [Home Directory]/analyses/fmri
                %}        
        elseif strcmp(sequences{j},'transfer') && not(strcmp(subjects{i},'7873'))
            
           analysis2 = 'cross'; %or null. I think this doens't do much anymore... 
%{
done for now            
           FPST_1st_level_new(subjects{i}, sequences{j}, 'long_cue_asymmetrical', '_2_derivative', 'QchosenTest', analysis2, '_task_results_both_phases_asymmetrical_normal_temperature');
           FPST_1st_results_new(subjects{i}, sequences{j}, 'long_cue_asymmetrical', '_2_derivative', 'QchosenTest', analysis2 );
            cd [Home Directory]/analyses/fmri
           

            
            FPST_1st_level_new(subjects{i}, sequences{j}, 'long_cue_unitary', '_2_derivative', 'QchosenTest', analysis2, '_task_results_only_learn_phase_unitary_normal_temperature');
           FPST_1st_results_new(subjects{i}, sequences{j}, 'long_cue_unitary', '_2_derivative', 'QchosenTest', analysis2 );
            cd [Home Directory]/analyses/fmri
%}
           %FPST_1st_level_new(subjects{i}, sequences{j}, 'long_cue_asymmetrical', '_2_derivative', 'QchosenTest', analysis2, '_task_results_only_learn_phase_unitary_normal_temperature');
           %FPST_1st_results_new(subjects{i}, sequences{j}, 'long_cue_asymmetrical', '_2_derivative', 'QchosenTest', analysis2 );
            cd [Home Directory]/analyses/fmri
           
        %  FPST_1st_level_new(subjects{i}, sequences{j}, 'long_cue_asymmetrical', '_2_derivative', 'Vstate', analysis2, '_task_results_both_phases_asymmetrical_normal_temperature');
         %  FPST_1st_results_new(subjects{i}, sequences{j}, 'long_cue_asymmetrical', '_2_derivative', 'Vstate', analysis2 );
          %  cd [Home Directory]/analyses/fmri
           
%%%            FPST_1st_level_new(subjects{i}, sequences{j}, 'long_cue_asymmetrical', '_2_derivative', 'Vrelative', analysis2, '_task_results_both_phases_asymmetrical_normal_temperature');
 %%%         FPST_1st_results_new(subjects{i}, sequences{j}, 'long_cue_asymmetrical', '_2_derivative', 'Vrelative', analysis2 );
  %%%        cd [Home Directory]/analyses/fmri
         
  
  %%%          FPST_1st_level_new(subjects{i}, sequences{j}, 'long_cue_asymmetrical', '_2_derivative', 'shiner', analysis2, '_task_results_both_phases_asymmetrical_normal_temperature');
  %%%         FPST_1st_results_new(subjects{i}, sequences{j}, 'long_cue_asymmetrical', '_2_derivative', 'shiner', analysis2 );
  %%%          cd [Home Directory]/analyses/fmri
           
         
            
            
           %FPST_1st_level(subjects{i}, sequences{j}, 'long_cue', '_1_derivative', 'chooseavoid', analysis2);
            %FPST_1st_results(subjects{i}, sequences{j}, 'long_cue', '_1_derivative', 'chooseavoid', analysis2);
           % cd [Home Directory]/analyses/fmri
           
            %FPST_1st_level_new(subjects{i}, sequences{j}, 'long_cue_asymmetrical', '_2_derivative', 'chooseavoid_3pm', analysis2, '_task_results_both_phases_asymmetrical_normal_temperature');
           %FPST_1st_results_new(subjects{i}, sequences{j}, 'long_cue_asymmetrical', '_2_derivative', 'chooseavoid_3pm', analysis2);
            cd [Home Directory]/analyses/fmri
           
           % FPST_1st_level_new(subjects{i}, sequences{j}, 'long_cue_asymmetrical_no_ortho', '_2_derivative', 'chooseavoid_3pm', analysis2, '_task_results_both_phases_asymmetrical_normal_temperature');
          % FPST_1st_results_new(subjects{i}, sequences{j}, 'long_cue_asymmetrical_no_ortho', '_2_derivative', 'chooseavoid_3pm', analysis2);
          %  cd [Home Directory]/analyses/fmri
            
          % FPST_1st_level_new(subjects{i}, sequences{j}, 'long_cue_asymmetrical', '_2_derivative', 'chooseavoid', analysis2, '_task_results_both_phases_asymmetrical_normal_temperature');
           %FPST_1st_results_new(subjects{i}, sequences{j}, 'long_cue_asymmetrical', '_2_derivative', 'chooseavoid', analysis2);
          %  cd [Home Directory]/analyses/fmri
          
           FPST_1st_level_new(subjects{i}, sequences{j}, 'long_cue_asymmetrical', '_2_derivative', 'chooseavoid_noQ', analysis2, '_task_results_both_phases_asymmetrical_normal_temperature');
          FPST_1st_results_new(subjects{i}, sequences{j}, 'long_cue_asymmetrical', '_2_derivative', 'chooseavoid_noQ', analysis2);
            cd [Home Directory]/analyses/fmri
            
            %FPST_1st_level_new(subjects{i}, sequences{j}, 'long_cue_asymmetrical', '_2_derivative', 'A_B_overOthers', analysis2, '_task_results_both_phases_asymmetrical_normal_temperature');
          % FPST_1st_results_new(subjects{i}, sequences{j}, 'long_cue_asymmetrical', '_2_derivative', 'A_B_overOthers', analysis2);
           cd [Home Directory]/analyses/fmri
            
          
          % FPST_1st_level_new(subjects{i}, sequences{j}, 'long_cue_unitary', '_2_derivative', 'chooseavoid', analysis2, '_task_results_only_learn_phase_unitary_normal_temperature');
          % FPST_1st_results_new(subjects{i}, sequences{j}, 'long_cue_unitary', '_2_derivative', 'chooseavoid', analysis2);
          % cd [Home Directory]/analyses/fmri
            
         %  FPST_1st_level_new(subjects{i}, sequences{j}, 'long_cue_unitary', '_2_derivative', 'chooseavoid_noQ', analysis2, '_task_results_only_learn_phase_unitary_normal_temperature');
         %  FPST_1st_results_new(subjects{i}, sequences{j}, 'long_cue_unitary', '_2_derivative', 'chooseavoid_noQ', analysis2);
          % cd [Home Directory]/analyses/fmri
          
           %FPST_1st_level(subjects{i}, sequences{j}, 'long_cue', '_1_derivative', 'winlose', analysis2);
           %FPST_1st_results(subjects{i}, sequences{j}, 'long_cue', '_1_derivative', 'winlose', analysis2);
           %cd [Home Directory]/analyses/fmri

      %  FPST_1st_level_new(subjects{i}, sequences{j}, 'long_cue_asymmetrical', '_2_derivative', 'winlose', analysis2, '_task_results_both_phases_asymmetrical_normal_temperature');
     %FPST_1st_results_new(subjects{i}, sequences{j}, 'long_cue_asymmetrical', '_2_derivative', 'winlose', analysis2);
           cd [Home Directory]/analyses/fmri
%            
%        FPST_1st_level_new(subjects{i}, sequences{j}, 'long_cue_unitary', '_2_derivative', 'winlose', analysis2, '_task_results_only_learn_phase_unitary_normal_temperature');
%       FPST_1st_results_new(subjects{i}, sequences{j}, 'long_cue_unitary', '_2_derivative', 'winlose', analysis2);
 %          cd [Home Directory]/analyses/fmri
           
         %   FPST_1st_level(subjects{i}, sequences{j}, 'long_cue', '_1_derivative', 'Vrel', analysis2);
         %   FPST_1st_results(subjects{i}, sequences{j}, 'long_cue', '_1_derivative', 'Vrel', analysis2);
          %  cd [Home Directory]/analyses/fmri

      %%%     FPST_1st_level(subjects{i}, sequences{j}, 'long_cue', '_2_derivative', 'Vrelative', analysis2);
      %%%     FPST_1st_results_new(subjects{i}, sequences{j}, 'long_cue', '_2_derivative', 'Vrelative', analysis2);
           cd [Home Directory]/analyses/fmri
          
          
          
        end
        close all;
        fprintf('\nfinishing 1st level for %s sequence %s. it took %s\n', subjects{i}, sequences{j}, datetime('now') - startclock);
    end
end


%FPST_2nd_Level('cue_Qchosen_no_null_PE_last_initStateZero_with_shake_duration_31_2_derivative', 'learning', 'only_Qchosen', '', '');
%
%FPST_2nd_Level('cue_Qchosen_no_null_PE_last_asymmetrical_learning_with_shake_duration_31_2_derivative', 'learning', 'Qchosen_long', '_wanting_plus_liking', 'wpl_pretest');
%FPST_2nd_Level('cue_Qchosen_no_null_PE_last_unitary_model_with_shake_duration_31_2_derivative', 'learning', 'Qchosen_long', '_wanting_plus_liking', 'wpl_pretest');

%{
FPST_2nd_Level('cue_Qchosen_no_null_PE_last_asymmetrical_learning_with_shake_duration_31_2_derivative', 'learning', 'S+>S-', '_wanting_plus_liking', 'wpl_pretest');
FPST_2nd_Level('cue_Qchosen_no_null_PE_last_unitary_model_with_shake_duration_31_2_derivative', 'learning', 'S+>S-', '_wanting_plus_liking', 'wpl_pretest');

FPST_2nd_Level('cue_Qchosen_no_null_PE_last_asymmetrical_learning_with_shake_duration_31_2_derivative', 'learning', 'S+<S-', '_wanting_plus_liking', 'wpl_pretest');
FPST_2nd_Level('cue_Qchosen_no_null_PE_last_unitary_model_with_shake_duration_31_2_derivative', 'learning', 'S+<S-', '_wanting_plus_liking', 'wpl_pretest');


FPST_2nd_Level('cue_Qchosen_no_null_PE_last_asymmetrical_learning_with_shake_duration_31_2_derivative', 'learning', 'S+&S-', '_wanting_plus_liking', 'wpl_pretest');
FPST_2nd_Level('cue_Qchosen_no_null_PE_last_unitary_model_with_shake_duration_31_2_derivative', 'learning', 'S+&S-', '_wanting_plus_liking', 'wpl_pretest');


FPST_2nd_Level('cue_Qchosen_no_null_PE_last_asymmetrical_learning_with_shake_duration_31_2_derivative', 'learning', 'PE+>PE-', '_wanting_plus_liking', 'wpl_pretest');
FPST_2nd_Level('cue_Qchosen_no_null_PE_last_unitary_model_with_shake_duration_31_2_derivative', 'learning', 'PE+>PE-', '_wanting_plus_liking', 'wpl_pretest');

FPST_2nd_Level('cue_Qchosen_no_null_PE_last_asymmetrical_learning_with_shake_duration_31_2_derivative', 'learning', 'PE+<PE-', '_wanting_plus_liking', 'wpl_pretest');
FPST_2nd_Level('cue_Qchosen_no_null_PE_last_unitary_model_with_shake_duration_31_2_derivative', 'learning', 'PE+<PE-', '_wanting_plus_liking', 'wpl_pretest');


FPST_2nd_Level('cue_Qchosen_no_null_PE_last_asymmetrical_learning_with_shake_duration_31_2_derivative', 'learning', 'PE+&PE-', '_wanting_plus_liking', 'wpl_pretest');
FPST_2nd_Level('cue_Qchosen_no_null_PE_last_unitary_model_with_shake_duration_31_2_derivative', 'learning', 'PE+&PE-', '_wanting_plus_liking', 'wpl_pretest');
%}

%FPST_2nd_Level('long_cue_asymmetrical_2_derivative', 'transfer', 'Vstate', '_wanting_plus_liking', 'wpl_pretest', 'cross');
%FPST_2nd_Level('long_cue_asymmetrical_2_derivative', 'transfer', 'Vrelative', '_wanting_plus_liking', 'wpl_pretest', 'cross');

%FPST_2nd_Level('long_cue_asymmetrical_2_derivative', 'transfer', 'QchosenTest', '_wanting_plus_liking', 'wpl_pretest', 'cross');
%FPST_2nd_Level('long_cue_asymmetrical_2_derivative', 'transfer', 'only_QchosenTest', '_wanting_plus_liking', 'wpl_pretest', 'cross');

%FPST_2nd_Level('long_cue_asymmetrical_2_derivative', 'transfer', 'chooseavoid_noQ', '_wanting_plus_liking', 'wpl_pretest', 'cross');
%FPST_2nd_Level('long_cue_asymmetrical_2_derivative', 'transfer', 'chooseavoid_3pm', '_wanting_plus_liking', 'wpl_pretest', 'cross');
%FPST_2nd_Level('long_cue_asymmetrical_2_derivative', 'transfer', 'winlose', '_wanting_plus_liking', 'wpl_pretest', 'cross');
%FPST_2nd_Level('long_cue_asymmetrical_2_derivative', 'transfer', 'winlose', '_conflicts_', '', 'cross');

%FPST_2nd_Level('long_cue_unitary_2_derivative', 'transfer', 'chooseavoid_noQ', '_wanting_plus_liking', 'wpl_pretest', 'cross');
%FPST_2nd_Level('long_cue_unitary_2_derivative', 'transfer', 'winlose', '_wanting_plus_liking', 'wpl_pretest', 'cross');

%%%%
%{
FPST_2nd_Level('long_cue_asymmetrical_2_derivative', 'transfer', 'chooseavoid_3pm', '_B_over_A_Others_', '', 'cross');
FPST_2nd_Level('long_cue_asymmetrical_2_derivative', 'transfer', 'chooseavoid_noQ', '_B_over_A', '', 'cross');

FPST_2nd_Level('cue_Qchosen_no_null_PE_last_asymmetrical_learning_with_shake_duration_31_2_derivative', 'learning', 'S+&S-');
FPST_2nd_Level('cue_Qchosen_no_null_PE_last_unitary_model_with_shake_duration_31_2_derivative', 'learning', 'S+&S-');
%}
%

%%%% 2021-08-16 for dissertation, make sure with 4643 (9 people)
%FPST_2nd_Level('cue_Qchosen_no_null_PE_last_asymmetrical_learning_with_shake_duration_31_2_derivative', 'learning', 'only_cue', '', '');
%FPST_2nd_Level('cue_Qchosen_no_null_PE_last_unitary_model_with_shake_duration_31_2_derivative', 'learning', 'only_cue', '', '');

%FPST_2nd_Level('cue_Qchosen_no_null_PE_last_asymmetrical_learning_with_shake_duration_31_2_derivative', 'learning', 'only_Qchosen', '', '');
%FPST_2nd_Level('cue_Qchosen_no_null_PE_last_unitary_model_with_shake_duration_31_2_derivative', 'learning', 'only_Qchosen', '', '');

%FPST_2nd_Level('cue_Qchosen_no_null_PE_last_asymmetrical_learning_with_shake_duration_31_2_derivative', 'learning', 'Shake+', '', '');
%FPST_2nd_Level('cue_Qchosen_no_null_PE_last_unitary_model_with_shake_duration_31_2_derivative', 'learning', 'Shake+', '', '');

%FPST_2nd_Level('cue_Qchosen_no_null_PE_last_asymmetrical_learning_with_shake_duration_31_2_derivative', 'learning', 'S+>S-', '', '');
%FPST_2nd_Level('cue_Qchosen_no_null_PE_last_unitary_model_with_shake_duration_31_2_derivative', 'learning', 'S+>S-', '', '');

%FPST_2nd_Level('cue_Qchosen_no_null_PE_last_asymmetrical_learning_with_shake_duration_31_2_derivative', 'learning', 'S+&S-', '', '');
%FPST_2nd_Level('cue_Qchosen_no_null_PE_last_unitary_model_with_shake_duration_31_2_derivative', 'learning', 'S+&S-', '', '');

%FPST_2nd_Level('cue_Qchosen_no_null_PE_last_asymmetrical_learning_with_shake_duration_31_2_derivative', 'learning', 'PE+', '', '');
%FPST_2nd_Level('cue_Qchosen_no_null_PE_last_unitary_model_with_shake_duration_31_2_derivative', 'learning', 'PE+-', '', '');

%FPST_2nd_Level('cue_Qchosen_no_null_PE_last_asymmetrical_learning_with_shake_duration_31_2_derivative', 'learning', 'PE+>PE-', '', '');
%FPST_2nd_Level('cue_Qchosen_no_null_PE_last_unitary_model_with_shake_duration_31_2_derivative', 'learning', 'PE+>PE-', '', '');

%FPST_2nd_Level('cue_Qchosen_no_null_PE_last_asymmetrical_learning_with_shake_duration_31_2_derivative', 'learning', 'PE+&PE-', '', '');
%FPST_2nd_Level('cue_Qchosen_no_null_PE_last_unitary_model_with_shake_duration_31_2_derivative', 'learning', 'PE+&PE-', '', '');


%FPST_2nd_Level('long_cue_asymmetrical_2_derivative', 'transfer', 'Vstate', '', '', 'cross');
%FPST_2nd_Level('long_cue_asymmetrical_2_derivative', 'transfer', 'Vrelative', '', '', 'cross');

%FPST_2nd_Level('long_cue_asymmetrical_2_derivative', 'transfer', 'QchosenTest', '', '', 'cross');
%FPST_2nd_Level('long_cue_asymmetrical_2_derivative', 'transfer', 'only_QchosenTest', '', '', 'cross');

%FPST_2nd_Level('long_cue_asymmetrical_2_derivative', 'transfer', 'chooseavoid', '', '', 'cross');
FPST_2nd_Level('long_cue_asymmetrical_2_derivative', 'transfer', 'chooseavoid_noQ', '', '', 'cross');
%FPST_2nd_Level('long_cue_asymmetrical_2_derivative', 'transfer', 'A_B_overOthers', '', '', 'cross');

%FPST_2nd_Level('long_cue_asymmetrical_2_derivative', 'transfer', 'chooseavoid_3pm', '', '', 'cross');
%FPST_2nd_Level('long_cue_asymmetrical_2_derivative', 'transfer', 'winlose', '', '', 'cross');
%FPST_2nd_Level('long_cue_asymmetrical_2_derivative', 'transfer', 'winlose', '_conflicts_', '', 'cross');

%FPST_2nd_Level('long_cue_unitary_2_derivative', 'transfer', 'chooseavoid_noQ', '', '', 'cross');
%FPST_2nd_Level('long_cue_unitary_2_derivative', 'transfer', 'winlose', '', '', 'cross');

