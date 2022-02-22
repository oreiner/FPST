%%glm_name = directory name of 1st level e.g. long_cue_1_derivate or long_cue_2_derivative
%%split = e.g. 'noQfull', 'only_shakes', 'shakes_cue', 'PEs', 'Qs', 'Qfull', 'Qchosen_long'
%%for model with only one regressor for outcomes/PE 'single_outcomes', 'single_PE', 'single_Qs'
%%sequence = learning or transfer
%%suffix = add suffix to output dir, e.g. "with_subject_4843"
%%covariates = add covariates. options bis dato: w_l_delta (wanting_delta
%%and liking delta), wpl_pretest (wanting+liking as one covariate),
%%wpl_both

%%subject 4643 needs to be added manually below

%%technically I need to check the contrasts alone. e.g. only Qchosen, only PE+
%%if I want a comparison (e.g. PE+>PE-) this needs to be done on 1st level an then looked as single contrast in 2nd level

function FPST_2nd_Level(glm_name, sequence, split, suffix, covariates, analysis2)
% run 2nd-level analysis, compute contrasts, save results report

if not(exist('split', 'var'))
    split = 0;
end

if not(exist('suffix', 'var'))
    suffix = '';
end

if not(exist('covariates', 'var'))
    covariates=0;
end


input_data       = '[Home Directory]/results/fmri/1st_level';
%load(fullfile(input_data, 'glm_name.mat'))
input_data_path  = fullfile(input_data, sequence, glm_name);
if split
    output_data_path = fullfile('[Home Directory]/results/fmri/2nd_level', sequence,[glm_name '_' split suffix]);
else
    output_data_path = fullfile('[Home Directory]/results/fmri/2nd_level', sequence,[glm_name suffix] );
end
if not(exist(output_data_path, 'dir'))
    mkdir (output_data_path);
end
spm('defaults','FMRI');



% get all subjects from folder:
subjects = {};
if isempty(subjects)
    mainData = dir(input_data_path); %get the data for the main directory
    mainIndex = [mainData.isdir] & [~ismember({mainData.name}, {'.', '..'})]; %find the index of the directories (exclude '.' and '..')
    subjects = {mainData(mainIndex).name}; %get a list of the directory names (IDs of the subjects)
end

%override to erase '4643' which is defective
%subjects = {'2899','4806','7873','8159','8904','8909','9012','9013'}; %'4643'
%subjects = {'2899','4643','4806','7873','8159','8904','8909','9012','9013'}; %

clear matlabbatch
matlabbatch{1}.spm.stats.factorial_design.dir = {output_data_path};
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(1).name = 'condition';
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(1).dept = 1;
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(1).variance = 1;
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(1).gmsca = 0;
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(1).ancova = 0;
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(2).name = 'subject';
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(2).dept = 0;
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(2).variance = 1;
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(2).gmsca = 0;
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(2).ancova = 0;

