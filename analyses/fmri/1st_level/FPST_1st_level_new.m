%%function FPST_1st_level(subject, sequence, derivatives, model)
%%load analyzed task data (onsets, parametric modulator)
%%perform 1st level analysis with preprocessed Data
%%subject = e.g. 2899 or 4643 or etc. 
%%sequence = learning or transfer
%%prefix = long_cue or Qchosen or Qboth etc. 
%%derivatives = e.g. _1_derivative, _2_derivative (time modulation or time + displacement)
%%analysis = for learnphase empty for no Qvalue pm or 'Qchosen','Qchosen_no_cue','Qboth_no_cue', 'Qboth_choice_side', 'Qboth_choice_side_no_cue'; 
%%'cue_Qchosen', 'cue_Qboth', 'cue_Qboth_sided'
%%empty_cue means cue vector of zero (made out of original laziness).
%%no_cue doens't have a cue regressor at all (better!)
%%choice means choice onset is modulated in addition to cue onset. 
%%side(d) means pm of [-1,1] for left/right choice
%%cue_Q means no choice, but cue modulated with Q
%%anaylsis2= Q_last or PE_last changes the design matrix order. appearantly
%%this is not relevant. only pm order matters (when orthogonality is on,
%%default)
%%sduration = length of shake delivery
%%stiming = onset of length delivery after pumps start (changed to after choice screen ends)
%WMCSF_kernal = leave blank for default (WM=9,CS=2)

%%for tranfer phase, e.g. 'chooseavoid', 'winlose', 'Vrel'
%%analysis2 = for tranfer phase, e.g. 'null' or 'cross' for non cue events
%%model = for behavioral task, e.g. '_task_results_both_phases_asymmetrical_normal_temperature'

