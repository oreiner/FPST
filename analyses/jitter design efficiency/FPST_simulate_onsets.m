function [onsets time] = FPST_simulate_onsets(jitter, trial, PE, response_time)
    %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % simulate onsets for FPST
    %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %% trial events and durations
    [blocks, repetitions, repetitions_test, null_events_learning, null_events_test, dummy_volumes, dur, rinse_pump, shake_pump, jitter_trials] = FPST_config();
    numtrials = 46*6; %repetitions * 6;
    nullevents = numtrials * null_events_learning;
    
    TR      = 1.220;      % in seconds

    % %% get the randomly generated list of jitters
    dur.jitt = jitter;

    %% load source files
    %load the list of conditions
    %condfile = ['./mr_4blocks/mr_efficiency_list' num2str(list) '.txt'];
    %[cues, outcomes, Q_pe, PE] = textread(condfile,'%d %d %f %f');
    %trial.cue(find(trial.choice(:,:,1)==-9),:,:) = []; %skip cues when user missed choice;
    %%simulate results

    onsets.miss = zeros(1,numtrials+floor(nullevents)); %avoid problems with empty missed onsets arrays
    
    jcount = 1;
    respcount = 1;
    time = 0;
    time=time+dummy_volumes*TR;
    
    for iTrial=1:(numtrials+floor(nullevents))
        A = trial.cue(iTrial, :, 1);
        B = trial.choice(iTrial); 
        if not(isnan(A))
           if A  
               %jitter
            onsets.jitter.u(1,jcount) = time;
            time = time + jitter(1,jcount);
            jcount = jcount + 1;
            %overflow at end
            %fprintf('jcount:%f time:%f \n', jcount, time);
              
            if B > 0
                 %cue. moved inside conditional B>0 because I skipped cue for
                 %missed events in the fmri analysis
                onsets.cue(iTrial) = time;
                if (response_time) %simulate a design where users have to wait the whole 1.7s
                    time = time + response_time(respcount); 
                    respcount = respcount + 1;
                else
                    time = time + normrnd(1.0,0.2); %random response time with normal distribution around 1. seems more like the subjects do
               end
                % choice screen
                onsets.choice(iTrial) = time;
                time = time + dur.choice;
                
                %add second jitter
                if size(jitter,1)>1
                    jcount = jcount -1;%workaround to avoid matrix overflow
                    onsets.jitter.u(2,jcount) = time;
                    time = time + jitter(2,jcount);
                    jcount = jcount + 1;
                end
                % shake
                onsets.shakepump(iTrial) = time; %actually parallel to onsets.choice, but left it this way because format_data already corrects shake_pump + dur.choice for better contrast. so adding 0.3 again would double dip
                if trial.shake(iTrial) == 1
                   onsets.Pshake(iTrial) = time;
                elseif trial.shake(iTrial) == 0
                   onsets.Nshake(iTrial) = time;
                end 
                if (~isnan(trial.shake(iTrial)))
                    onsets.allshakes(iTrial) = time;
                end
                time = time + dur.shake;
            elseif B == -9
                time = time + dur.resp; %took the max time to answer so timed out
                onsets.miss(iTrial) = time;
                time = time + dur.miss;
            end
           elseif A==0
               onsets.null(iTrial) = time;
               time = time + dur.null_event(1);
           end
       end
    end
    %%clean up vectors
    
    onsets.jitter.u = nonzeros(onsets.jitter.u);
    onsets.cue = nonzeros(onsets.cue);
    onsets.choice = nonzeros(onsets.choice);
    onsets.shakepump = nonzeros(onsets.shakepump);
    onsets.miss = nonzeros(onsets.miss);
    onsets.null = nonzeros(onsets.null);
    
    onsets.Pshake = nonzeros(onsets.Pshake);
    onsets.Nshake = nonzeros(onsets.Nshake);    
    onsets.allshakes = nonzeros(onsets.allshakes); 
    
    %time=time+5;
    dur.allscans = time/TR;
    %dur_scans(k) = time/TR;
    
end