for sub = 1:numel(subjects)
    
    %%There'S a problem in this order. it's different between old (two reward regressores) and new
    %%(single regressoer)
    %1=cue, 2=shake+, 3=shake-, 6=PE+, 7=PE-, 10=choice, 11=Qchosen, 12=Qunchosen  
    %full_tags = {'Cue','Shake+', 'neg Shake+', 'Shake-', 'neg Shake-', 'PE+', 'neg PE+', 'PE-', 'neg PE-', 'PE+>PE-', 'PE+<PE-', 'PE+ & PE-', 'neg PE- & neg PE+' ...
    %             'choice', 'Qchosen, 'Qunchosen', 'Qc>Qu' 'Qc<Qu' ...
    %            };
 
    switch split
	
        %% single regressor outcomes and PE
		case 'only_choice'
            connum = [1];
            tags = {'choice', 'neg choice'};
		case 'only_cue'
            connum = [1];
            tags = {'Cue Presentation', 'neg cue'};
		case 'single_outcomes'
            connum = [6];
            tags = {'outcomes', 'neg outcomes'};
		case 'single_PE'
            connum = [7];
            tags ={'PE', 'neg PE'};
        case 'single_outcomes_PE'
            connum = [6,7];
            tags ={'outcomes', 'neg outcomes', 'PE', 'neg PE'};
		case 'single_Qs'
            connum = [2,3];
            tags = {'Qchosen', 'neg Qchosen','Qunchosen', 'neg Qunchosen'};
			
			
		%% dual regressors for pos/neg outcomes and PEs
        %%%% with new contrasts numbering 
		%1=cue, 2=Qchosen, 3=shake+, 4=Shake- 5=S+>S-,
		%6=S+<S-, 7=S+&S-,  8=PE+, , 9=PE-, 10=PE+>PE-, 11=PE+<PE-, 12=PE+&PE-
		case 'Qchosen_long'
            connum = [1,2,3,4,8,9];
            tags = {'cue','neg cue','Qchosen', 'neg Qchosen', ...
                'Shake+', 'neg Shake+', 'Shake-', 'neg Shake-' ...
                'PE+', 'neg PE+', 'PE-', 'neg PE-' ...
            };
        
        case 'only_Qchosen'
            connum = [2];
            tags = {'State-Action Value of Chosen Cue', 'neg Qchosen', ...      
            };
        
        case 'Shake+'
            connum = [3];
            tags = {'Positive Outcomes', 'neg Shake+', ...      
            };
        case 'Shake-'
            connum = [4];
            tags = {'Shake-', 'neg Shake-', ...      
            };
        
        case 'S+>S-'
            connum = [5];
            tags = {'Positive Outcomes > Negative Outcomes', 'neg S+>S-', ...      
            };
        
         case 'S+<S-'
            connum = [6];
            tags = {'S+<S-', 'neg S+<S-', ...      
            };
        
         case 'S+&S-'
            connum = [7];
            tags = {'All Outcomes', 'neg S+&S-', ...      
            };
        
         case 'PE+'
            connum = [8];
            tags = {'Positive Prediction Error', 'neg PE+', ...      
            };
        
                case 'PE+>PE-'
            connum = [10];
            tags = {'Positive PE > Negative PE', 'neg PE+>PE-', ...      
            };
  
                case 'PE+<PE-'
            connum = [11];
            tags = {'PE+<PE-', 'neg PE+<PE-', ...      
            };
  
                case 'PE+&PE-'
            connum = [12];
            tags = {'Prediction Error', 'neg PE+&PE-', ...      
            };
  
        %% tranfser cases
        % for Qchosen or Vs
        % 1=cue 2=Qchosen/Vstate/Vrelative/Vsoftmax
        % for diff cases
        % 1=Choose A or winwin 2=Qchosen 3=Avoid B or loselsoe 4=Qchosen
        % 5=A>B or Winwin>loselose 6 =A<B or winwin<loselose
        % 7=non interest or win-lose 8= A+B > non or winwin+loselose>non
        
       % case 'QchosenTest'
        %    connum = [1,2];
        %    tags = {'Cue', 'neg Cue', 'Qchosen', 'neg Qchosen' ...     
        %    };
        
        
         case 'QchosenTest'
            connum = [2];
            tags = {'State-Action Value of Chosen Cue. Testing Phase', 'neg Qchosen' ...     
            };
        %}
        %{
         case 'QchosenTest'
            connum = [1];
            tags = {'Cue Presentation. Testing Phase', 'neg Qchosen' ...     
            };
        %}
       %{
        case {'Vrelative','Qchosen','Vstate','Vsoftmax'}
            connum = [1,2];
            tags = {'Cue', 'neg Cue', split,  ['neg ' split] ...     
            };
        %}
         case {'Vrelative','Qchosen','Vstate','Vsoftmax'}
            connum = [2];
            tags = {split,  ['neg ' split] ...     
            };
         %  
         
        case {'chooseavoid_3pm'}
            connum = [1,2,3,4];
            tags = {'cues','neg cues' ,'Q Choose A', 'neg Q Choose A',  ...
                    'Q Avoid B', 'neg Q Avoid B', ...  
                    'Q others', 'neg Others', ... 
            };
        %{
        case {'chooseavoid_3pm'} %cues
            connum = [1];
            tags = {'cues' , 'neg cues'... 
            };
       %}
            %{
        case {'chooseavoid_3pm'} %A_over_B_3pm
            connum = [5];
            tags = {'A>B','A<B' ... 
            };
            %}
        %{
        case {'chooseavoid_3pm'} %A_B_over_Others_3pm
            connum = [8];
            tags = {'A+B>others','A+B<others' ... 
            };
        %}
        %{
         case {'chooseavoid_3pm'} %B_over_A_Others_3pm
            connum = [9];
            tags = {'B>A+others','B<A+others' ... 
            };
        %}
          %{  
         case {'chooseavoid'}
            connum = [1,2,3,4,5,8];
            tags = {'Choose A','neg Choose A',  'Qchosen A', 'neg Qchosen A', ...
                    'Avoid B', 'neg Avoid B', 'Qchosen B', 'neg Qchosen B', ...  
                    'Choose A > B', 'Choose A < B', 'A+B > non interest', 'A+B < non interest', ... 
            };
        %}

        %{
        case {'chooseavoid_noQ'}
            connum = [1,3,5,8];
            tags = {'Choose A','neg Choose A',  ...
                    'Avoid B', 'neg Avoid B', ...  
                    'Choose A > B', 'Choose A < B', 'A+B > non interest', 'A+B < non interest', ... 
            };
        %}
            %
            
         case {'chooseavoid_noQ'} %actually only A<B
            connum = [5];
            tags = {     'Choose A > Avoid B', 'Avoid B > Choose A' ... 
            };
        
            %{
        case {'chooseavoid_noQ'}
            connum = [2];
            tags = {'Cue Presentation. Testing Phase', 'neg Cue', ... 
            };
        %}
        case {'A_B_overOthers'} %issue with "split" variable. need to either hardcode path or analyse level 1 
            connum = [8];
            tags = {'Choose A + Avoid B > Other Trials', 'Other Trials > Choose A + Avoid B', ... 
            };

       % case {'Qchosen'} 
       %     connum = [?];
       %     tags = {     'State-Action Value of Chosen Cue in the Testing Phase', 'neg Qchosen' ... 
       %     };
        %}
        
        %{
        case 'winlose'
            connum = [1,3,7];
            tags = {'winwin','neg winwin',  ...
                    'loselose', 'neg loselose',  ...  
                    'non interest', 'neg non interest', ... 
            };
            %}
        %
         %case 'winlose'
          %  connum = [2];
          %  tags = {'Q winwin','neg Qwinwin',  ...
          %  };
        %
        
           
         case 'winlose' %only high vs low
            connum = [8];
            tags = {'high conflict > low conflict', 'high conflict < low conflict' ... 
            };
            
            
            %{
        case 'winlose' %
            connum = [1,2,3,4,5,8];
            tags = {'winwin','neg winwin',  'Qchosen winwin', 'neg Qchosen winwin', ...
                    'loselose', 'neg loselose', 'neg Qchosen loselose', 'neg Qchosen loselose', ...  
                    'winwin > loselose', 'winwin < loselose', 'high conflict > low conflict', 'high conflict < low conflict', ... 
            };
            %}
        %{
          case 'winlose' %all?
            connum = [1,2,3,4,5,8];
            tags = {'winwin','neg winwin',  'Qchosen winwin', 'neg Qchosen winwin', ...
                    'loselose', 'neg loselose', 'neg Qchosen loselose', 'neg Qchosen loselose', ...  
                    'winwin > loselose', 'winwin < loselose', 'high conflict > low conflict', 'high conflict < low conflict', ... 
            };
        %}
        %{
         case 'winlose' %only winwin-loselose
            connum = [5];
            tags = {'winwin > loselose', 'winwin < loselose' ... 
            };
        %}
        
        case 'shiner'
            connum = [1,2,3,4,5,6];
            tags = {'correct trials', 'neg correct trials', 'Qchosen correct','neg Qchosen correct',  ...
                    'incorrect trials', 'neg incorrect trials', 'Qchosen incorrect','neg Qchosen incorrect', ...
                    'Motor response', 'neg Motor response', 'fixation cross', 'neg fixation cross', ...  
                    };
		 %{ 
		 deprecated models due to wrong contrasts
        
        
        
        
        
        case 'single_cue_Qs'
            connum = [1,2,3];
            tags = {'cue','Qchosen', 'neg Qchosen','Qunchosen', 'neg Qunchosen', 'Qc>Qu', 'Qc<Qu', 'Qc & Qu', 'neg Qc & neg Qc'};
        case 'single_all'
            connum = [1,2,3,6,7];
            tags = {'cue', 'Qchosen', 'neg Qchosen','Qunchosen', 'neg Qunchosen', 'Qc>Qu', 'Qc<Qu', 'Qc & Qu', 'neg Qc & neg Qc' ...
             'outcomes', 'neg outcomes', 'PE', 'neg PE', 'outcomes>PE', 'outcomes<PE', 'outcomes & PE', 'neg outcomes & neg PE' ...   
            };
        case 'single_4_regressors'
            connum = [2,3,6,7];
            tags = {'Qchosen', 'neg Qchosen','Qunchosen', 'neg Qunchosen', 'Qc>Qu', 'Qc<Qu', 'Qc & Qu', 'neg Qc & neg Qc' ...
             'outcomes', 'neg outcomes', 'PE', 'neg PE', 'outcomes>PE', 'outcomes<PE', 'outcomes & PE', 'neg outcomes & neg PE' ...   
            };
        case 'single_Q_PE'
            connum = [2,6];
            tags ={'Qchosen', 'neg Qchosen', 'PE', 'neg PE', 'Qc>PE', 'Qc<PE', 'Qc & PE', 'neg Qc & neg PE'};
        
        case 'only_shakes'
            connum = [6,8];
            tags = {'Shake+', 'neg Shake+', 'Shake-', 'neg Shake-', 'Shake+>Shake-','Shake+<Shake-', 'Shake+ & Shake-', 'S+ & S-', 'neg S+ & neg S-'};
        case 'shakes_cue'
            connum = [1,6,8];
            tags = {'cue', 'Shake+', 'neg Shake+', 'Shake-', 'neg Shake-', 'Shake+>Shake-','Shake+<Shake-', 'S+ & S-', 'neg S+ & neg S-'};
        case 'PEs'
            connum = [7,9];
            tags = {'PE+', 'neg PE+', 'PE-', 'neg PE-', 'PE+>PE-', 'PE+<PE-', 'PE+ & PE-', 'neg PE- & neg PE+'};
        case 'Qs'
            connum = [2,3];
            tags = {'Qchosen', 'neg Qchosen','Qunchosen', 'neg Qunchosen', 'Qc>Qu', 'Qc<Qu', 'Qc & Qu', 'neg Qc & neg Qc'};
        case 'Qs_and_PEs'
            connum = [2,3,7,9];
            tags = {'Qchosen', 'neg Qchosen','Qunchosen', 'neg Qunchosen', 'Qc>Qu', 'Qc<Qu', 'Qc & Qu', 'neg Qc & neg Qc' ...
                'temporary tag', 'temporary tag', 'temporary tag', 'temporary tag', 'temporary tag', 'temporary tag', 'temporary tag', 'temporary tag'};
        
       
            case not currently relevant due to no cue & Choice model
        case 'Qfull'
            connum = [1,6,8,7,9,2,3,?];
            tags = {'cue', 'Shake+', 'neg Shake+', 'Shake-', 'neg Shake-', 'Shake+>Shake-','Shake+<Shake-', 'S+ & S-', 'neg S+ & neg S-' ...
                'PE+', 'neg PE+', 'PE-', 'neg PE-', 'PE+>PE-', 'PE+<PE-', 'PE+ & PE-', 'neg PE- & neg PE+' ...
                'Qchosen', 'neg Qchosen','Qunchosen', 'neg Qunchosen', 'Qc>Qu', 'Qc<Qu', 'Qc & Qu', 'neg Qc & neg Qc' ...
                'choice' };
            
                
        %%models with two Outcome/PE Regressors
        case 'Qfull_no_cue'
            connum = [6,8,7,9,2,3,1];%this sseems wrong but i'm not using it anyway
            tags = {'Shake+', 'neg Shake+', 'Shake-', 'neg Shake-', 'Shake+>Shake-','Shake+<Shake-', 'S+ & S-', 'neg S+ & neg S-' ...
                'PE+', 'neg PE+', 'PE-', 'neg PE-', 'PE+>PE-', 'PE+<PE-', 'PE+ & PE-', 'neg PE- & neg PE+' ...
                'Qchosen', 'neg Qchosen','Qunchosen', 'neg Qunchosen', 'Qc>Qu', 'Qc<Qu', 'Qc & Qu', 'neg Qc & neg Qc' ...
                'choice' };
        case 'Qchosen_long'
             connum = [1,2,3,6,7,11]; % connum = [1,2,3,6,7,10,11]; removed choice and corrected for new contrasts
            tags = {'cue', 'Shake+', 'neg Shake+', 'Shake-', 'neg Shake-', 'Shake+>Shake-','Shake+<Shake-', 'S+ & S-', 'neg S+ & neg S-' ...
                'PE+', 'neg PE+', 'PE-', 'neg PE-', 'PE+>PE-', 'PE+<PE-', 'PE+ & PE-', 'neg PE- & neg PE+' ...
                'Qchosen' ...
                };
         case 'only_Qchosen'
         connum = [11]; % connum = [1,2,3,6,7,10,11]; removed choice and corrected for new contrasts
        tags = { 'Qchosen' , 'neg Qchosen', ...
            };
        case 'Qchosen_reordered'
             connum = [1,11,2,3,6,7]; % connum = [1,2,3,6,7,10,11]; removed choice and corrected for new contrasts
            tags = {'cue', 'neg cue', 'Qchosen', 'neg Qchose', 'junk', 'junk' , 'junk', 'junk' ...
                };
        
        case {0, 'noQfull'}
            connum = [1,6,8,7,9];
            tags = {'cue', 'Shake+', 'neg Shake+', 'Shake-', 'neg Shake-', 'Shake+>Shake-','Shake+<Shake-', 'S+ & S-', 'neg S+ & neg S-' ...
                'PE+', 'neg PE+', 'PE-', 'neg PE-', 'PE+>PE-', 'PE+<PE-', 'PE+ & PE-', 'neg PE- & neg PE+' ...
                };
				%}
    end
    
    cons = {}; i=1;
    for num=connum
                %cons{i} = fullfile(input_data_path, subjects{sub}, sequence, ['con_00' num2str(num,'%02.f') '.nii,1']);
                if strcmp(sequence, 'learning')
                    cons{i} = fullfile(input_data_path, subjects{sub}, ['con_00' num2str(num,'%02.f') '.nii,1']);
                else
                    cons{i} = fullfile(input_data_path, subjects{sub}, split, analysis2, ['con_00' num2str(num,'%02.f') '.nii,1']);
                end
                i=i+1;
    end
    %remove empty cells
    cons = cons(not(cellfun(@isempty,cons)));
    cons = cons';
    
    matlabbatch{1}.spm.stats.factorial_design.des.fblock.fsuball.fsubject(sub).scans = {
        cons{:};
        }'; %needs ' at end to make cons{:} to function
    matlabbatch{1}.spm.stats.factorial_design.des.fblock.fsuball.fsubject(sub).conds = [
        1:numel(cons)    
        ];
   
   
    matlabbatch{1}.spm.stats.factorial_design.des.fblock.maininters{1}.fmain.fnum = 1;
    
    switch covariates
        case 'wl_delta'
            %% make sure to take 8957 out of the vector since he has no fmri
            %4643 -15.3125
            covariate_v1 = [-64.4792 -15.3125 -30 -38.3333  9.47917   -19.375 -39.1667 3.02083 -3.54167];
            covariate_v1 = repelem(covariate_v1,[repmat(numel(connum),numel(covariate_v1),1)]);
            matlabbatch{1}.spm.stats.factorial_design.cov(1).c = [covariate_v1];
            matlabbatch{1}.spm.stats.factorial_design.cov(1).cname = 'wanting_delta';
            matlabbatch{1}.spm.stats.factorial_design.cov(1).iCFI = 1;
            matlabbatch{1}.spm.stats.factorial_design.cov(1).iCC = 1;
            %4643 -47.2916666666667
            covariate_v2 = [-33.8541666666667 -47.2916666666667 -13.125 -45.6770833333333 -77.3645833333333 -8.18750000000001  -14.4166666666667 -25.9270833333334 -26.3645833333333];
            covariate_v2 = repelem(covariate_v2,[repmat(numel(connum),numel(covariate_v2),1)]);
            matlabbatch{1}.spm.stats.factorial_design.cov(2).c = [covariate_v2];
            matlabbatch{1}.spm.stats.factorial_design.cov(2).cname = 'liking_delta';
            matlabbatch{1}.spm.stats.factorial_design.cov(2).iCFI = 1;
            matlabbatch{1}.spm.stats.factorial_design.cov(2).iCC = 1;
            matlabbatch{1}.spm.stats.factorial_design.multi_cov = struct('files', {}, 'iCFI', {}, 'iCC', {});
        case 'wpl_pretest'
            covariate_v1 = [49.4792  165.6250  104.8958  154.0104  144.7396  147.7083  125.0000   95.6771  161.5104];
            covariate_v1 = repelem(covariate_v1,[repmat(numel(connum),numel(covariate_v1),1)]);
            matlabbatch{1}.spm.stats.factorial_design.cov(1).c = [covariate_v1];
            matlabbatch{1}.spm.stats.factorial_design.cov(1).cname = 'wanting_and_liking_pretest';
            matlabbatch{1}.spm.stats.factorial_design.cov(1).iCFI = 1;
            matlabbatch{1}.spm.stats.factorial_design.cov(1).iCC = 1;
        case 'wpl_both' %%I need to take 7874 out of this calculation because he has no post! but should take out of level 2 anyway
            covariate_v1 = [191.2500  201.5625  170.8333 154.0104  206.8021  265.5625  176.0000   133.8646  284.1562];
            covariate_v1 = repelem(covariate_v1,[repmat(numel(connum),numel(covariate_v1),1)]);
            matlabbatch{1}.spm.stats.factorial_design.cov(1).c = [covariate_v1];
            matlabbatch{1}.spm.stats.factorial_design.cov(1).cname = 'wanting_and_liking_pre_and_posttest';
            matlabbatch{1}.spm.stats.factorial_design.cov(1).iCFI = 1;
            matlabbatch{1}.spm.stats.factorial_design.cov(1).iCC = 1;
        case 'bmi'
            covariate_v1 = [25.1366   21.0286   21.1044   26.2976   22.4566   20.7980   21.8006   20.8581];
             covariate_v1 = repelem(covariate_v1,[repmat(numel(connum),numel(covariate_v1),1)]);
            matlabbatch{1}.spm.stats.factorial_design.cov(1).c = [covariate_v1];
            matlabbatch{1}.spm.stats.factorial_design.cov(1).cname = 'BMI';
            matlabbatch{1}.spm.stats.factorial_design.cov(1).iCFI = 1;
            matlabbatch{1}.spm.stats.factorial_design.cov(1).iCC = 1;
        otherwise
            matlabbatch{1}.spm.stats.factorial_design.cov = struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});
            matlabbatch{1}.spm.stats.factorial_design.multi_cov = struct('files', {}, 'iCFI', {}, 'iCC', {});
    end
    
    matlabbatch{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
    matlabbatch{1}.spm.stats.factorial_design.masking.im = 1;
    matlabbatch{1}.spm.stats.factorial_design.masking.em = {''};
    matlabbatch{1}.spm.stats.factorial_design.globalc.g_omit = 1;
    matlabbatch{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
    matlabbatch{1}.spm.stats.factorial_design.globalm.glonorm = 1;
    
    matlabbatch{2}.spm.stats.fmri_est.spmmat(1) = cfg_dep('Factorial design specification: SPM.mat File', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
    matlabbatch{2}.spm.stats.fmri_est.write_residuals = 0;
    matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;
    
end

c=1;
matlabbatch{3}.spm.stats.con.spmmat(c) = cfg_dep('Model estimation: SPM.mat File', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
    

%% add contrasts to design matrix
d=1
for i=1:(numel(connum)*2)
	matlabbatch{3}.spm.stats.con.consess{c}.tcon.name = tags{i};
	if rem(i,2) %if number is odd
		matlabbatch{3}.spm.stats.con.consess{c}.tcon.weights = [con_vector(numel(cons),d,0)];
        d=d+1;
	else
		matlabbatch{3}.spm.stats.con.consess{c}.tcon.weights = [con_vector(numel(cons),0,d-1)];
    end
	matlabbatch{3}.spm.stats.con.consess{c}.tcon.sessrep = 'none';
    c=c+1;
end


matlabbatch{3}.spm.stats.con.delete = 1;

matlabbatch{4}.spm.stats.results.spmmat(1) = cfg_dep('Model estimation: SPM.mat File', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
matlabbatch{4}.spm.stats.results.conspec.titlestr = '';
matlabbatch{4}.spm.stats.results.conspec.contrasts = Inf;
matlabbatch{4}.spm.stats.results.conspec.threshdesc = 'none';
matlabbatch{4}.spm.stats.results.conspec.thresh = 0.001;
matlabbatch{4}.spm.stats.results.conspec.extent = 0;
matlabbatch{4}.spm.stats.results.conspec.conjunction = 1;
matlabbatch{4}.spm.stats.results.conspec.mask.none = 1;
matlabbatch{4}.spm.stats.results.units = 1;
matlabbatch{4}.spm.stats.results.export{1}.ps = true;
matlabbatch{4}.spm.stats.results.export{2}.csv = true;

spm_jobman('serial',matlabbatch);

end