function FPST_1st_level_new(subject, sequence, prefix, derivatives, analysis, analysis2, model, sduration, stiming, WMCSF_kernal)
 
    if (strcmp(sequence,'transfer') && not(exist('analysis','var')))
        error('\nplease provide anaylsis type for tranfer phase, e.g.:\nchooseavoid\nwinlose\nVrel\nVstate\n');
    end
    
    if (strcmp(sequence,'transfer') && not(exist('analysis2','var')))
        analysis = 'null_events';
    end
    if not(exist('model','var'))
        model = '_task_results_both_phases_asymmetrical_normal_temperature';
    end
    if not(exist('analysis2','var'))
        analysis2 = '';
    end
	%% load task variables
	taskpath = '[Home Directory]/results/task';	
	load(fullfile(taskpath, subject, [subject model '.mat']));
	%% set spm job	
	niipath   = '[Home Directory]/results/fmri/nii';	
    niipathsub  = fullfile(niipath, subject);
	jobfile = ['1st_level_job_' sequence derivatives '.m'];
	inputs = cell(1, 1);
	count = 1;   
	%% config mri variables
    output_dir = fullfile('[Home Directory]/results/fmri/1st_level', sequence,[prefix derivatives], subject);
    if sequence == 'transfer'
        output_dir = fullfile(output_dir, analysis, analysis2);
    end
    if not(exist(output_dir, 'dir'))
        mkdir(output_dir);
    end
    TR = 1.22; 
    %get multiple regressors (outliers, CSF+WM signals and motion
    %paramteres)
    if not(exist('WMCSF_kernal', 'var'))
        WMCSF_kernal ='';
    end
	txtname = dir(fullfile(niipathsub, ['75p25_24mp_WMCSF_' sequence WMCSF_kernal '.txt']));  
	motion_parameters = fullfile(txtname.folder, txtname.name);	

	%% spm settings	
	spm('defaults', 'fmri');
	spm_jobman('initcfg');

    %% set output dir
    inputs{count, 1} = {output_dir};	count = count+1; 
    %% set TR
    inputs{count,1} = TR; count = count+1;
	%% choose smoothed functional images as scans
	input_imgF = fullfile(niipathsub, ['swFPST_BOLD_' sequence '_' subject '_mcAP_unwarped.nii']); 
	inputs{count, 1} = {input_imgF}; count = count+1; 
	%% load task results into regressors
    if contains(prefix, 'single_regressor') 
        jobfile = ['1st_level_job_' sequence derivatives '_Qboth_single_regressor'];
    else
        jobfile = ['1st_level_job_' sequence derivatives '_Qchosen'];
        extra_PE = 6;
    end
     
     if strcmp(sequence,'learning')
         side = 0;
            if not(contains(prefix, 'no_null'))
                %condition: null events
                inputs{count, 1} = 'null_events' ; count = count+1; %name
                inputs{count, 1} = end_results.onsets(1).null ; count = count+1; %onsets
                inputs{count, 1} = 1.7+3.1; count = count+1; %duration 
            end
             %condition: missed events
            inputs{count, 1} = 'miss' ; count = count+1; %name
            inputs{count, 1} = end_results.onsets(1).miss ; count = count+1; %onsets
            inputs{count, 1} = 2; count = count+1; %duration 
            %condition: cue with Qs pm, long duration with extra 0.3s from choice screen

            if contains(prefix, 'Qchosen')
                Qnum = 3; %for jobfile
                Qs = {'cue_long'; end_results.onsets(1).cue ; (end_results.onsets(1).choicescreen - end_results.onsets(1).cue + 0.3); ...
                  'Qchosen' ; end_results.model.Qchosen(:,1) ; 1 ; ...
                   };
            elseif contains(prefix, 'Qboth')
                Qnum = 6;
                Qs = {'cue_long'; end_results.onsets(1).cue ; (end_results.onsets(1).choicescreen - end_results.onsets(1).cue + 0.3); ...
                                  'choice_side' ; data.choices' ; 1 ; ...
                                  'Qchosen' ; end_results.model.Qchosen(:,1) ; 1 ; ...
                                 'Qunchosen' ; end_results.model.Qunchosen(:,1) ; 1 ... 
                                 };
            elseif contains(prefix, 'Qdelta')
                Qnum = 3;
                Qs = {'cue_long'; end_results.onsets(1).cue ; (end_results.onsets(1).choicescreen - end_results.onsets(1).cue + 0.3); ...
                                  'choice_side' ; data.choices' ; 1 ; ...
                                  'Qchosen' ; end_results.model.Qchosen(:,1) ; 1 ; ...
                                  'Qdelta' ; end_results.model.Qchosen(:,1) - end_results.model.Qunchosen(:,1) ; 1 ; ...
                                 };
            end

            %condition: outcome Fluid with PE pm
            %PE = {'Outcome' ; end_results.onsets(1).all_shake ; (1.2 + 3.1 -0.3); ...
            %modified outcome onset to after pump and duration 0 or
            %alternitavly 3.1s
            if contains(prefix, 'single_regressor') 
                 PE = {'Outcome' ; end_results.onsets(1).all_shake + stiming ; sduration; ...
                      'PE' ; posterior.PE(1:numel(end_results.onsets(1).all_shake)) ; 1 ...
                 };  
            else
                PE = {'Pos_Outcome' ; end_results.onsets(1).Pshake + stiming ; sduration; ...
                                  'Pos_PE' ; end_results.model.pos_PE ; 1; ...
                                  'Neg_Outcome' ; end_results.onsets(1).Nshake + stiming ; sduration; ...
                                  'Neg_PE' ; end_results.model.neg_PE ; 1 ...
                };
            end
                    
            if contains(prefix,'side')
                        jobfile = ['1st_level_job_' sequence derivatives '_Qboth_sided_single_regressor'];
                        side = 3;
                        %change choices data to binomial format (was it the left or the right choice in the trial)
                        %relative to trial pair [0,1] instead of absolute cue [1:6]
                        %convert data vector from [0,1] for left/right to [-1,1].
                        %limit only to learn trials  
                        data.choices = +(data.choices == data.cues(2,:));			 
                        data.choices(find(data.choices==0))=-1;
                        data.choices = data.choices(1:nnz(not(isnan(data.feedbacks))));
                        Qs = {'cue_long'; end_results.onsets(1).cue ; (end_results.onsets(1).choicescreen - end_results.onsets(1).cue + 0.3); ...
                                  'choice_side' ; data.choices' ; 1 ; ...
                                  'Qchosen' ; end_results.model.Qchosen(:,1) ; 1 ; ...
                                 'Qunchosen' ; end_results.model.Qunchosen(:,1) ; 1 ... 
                                 %alternative to Qunchosen is Qdelta = Qchosen - Qunchosen
                                 %something like "easieness of trial"
                                  %'Qdelta' ; end_results.model.Qchosen(:,1) - end_results.model.Qunchosen(:,1) ; 1 ; ...
                                 };
                             
                        %repatch choice onset instead of cue onset        
                        if contains(prefix,'choice_onset')
                            Qs = {'choice' ; end_results.onsets(1).choice ; 0.3; ...
                                  'choice_side' ; data.choices' ; 1 ; ...
                                  'Qchosen' ; end_results.model.Qchosen(:,1) ; 1 ; ...
                                 %'Qunchosen' ; end_results.model.Qunchosen(:,1) ; 1 ... 
                                 %alternative to Qunchosen is Qdelta = Qchosen - Qunchosen
                                 %something like "easieness of trial"
                                  'Qdelta' ; end_results.model.Qchosen(:,1) - end_results.model.Qunchosen(:,1) ; 1 ; ...
                                 };
                        end     
                             
                        %condition: outcome Fluid with PE pm
                        %PE = {'Outcome' ; end_results.onsets(1).all_shake ; (1.2 + 3.1 -0.3); ...
                        %modified outcome onset to after pump and duration 0 or
                        %alternitavly 3.1s
                        PE = {'Outcome' ; end_results.onsets(1).all_shake + stiming ; sduration; ...
                                  'PE' ; posterior.PE(1:numel(end_results.onsets(1).all_shake)) ; 1 ...
                                 };
                       
                             %repatch PE neg/pos for a test
                       if not(contains(prefix, 'single_regressor'))
                           jobfile = ['1st_level_job_' sequence derivatives '_Qboth_sided'];
                           extra_PE = 6;
                           clear PE;
                           PE = {'Pos_Outcome' ; end_results.onsets(1).Pshake + stiming ; sduration; ...
                                  'Pos_PE' ; end_results.model.pos_PE ; 1; ...
                                  'Neg_Outcome' ; end_results.onsets(1).Nshake + stiming ; sduration; ...
                                  'Neg_PE' ; end_results.model.neg_PE ; 1 ...
                                 };
                       else
                           extra_PE = 0;
                           if contains(prefix,'reversed_PE')
                                PE = {'Outcome' ; end_results.onsets(1).all_shake + stiming ; sduration; ...
                                  '1-PE' ; sign(posterior.PE(1:numel(end_results.onsets(1).all_shake))) - posterior.PE(1:numel(end_results.onsets(1).all_shake)) ; 1 ...
                                 };
                           end
                       end
                       
                             
            end     
            
            if contains(prefix,'no_ortho')
                 jobfile = [jobfile '_no_ortho'];
            end
              
            if (contains(analysis2,'PE_last'))
                jobfile = [jobfile '_PE_last'];
                inputs = {inputs{:} , Qs{:}}; count = count + Qnum + 3 + side;
                inputs = {inputs{:} , PE{:}}'; count = count + 6 + extra_PE ;
            else
                jobfile = [jobfile '_Qs_last'];
                inputs = {inputs{:} , PE{:}}; count = count + 6 + extra_PE ;
                inputs = {inputs{:} , Qs{:}}'; count = count + Qnum + 3 + side;
            end
            
            if contains(prefix,'no_null')
                 jobfile = [jobfile '_no_null'];
            end

            
            %this doesn't work for some reason
            %{
            switch derivatives(2)
                case '1'
                    inputs{count,1} = [1 0]; count = count + 1;
                case '2' 
                    inputs{count,1} = [1 1]; count = count + 1;
            end
            %}
      %% needs an update
      
      elseif strcmp(sequence,'transfer')  
          %condition: missed events
            jobfile = ['1st_level_job_' sequence derivatives '_diff'];
            inputs{count, 1} = 'miss' ; count = count+1; %name
            inputs{count, 1} = end_results.onsets(2).miss ; count = count+1; %onsets
            inputs{count, 1} = 2; count = count+1; %duration 
         switch analysis
             case {'chooseavoid','chooseavoid_noQ', 'A_B_overOthers'}
                 %condition: choose A decisions
                inputs{count, 1} = 'choose1' ; count = count+1; %name
                inputs{count, 1} = end_results.onsets(2).choose1 ; count = count+1;  %onsets
                inputs{count, 1} = end_results.forTest.durations.choose1; count = count+1; %duration
                inputs{count, 1} = 'QchosenA' ; count = count+1; %name
                %%need a trick to make the pm not uniform in users that
                %%choose only A correctly. spm gets confuse
                %this trick has unexpected results! pm is centered on
                %average
                %inputs{count, 1} = end_results.forTest.Qchosen.choose1 + 0.0001*con_vector(numel(end_results.forTest.Qchosen.choose1),1,0)' ; count = count+1; %pm Qchosen
                inputs{count, 1} = end_results.forTest.Qchosen.choose1 ; count = count+1; %pm Qchosen
                inputs{count, 1} = 1; count = count+1;
                 %condition: avoid B decisions
                inputs{count, 1} = 'avoid2' ; count = count+1; %name
                inputs{count, 1} = end_results.onsets(2).avoid2 ; count = count+1;  %onsets
                inputs{count, 1} = end_results.forTest.durations.avoid2; count = count+1; %duration 
                inputs{count, 1} = 'QchosenB' ; count = count+1; %name
                inputs{count, 1} = end_results.forTest.Qchosen.avoid2 ; count = count+1; %pm Qchosen
                inputs{count, 1} = 1; count = count+1;
                %condition: other decisions (...)
                inputs{count, 1} = 'not_12' ; count = count+1; %name
                inputs{count, 1} = nonzeros(end_results.onsets(2).not_12) ; count = count+1;  %onsets
                inputs{count, 1} = end_results.forTest.durations.not_12; count = count+1; %duration 
                inputs{count, 1} = 'QchosenOther' ; count = count+1; %name
                inputs{count, 1} = end_results.forTest.Qchosen.not_12 ; count = count+1; %pm Qchosen
                inputs{count, 1} = 1; count = count+1;
             case 'chooseavoid_3pm'
                 jobfile = ['1st_level_job_' sequence derivatives '_3pm'];
                 if contains(prefix,'no_ortho')
                    jobfile = [jobfile '_no_ortho'];
                 end
                 %condition: choose A decisions
                inputs{count, 1} = 'Cues' ; count = count+1; %name
                inputs{count, 1} = end_results.onsets(2).cue ; count = count+1;  %onsets
                inputs{count, 1} = (end_results.onsets(2).choicescreen - end_results.onsets(2).cue + 0.3); count = count+1; %duration
                % pm for Choose A
                inputs{count, 1} = 'Q-Value for Choose A ' ; count = count+1; %name
                inputs{count, 1} = end_results.forTest.Qchosen.pm3.choose1 ; count = count+1; %pm Qchosen
                inputs{count, 1} = 1; count = count+1;
                 %condition: avoid B decisions
                inputs{count, 1} = 'Q-Value for Avoid B' ; count = count+1; %name
                inputs{count, 1} = end_results.forTest.Qchosen.pm3.avoid2 ; count = count+1; %pm Qchosen
                inputs{count, 1} = 1; count = count+1;
                %condition: other decisions (...)
                inputs{count, 1} = 'Q-Value for other pairs' ; count = count+1; %name
                inputs{count, 1} = end_results.forTest.Qchosen.pm3.not_12 ; count = count+1; %pm Qchosen
                inputs{count, 1} = 1; count = count+1;
             case 'winlose'
                 %condition: winwin pairs
                inputs{count, 1} = 'winwin' ; count = count+1; %name
                inputs{count, 1} = end_results.onsets(2).winwin ; count = count+1;  %onsets
                inputs{count, 1} = end_results.forTest.durations.winwin; count = count+1; %duration
                inputs{count, 1} = 'QchosenWinWin' ; count = count+1; %name
                inputs{count, 1} =  end_results.forTest.Qchosen.winwin ; count = count+1; %pm Qchosen
                inputs{count, 1} = 1; count = count+1; %poly
                %condition: loselose pairs
                inputs{count, 1} = 'loselose' ; count = count+1; %name
                inputs{count, 1} = end_results.onsets(2).loselose ; count = count+1;  %onsets
                inputs{count, 1} = end_results.forTest.durations.loselose; count = count+1; %duration
                inputs{count, 1} = 'QchosenLoseLose' ; count = count+1; %name
                inputs{count, 1} =  end_results.forTest.Qchosen.loselose ; count = count+1; %pm Qchosen
                inputs{count, 1} = 1; count = count+1; %poly
                %condition: other decisions (...)
                inputs{count, 1} = 'low_conflict' ; count = count+1; %name
                inputs{count, 1} = nonzeros(end_results.onsets(2).winlose) ; count = count+1;  %onsets
                inputs{count, 1} = end_results.forTest.durations.winlose; count = count+1; %duration 
                inputs{count, 1} = 'QchosenNoConflict' ; count = count+1; %name
                inputs{count, 1} =  end_results.forTest.Qchosen.winlose ; count = count+1; %pm Qchosen
                inputs{count, 1} = 1; count = count+1;
             case {'QchosenTest'}
                %condition: cue
                inputs{count, 1} = 'long_cue' ; count = count+1; %name
                inputs{count, 1} = end_results.onsets(2).cue ; count = count+1; %onsets
                inputs{count, 1} = (end_results.onsets(2).choicescreen - end_results.onsets(2).cue + 0.3); count = count+1; %duration
                inputs{count, 1} = analysis ; count = count+1; %name
                inputs{count, 1} = end_results.model.(analysis) ; count = count+1; %pm Vrelinputs{count, 1} = 'Vrel' ; count = count+1; %name
                inputs{count, 1} = 1; count = count+1; %poly
                %needs a different job because 1st level structure is different
                jobfile = ['1st_level_job_' sequence derivatives '_Qchosen'];
            case {'Vrelative','Qchosen','Vstate','Vsoftmax'}
                %condition: cue
                inputs{count, 1} = 'long_cue' ; count = count+1; %name
                inputs{count, 1} = end_results.onsets(2).cue ; count = count+1; %onsets
                inputs{count, 1} = (end_results.onsets(2).choicescreen - end_results.onsets(2).cue + 0.3); count = count+1; %duration
                inputs{count, 1} = analysis ; count = count+1; %name
                inputs{count, 1} = nonzeros(end_results.model.(analysis)(:,2)) ; count = count+1; %pm Vrelinputs{count, 1} = 'Vrel' ; count = count+1; %name
                inputs{count, 1} = 1; count = count+1; %poly
                %needs a different job because 1st level structure is different
                jobfile = ['1st_level_job_' sequence derivatives '_Qchosen'];
             case {'shiner'}  
                 jobfile = ['1st_level_job_' sequence derivatives '_shiner'];
                 %remove missed events 
                 count = count - 3; 
                 
                 %%unfortunatly I didn't format the correct vs incorrect
                 %%trials. doing it here
                 As = end_results.trial.choose1(:,2);
                 Bs = end_results.trial.avoid2(:,2);
                 Others = end_results.trial.not_12(1:132,2);
                 
                 idx = isnan(As);
                 All_trials = As;
                 All_trials(idx) = Bs(idx);
                 idx = isnan(All_trials);
                 All_trials(idx) = Others(idx);
                 All_trials=All_trials(1:120);
                 
                 idxCorrects = (All_trials==1); 
                 idxIncorrects = (All_trials==0); 
                 
                 if size(end_results.model.Qchosen,2) ==2
                      allQchosen = end_results.model.Qchosen(:,2);
                 else
                     allQchosen = end_results.model.Qchosen;
                 end
                 
                 %correct trials 
                 inputs{count, 1} = 'correct trials' ; count = count+1; %name
                inputs{count, 1} = end_results.onsets(2).cue(idxCorrects) ; count = count+1; %onsets
                inputs{count, 1} = (end_results.onsets(2).choicescreen(idxCorrects) - end_results.onsets(2).cue(idxCorrects) + 0.3); count = count+1; %duration
                 inputs{count, 1} = 'Qchosen correct trials' ; count = count+1; %name
                inputs{count, 1} = allQchosen(idxCorrects) ; count = count+1; %pm
                inputs{count, 1} = 1; count = count+1; %poly
               
                 %incorrect trials
                  inputs{count, 1} = 'incorrect trials' ; count = count+1; %name
                inputs{count, 1} = end_results.onsets(2).cue(idxIncorrects) ; count = count+1; %onsets
                inputs{count, 1} = (end_results.onsets(2).choicescreen(idxIncorrects) - end_results.onsets(2).cue(idxIncorrects) + 0.3); count = count+1; %duration
               inputs{count, 1} = 'Qchosen incorrect trials' ; count = count+1; %name
                inputs{count, 1} = allQchosen(idxIncorrects) ; count = count+1; %pm
                inputs{count, 1} = 1; count = count+1; %poly
               
                 %motor response
                 inputs{count, 1} = 'motor response' ; count = count+1; %name
                  inputs{count, 1} = end_results.onsets(2).choice ; count = count+1; %onsets
                  inputs{count, 1} = 0; count = count+1; %duration
              
                 %fixation cross
                  inputs{count, 1} = 'fixation cross' ; count = count+1; %name
                  %paradigm starts from jitter but then count the crosses
                  %from after choice
                  inputs{count, 1} = [end_results.onsets(2).jitter(1) ; end_results.onsets(2).choicescreen+0.3] ; count = count+1; %onsets
                  inputs{count, 1} = [ end_results.onsets(2).cue(1) - end_results.onsets(2).jitter(1) ; ...
                     (end_results.onsets(2).cue(2:end) - end_results.onsets(2).choicescreen(1:end-1) + 0.3) ; ... 
                     max(end_results.trial.endtime(:,:,2)) - end_results.onsets(2).choicescreen(end) + 0.3 ]; count = count+1; %duration. max is end of last trial
              
             otherwise
                 %implement error check 
        %}
         end
     end
     % multiple regressor: Fristons motion parameters, CSF/WM nuisance signals, outliers
     inputs{count, 1} = {motion_parameters}; count = count+1; %onsets
     
    jobfile = [jobfile '.m']; 
    jobs = repmat(jobfile, 1, 1);
   
    %% process  all input images for the current subject
    clear matlabbatch
    spm_jobman('serial', jobs, '', inputs{:});
end