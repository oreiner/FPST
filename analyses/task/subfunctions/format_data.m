%auxiliary function for analyze_task. 
%run accuracy.m and then 
%[end_results.onsets data] = format_data(onsets, trial)

function [output, data] = format_data(onsets, trial, blocks) 
    
    %%format stimuli data for VBA
	
	choices = [trial.choice(:,1,1)' trial.choice(:,1,2)'];
	
	for i = 1:2
		cues = [(trial.cue(:,i,1))' (trial.cue(:,i,2))'];
		cues(find(choices==-9)) = []; %skip cues when user missed choice;
		cues(isnan(cues)) = [];
		data.cues(i,:) = nonzeros(cues);
	end 

    shakes = [trial.shake(:,:,1)' trial.shake(:,:,2)'] ; 
    shakes(find(choices==-9)) = []; %no shake given when user missed choice. starting with the 7th subject, this step can be skipped as shake is defined as NaN
    shakes(isnan(shakes)) = [];
    
    choices(find(choices==-9)) = [];%note, this step mussed be after all other find(choices==-9) were performed!
	choices(isnan(choices)) = [];
   	data.choices = nonzeros(choices)'; 
    data.feedbacks = [shakes nan(1,(numel(data.choices)-numel(shakes)))]; %end feedbacks with nan to also analyze test phase, makes VBA analyse more precise.  
    
    %%format onsets for SPM
    for j = 1:blocks
        fields = fieldnames(onsets);
        for fldname = 1 : numel(fields)
            output(j).(fields{fldname}) = onsets.(fields{fldname})(:,:,j);
        end
        output(j).jitter(isnan(output(j).jitter)) = [];
        %output(j).resp(isnan(output(j).choice)) = []; output(j).resp(isnan(output(j).resp)) = []; %resp is cue in older subjects, remove trials where user didn't choose 
        %if isfield(onsets, 'resp') %old files called onsets.resp instead of onsets.cue
        %   output(j).cue = onsets.resp(:,:,j); 
        %end
        output(j).cue(isnan(output(j).choice)) = []; output(j).cue(isnan(output(j).cue)) = []; %equivalent to above
        output(j).choice(isnan(output(j).choice)) = [];
        output(j).choicescreen(isnan(output(j).choicescreen)) = [];
        output(j).miss(isnan(output(j).miss)) = [];
        output(j).null(isnan(output(j).null)) = [];
        output(j).shakepump(isnan(output(j).shakepump)) = [];
        if j==1          
            for i=1:numel(shakes)
                if shakes(i) == 1
                    Pshake_onsets(i) = output(j).shakepump(i) + 0.3 ; %correcting to ignore "chosen" screen
                elseif shakes(i) == 0
                    Nshake_onsets(i) = output(j).shakepump(i) + 0.3; %correcting to ignore "chosen" screen
                end

            end
            output(j).Pshake = nonzeros(Pshake_onsets);
            output(j).Nshake = nonzeros(Nshake_onsets);
            output(j).all_shake = nonzeros(output(j).shakepump)  + 0.3 ; %correcting to ignore "chosen" screen
        end
        output(j).resp = nonzeros(output(j).resp);
        output(j).choice = nonzeros(output(j).choice);
        output(j).choicescreen = nonzeros(output(j).choicescreen);
        output(j).null =  nonzeros(output(j).null);
        output(j).miss =  nonzeros(output(j).miss);
        output(j).resp_duration = output(j).choice - output(j).cue;
    end
   
   
end
