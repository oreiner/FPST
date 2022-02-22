if strcmp(sequence,'learning')
            if (contains(analysis,'no_cue'))
                %no cue regressor
            elseif (contains(analysis,'empty_cue'))
                %condition: cue, empty
                inputs{count, 1} = 'empty_cue' ; count = count+1; %name
                inputs{count, 1} = 0 ; count = count+1; %onsets
                inputs{count, 1} = 0; count = count+1; %duration
            elseif (contains(analysis, 'Q') & not(contains(analysis,'cue_Q')))
               %condition: cue, short duration
                 inputs{count, 1} = 'cue_short' ; count = count+1; %name
                inputs{count, 1} = end_results.onsets(1).cue ; count = count+1; %onsets
                inputs{count, 1} = end_results.onsets(1).choicescreen - end_results.onsets(1).cue; count = count+1; %duration
            else
                %condition: cue, long duration with extra 0.3s from choice screen
                 inputs{count, 1} = 'cue_long' ; count = count+1; %name
                inputs{count, 1} = end_results.onsets(1).cue ; count = count+1; %onsets
                inputs{count, 1} = (end_results.onsets(1).choicescreen - end_results.onsets(1).cue + 0.3); count = count+1; %duration  
          end
        switch analysis
            case 'Qchosen'
                %overwrite jobfile
                jobfile = ['1st_level_job_' sequence derivatives '_Qchosen.m'];
                %condition: choice
                inputs{count, 1} = 'choice' ; count = count+1; %name
                inputs{count, 1} = end_results.onsets(1).choice ; count = count+1; %onsets
                inputs{count, 1} = 0.3; count = count+1; %duration
                inputs{count, 1} = 'Qchosen' ; count = count+1;%name 
                inputs{count, 1} = end_results.trial.Qchosen(:,1) ; count = count+1; %values
                inputs{count, 1} = 1 ; count = count+1; %polynomial expansion
            case  {'Qchosen_no_cue', 'Qboth_no_cue','Qchosen_empty_cue', 'Qboth_empty_cue', 'cue_Qchosen', 'cue_Qboth'}
                jobfile = ['1st_level_job_' sequence derivatives '_Qchosen.m'];
                if strcmp(analysis,'Qchosen_no_cue')
                        jobfile = ['1st_level_job_' sequence derivatives '_Qchosen_no_cue.m'];
                end
                %condition: choice
                if not(contains(analysis,'cue_Q'))                    
                    inputs{count, 1} = 'choice' ; count = count+1; %name
                    inputs{count, 1} = end_results.onsets(1).choice ; count = count+1; %onsets
                    inputs{count, 1} = 0.3; count = count+1; %duration
                end
                inputs{count, 1} = 'Qchosen' ; count = count+1;%name 
                inputs{count, 1} = end_results.trial.Qchosen(:,1) ; count = count+1; %values
                inputs{count, 1} = 1 ; count = count+1; %polynomial expansion
                if  nnz(strcmp(analysis,{'Qboth_empty_cue', 'Qboth_no_cue', 'cue_Qboth'}))
                    jobfile = ['1st_level_job_' sequence derivatives '_Qboth_no_cue.m'];
                    if strcmp(analysis,'Qboth_empty_cue')
                        jobfile = ['1st_level_job_' sequence derivatives '_Qboth.m'];
                    end
                    inputs{count, 1} = 'Qunchosen' ; count = count+1;%name 
                    inputs{count, 1} = end_results.trial.Qunchosen(:,1) ; count = count+1; %values
                    inputs{count, 1} = 1 ; count = count+1; %polynomial expanstion
                end
            case {'Qboth_choice_side', 'Qboth_choice_side_empty_cue', 'Qboth_choice_side_no_cue', 'cue_Qboth_side'}
                jobfile = ['1st_level_job_' sequence derivatives '_Qboth_sided.m'];
                if nnz(strcmp(analysis, {'Qboth_choice_side_no_cue','cue_Qboth_side'}))
                    jobfile = ['1st_level_job_' sequence derivatives '_Qboth_sided_no_cue.m'];
                end
                %condition: choice
                if not(contains(analysis,'cue_Q'))
                    inputs{count, 1} = 'choice' ; count = count+1; %name
                    inputs{count, 1} = end_results.onsets(1).choice ; count = count+1; %onsets
                    inputs{count, 1} = 0.3; count = count+1; %duration
                end
                %change choices data to binomial format (was it the left or the right choice in the trial)
                %relative to trial pair [0,1] instead of absolute cue [1:6]
                %convert data vector from [0,1] for left/right to [-1,1].
                %limit only to learn trials  
                data.choices = +(data.choices == data.cues(2,:));			 
                data.choices(find(data.choices==0))=-1;
                data.choices = data.choices(1:nnz(not(isnan(data.feedbacks))));
                inputs{count, 1} = 'choice_side' ; count = count+1;%name 
                inputs{count, 1} = data.choices' ; count = count+1; %values
                inputs{count, 1} = 1 ; count = count+1; %polynomial expansion
                inputs{count, 1} = 'Qchosen' ; count = count+1;%name 
                inputs{count, 1} = end_results.trial.Qchosen(:,1) ; count = count+1; %values
                inputs{count, 1} = 1 ; count = count+1; %polynomial expansion
                inputs{count, 1} = 'Qunchosen' ; count = count+1;%name 
                inputs{count, 1} = end_results.trial.Qunchosen(:,1) ; count = count+1; %values
                inputs{count, 1} = 1 ; count = count+1; %polynomial expansion 
            otherwise
                warning('\n\n default 1st level analysis is being run! \n\n');
        end 
         %condition: Positive feedback milkshake
        inputs{count, 1} = 'Milkshake' ; count = count+1; %name
        inputs{count, 1} = end_results.onsets(1).Pshake ; count = count+1;  %onsets
        inputs{count, 1} = (1.2 + 3.1 -0.3); count = count+1; %duration
        inputs{count, 1} = 'pos_PE' ; count = count+1;%name 
        inputs{count, 1} = end_results.model.pos_PE ; count = count+1; %values
        inputs{count, 1} = 1 ; count = count+1; %polynomial expanstion
         %condition: Negative feedback neutral solution
        inputs{count, 1} = 'Neutral' ; count = count+1; %name
        inputs{count, 1} = end_results.onsets(1).Nshake ; count = count+1;  %onsets
        inputs{count, 1} = (1.2 + 3.1 -0.3); count = count+1; %duration 
        inputs{count, 1} = 'neg_PE' ; count = count+1;%name 
        inputs{count, 1} = end_results.model.neg_PE ; count = count+1; %values
        inputs{count, 1} = 1 ; count = count+1; %polynomial expanstion
         %condition: null events
        inputs{count, 1} = 'null_events' ; count = count+1; %name
        inputs{count, 1} = end_results.onsets(1).null ; count = count+1; %onsets
        inputs{count, 1} = 1.7+3.1; count = count+1; %duration 
         %condition: missed events
        inputs{count, 1} = 'miss' ; count = count+1; %name
        inputs{count, 1} = end_results.onsets(1).miss ; count = count+1; %onsets
        inputs{count, 1} = 2; count = count+1; %duration 
     elseif strcmp(sequence,'transfer')
         switch analysis
             case 'chooseavoid'
                 %condition: choose A decisions
                inputs{count, 1} = 'choose1' ; count = count+1; %name
                inputs{count, 1} = end_results.onsets(2).choose1 ; count = count+1;  %onsets
                inputs{count, 1} = 0; count = count+1; %duration
                 %condition: avoid B decisions
                inputs{count, 1} = 'avoid2' ; count = count+1; %name
                inputs{count, 1} = end_results.onsets(2).avoid2 ; count = count+1;  %onsets
                inputs{count, 1} = 0; count = count+1; %duration 
                %condition: other decisions (...)
                inputs{count, 1} = 'not_12' ; count = count+1; %name
                inputs{count, 1} = end_results.onsets(2).not_12 ; count = count+1;  %onsets
                inputs{count, 1} = 0; count = count+1; %duration 
             case 'winlose'
                 %condition: winwin pairs
                inputs{count, 1} = 'winwin' ; count = count+1; %name
                inputs{count, 1} = end_results.onsets(2).winwin ; count = count+1;  %onsets
                inputs{count, 1} = 0; count = count+1; %duration
                 %condition: loselose pairs
                inputs{count, 1} = 'loselose' ; count = count+1; %name
                inputs{count, 1} = end_results.onsets(2).loselose ; count = count+1;  %onsets
                inputs{count, 1} = 0; count = count+1; %duration 
                %condition: other decisions (...)
                inputs{count, 1} = 'winlose' ; count = count+1; %name
                inputs{count, 1} = end_results.onsets(2).winlose ; count = count+1;  %onsets
                inputs{count, 1} = 0; count = count+1; %duration 
             case 'Vrel'
                %condition: cue
                inputs{count, 1} = 'cue' ; count = count+1; %name
                inputs{count, 1} = end_results.onsets(2).cue ; count = count+1; %onsets
                inputs{count, 1} = (end_results.onsets(2).choicescreen - end_results.onsets(2).cue + 0.3); count = count+1; %duration
                inputs{count, 1} = 'Vrel' ; count = count+1; %name
                inputs{count, 1} = end_results.trial.Vrel ; count = count+1; %pm Vrel
                inputs{count, 1} = 'Vstate' ; count = count+1; %name
                inputs{count, 1} = end_results.trial.Vstate ; count = count+1; %pm Vstate
                %needs a different job because 1st level structure is different
                jobfile = ['1st_level_job_' sequence derivatives '_pm.m'];
             otherwise
                 %implement error check
         end
         %conditions that are in all transfer models
           %condition: motor response
            %inputs{count, 1} = 'click' ; count = count+1; %name
            %inputs{count, 1} = end_results.onsets(2).choicescreen; count = count+1; %onsets
            %inputs{count, 1} = 0; count = count+1; %duration        
            switch analysis2
                case 'cross'
                    %condition: cross cue, instead of null events, as they are included
                     %however, missed events this method unintetionally includes
                     %missed events as cross
                    inputs{count, 1} = 'cross' ; count = count+1; %name
                    inputs{count, 1} = end_results.onsets(2).choicescreen + 0.3; count = count+1; %onsets
                        duration_cross = [ end_results.onsets(2).cue(1) - end_results.onsets(2).jitter(1); ...
                            end_results.onsets(2).cue(2:end) - (end_results.onsets(2).choicescreen(1:end-1) + 0.3); ...
                            %4 - (end_results.onsets(2).choicescreen(end) + 0.3 - end_results.onsets(2).jitter(end)) ...
                            ];
                    inputs{count, 1} = duration_cross ; count = count+1; %duration   
                case 'null'
                    %condition: null events
                    inputs{count, 1} = 'null_events' ; count = count+1; %name
                    inputs{count, 1} = end_results.onsets(2).null ; count = count+1; %onsets
                    inputs{count, 1} = 4; count = count+1; %duration 
            end
             %condition: missed events
            inputs{count, 1} = 'miss' ; count = count+1; %name
            inputs{count, 1} = end_results.onsets(2).miss ; count = count+1; %onsets
            inputs{count, 1} = 2 ; count = count+1; %duration 
     end