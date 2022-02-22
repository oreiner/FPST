%% two regressors for outcomes. check again because I wrote that U>P has anterior insula "monitoring conflict pain"
%this is not what I ended up using!

%% single regressor
FPST_2nd_Level('cue_Qboth_side_single_regressor_no_null_PE_last_modified_outcome_2_derivative', 'learning', 'only_choice');
FPST_2nd_Level('cue_Qboth_side_single_regressor_no_null_PE_last_modified_outcome_2_derivative', 'learning', 'single_outcomes');
FPST_2nd_Level('cue_Qboth_side_single_regressor_no_null_PE_last_modified_outcome_2_derivative', 'learning', 'single_PE');

%FPST_2nd_Level('cue_Qboth_side_single_regressor_no_null_PE_last_modified_outcome_2_derivative', 'learning', 'single_Q_PE');


%%with covariates
FPST_2nd_Level('cue_Qboth_side_single_regressor_no_null_PE_last_modified_outcome_2_derivative', 'learning', 'single_PE', 
FPST_2nd_Level('cue_Qboth_side_single_regressor_no_null_PE_last_modified_outcome_2_derivative', 'learning', 'single_PE', 'wanting_plus_liking', 'wpl_both'); %problem with 7873 as he has no post

%this is an old analysis for unitary
FPST_2nd_Level('unitary_2_derivative', 'learning', 'PEs', '_wanting_plus_liking_preandpost', 'wpl_both');
FPST_2nd_Level('unitary_2_derivative', 'learning', 'PEs', 'wanting_plus_liking_pretest_BMI', 'wpl_pretest');