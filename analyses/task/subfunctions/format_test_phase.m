%%todo: make sure "notinteresting" events are correctly saved (see AB,CD,EF
%%events)
%%make sure Vstate rel and softmax are okay 

%% auxiliary function for analyze_task
% Vsoftmax is probabily of model to have chosen the cue like the subject
% Vstate cue values weighted by probabilites
% Vrelative is value of chosen minus unchosen

function [onsets, trial, model, forTest] = format_test_phase(trial, model, onsets, posterior, first_block, last_block, phase, binSize, binSizeAll)   
    if nargin < 5
        last_block = first_block;
    end
    
    if not(exist('binSize', 'var'))
        binSize = 4 ;
    end
       
    if not(exist('binSizeAll', 'var'))
        binSize = 12;
    end
   
    
    %%initiziale variables
    %number of total events
    numevents = sum(~isnan(trial.cue(:,1,:)));
    %variables for test outcome
    trial.choose1 = nan(numevents(2),2);
    trial.avoid2= nan(numevents(2),2);
    trial.not_12 = nan(numevents(2),2);
    trial.winwin = nan(numevents(2),2);
    trial.loselose = nan(numevents(2),2);
    trial.winlose = nan(numevents(2),2);
    trial.AB = nan(numevents(1),2);
    trial.CD = nan(numevents(1),2);
    trial.EF = nan(numevents(1),2);
    trial.Vrelative  = nan(numevents(2),2);
    trial.Vstate  = nan(numevents(2),2);
	%trial.missed_events = zeros(2,1);
    
    %Qchosen in test phase is just the last ones from the learning phase,
    %but learning phase is updated trial per trial
    if size(posterior.muX,2)<size(trial.cue,1)
        Q = NaN(6,size(trial.cue,1),2); %Q = NaN(6,size(posterior.muX,2),2); has issues with tranfer phase
    %being shorter when analysing alone
        padded_muX = [posterior.muX NaN(6,(size(trial.cue,1)-size(posterior.muX,2)))];
         %padding transfer phase with NaNs as workaround for above issue
    else
        Q = NaN(6,size(posterior.muX,2),2);
        padded_muX = posterior.muX;
    end
    Q(:,:,1) = padded_muX;
    Q(:,:,2) = repmat(posterior.muX(:,end),1,size(padded_muX,2));
	p = posterior.probability; %p = out.Suffstat.gx((numevents(1)+1):end);
	
    j=1; k =1; l=1; m=1; n=1; s=1;
        
    for iB = first_block:last_block
        %clean up cue vectors from nans and null events, irelevent for test
        %needs to be done before so it can be consistent with the cleaned
        %up onset vector
        %but save indices of missed events to use for correct_bins
        A1 = nonzeros(trial.cue(:,1,iB));
        A2 = nonzeros(trial.cue(:,2,iB));
        Bb = nonzeros(trial.choice(:, 1, iB));
            missed_events = find(Bb==-9);
            missed_AB = intersect(missed_events, sort([find(A1==1) ; find(A1==2)])); %this AB is the pair AB, other A B here are left right
            missed_CD = intersect(missed_events, sort([find(A1==3) ; find(A1==4)]));
            missed_EF = intersect(missed_events, sort([find(A1==5) ; find(A1==6)]));
        A1(find(Bb==-9))= []; A2(find(Bb==-9))= [];
        A1(isnan(A1))=[]; A2(isnan(A2))=[];
        Bb(find(Bb==-9))= [];
        Aa = [A1,A2];
        Bb(isnan(Bb)) = [];
            for iT=1:numel(onsets(iB).cue)
               A = Aa(iT,:);
               B = Bb(iT); %chosen cue
			   C = B - 1 * (-1).^mod(B,2) ; %complement cue to B 
               %if not(isnan(A)) %if not NaN (only end of block?, redundent?)
               %    if A %if not null event as Zero
                        switch B 
                            %case -9 %time elapsed events are defined by -9
                            %  trial.missed_events(iB) = trial.missed_events(iB) + 1;
                            case 1
                                %choose A is only for novel combinations! 
                                if not(A(A~=B)==2)
                                    trial.choose1(iT,iB) = 1;
                                    onsets(iB).choose1(l) = onsets(iB).cue(iT);
                                    l = l + 1;
                                end
                                switch A(A~=B)
                                    case 2
                                        trial.AB(iT,iB) = 1; 
                                        %trial.avoid2(iT,iB) = 1; %Avoid B
                                        %only for novel combis!
                                        trial.winlose(iT,iB) = 1;                                        
                                        %onsets(iB).avoid2(m) = onsets(iB).cue(iT);
                                        onsets(iB).winlose(n) = onsets(iB).cue(iT);   
                                        %m = m + 1;
                                        n = n + 1; 
                                    case 3
                                        trial.winwin(iT,iB) = 1;
                                        onsets(iB).winwin(j) = onsets(iB).cue(iT);
                                        j = j + 1;
                                    case 4
                                        trial.winlose(iT,iB) = 1;                                         
                                        onsets(iB).winlose(n) = onsets(iB).cue(iT);
                                        n = n + 1;
                                    case 5
                                        trial.winwin(iT,iB) = 1;
                                        onsets(iB).winwin(j) = onsets(iB).cue(iT);
                                        j = j + 1;
                                    case 6
                                        trial.winlose(iT,iB) = 1;                                        
                                        onsets(iB).winlose(n) = onsets(iB).cue(iT);
                                        n = n + 1;
                                end
                            case 3  
                                switch A(A~=B)
                                    case 1
                                        trial.choose1(iT,iB) = 0;
                                        trial.winwin(iT,iB) = 0;
                                        onsets(iB).choose1(l) = onsets(iB).cue(iT);
                                        onsets(iB).winwin(j) = onsets(iB).cue(iT);
                                        l = l + 1;
                                        j = j + 1;
                                    case 2
                                        trial.avoid2(iT,iB) = 1;
                                        trial.winlose(iT,iB) = 1;                                         
                                        onsets(iB).winlose(n) = onsets(iB).cue(iT);                                         
                                        onsets(iB).avoid2(m) = onsets(iB).cue(iT);
                                        m = m + 1;
                                        n = n + 1; 
                                    case 4
                                        trial.CD(iT,iB) = 1; 
                                        trial.winlose(iT,iB) = 1; 
                                        trial.not_12(iT,iB) = 1; 
                                        onsets(iB).not_12(s) = onsets(iB).cue(iT);
                                        s = s + 1;
                                        onsets(iB).winlose(n) = onsets(iB).cue(iT);
                                        n = n + 1; 
                                    case 5
                                        trial.winwin(iT,iB) = 1;
                                        onsets(iB).winwin(j) = onsets(iB).cue(iT);
                                        j = j + 1;
                                        trial.not_12(iT,iB) = 1; 
                                        onsets(iB).not_12(s) = onsets(iB).cue(iT);
                                        s = s + 1;
                                    case 6
                                        trial.winlose(iT,iB) = 1;                                         
                                        onsets(iB).winlose(n) = onsets(iB).cue(iT);
                                        n = n + 1;
                                        trial.not_12(iT,iB) = 1; 
                                        onsets(iB).not_12(s) = onsets(iB).cue(iT);
                                        s = s + 1;
                                end
                            case 5
                                switch A(A~=B)
                                    case 1
                                        trial.choose1(iT,iB) = 0;
                                        trial.winwin(iT,iB) = 0;
                                        onsets(iB).choose1(l) = onsets(iB).cue(iT);
                                        onsets(iB).winwin(j) = onsets(iB).cue(iT);
                                        j = j + 1;
                                        l = l + 1;
                                    case 2
                                        trial.avoid2(iT,iB) = 1;
                                        trial.winlose(iT,iB) = 1;                                         
                                        onsets(iB).winlose(n) = onsets(iB).cue(iT);
                                        onsets(iB).avoid2(m) = onsets(iB).cue(iT);
                                        m = m + 1;
                                        n = n + 1;
                                    case 4
                                        trial.winlose(iT,iB) = 1;                                         
                                        onsets(iB).winlose(n) = onsets(iB).cue(iT);
                                        n = n + 1;
                                        trial.not_12(iT,iB) = 1; 
                                        onsets(iB).not_12(s) = onsets(iB).cue(iT);
                                        s = s + 1;
                                    case 3
                                        trial.winwin(iT,iB) = 0;
                                        onsets(iB).winwin(j) = onsets(iB).cue(iT);
                                        j = j + 1;
                                        trial.not_12(iT,iB) = 0; 
                                        onsets(iB).not_12(s) = onsets(iB).cue(iT);
                                        s = s + 1;
                                    case 6
                                        trial.EF(iT,iB) = 1;
                                        trial.winlose(iT,iB) = 1;                                        
                                        onsets(iB).winlose(n) = onsets(iB).cue(iT);
                                        n = n + 1; 
                                        trial.not_12(iT,iB) = 1; 
                                        onsets(iB).not_12(s) = onsets(iB).cue(iT);
                                        s = s + 1;
                                end
                            case 6
                                switch A(A~=B)
                                    case 1
                                        trial.choose1(iT,iB) = 0;
                                        trial.winlose(iT,iB) = 0; 
                                        onsets(iB).choose1(l) = onsets(iB).cue(iT);                                                                          
                                        onsets(iB).winlose(n) = onsets(iB).cue(iT);
                                        l = l + 1;
                                        n = n + 1; 
                                    case 2
                                        trial.avoid2(iT,iB) = 1;
                                        trial.loselose(iT,iB) = 1;
                                        onsets(iB).loselose(k) = onsets(iB).cue(iT);
                                        onsets(iB).avoid2(m) = onsets(iB).cue(iT);
                                        k = k + 1;
                                        m = m + 1;
                                    case 3
                                        trial.winlose(iT,iB) = 0;                                         
                                        onsets(iB).winlose(n) = onsets(iB).cue(iT);
                                        n = n + 1;
                                        trial.not_12(iT,iB) = 0; 
                                        onsets(iB).not_12(s) = onsets(iB).cue(iT);
                                        s = s + 1;
                                    case 4
                                        trial.loselose(iT,iB) = 1;
                                        onsets(iB).loselose(k) = onsets(iB).cue(iT);
                                        k = k + 1;
                                        trial.not_12(iT,iB) = 1; 
                                        onsets(iB).not_12(s) = onsets(iB).cue(iT);
                                        s = s + 1;
                                    case 5
                                        trial.EF(iT,iB) = 0;
                                        trial.winlose(iT,iB) = 0;                                        
                                        onsets(iB).winlose(n) = onsets(iB).cue(iT);
                                        n = n + 1; 
                                        trial.not_12(iT,iB) = 0; 
                                        onsets(iB).not_12(s) = onsets(iB).cue(iT);
                                        s = s + 1;
                                end
                            case 4
                                switch A(A~=B)
                                    case 1
                                        trial.choose1(iT,iB) = 0;
                                        trial.winlose(iT,iB) = 0;
                                        onsets(iB).choose1(l) = onsets(iB).cue(iT);                                                                          
                                        onsets(iB).winlose(n) = onsets(iB).cue(iT);
                                        l = l + 1;
                                        n = n + 1; 
                                    case 2
                                        trial.avoid2(iT,iB) = 1;
                                        trial.loselose(iT,iB) = 1;
                                        onsets(iB).loselose(k) = onsets(iB).cue(iT);
                                        onsets(iB).avoid2(m) = onsets(iB).cue(iT);
                                        k = k + 1;
                                        m = m + 1;
                                    case 3
                                        trial.CD(iT,iB) = 0; 
                                        trial.winlose(iT,iB) = 0;                                        
                                        onsets(iB).winlose(n) = onsets(iB).cue(iT);
                                        n = n + 1; 
                                        trial.not_12(iT,iB) = 0; 
                                        onsets(iB).not_12(s) = onsets(iB).cue(iT);
                                        s = s + 1;
                                    case 5
                                        trial.winlose(iT,iB) = 0;                                         
                                        onsets(iB).winlose(n) = onsets(iB).cue(iT); 
                                        n = n + 1;
                                        trial.not_12(iT,iB) = 0; 
                                        onsets(iB).not_12(s) = onsets(iB).cue(iT);
                                        s = s + 1;
                                    case 6 
                                         trial.loselose(iT,iB) = 0;
                                         onsets(iB).loselose(k) = onsets(iB).cue(iT);
                                         k = k + 1;
                                         trial.not_12(iT,iB) = 0; 
                                         onsets(iB).not_12(s) = onsets(iB).cue(iT);
                                         s = s + 1;
                                end
                            case 2
                                %avoid B is only for noval combinations! 
                                if not(A(A~=B)==1)
                                    trial.avoid2(iT,iB) = 0;
                                    onsets(iB).avoid2(m) = onsets(iB).cue(iT);
                                    m = m + 1;
                                end
                                switch A(A~=B)
                                    case 1
                                        trial.AB(iT,iB) = 0;
                                        %trial.choose1(iT,iB) = 0;
                                        trial.winlose(iT,iB) = 0; 
                                        %onsets(iB).choose1(l) = onsets(iB).cue(iT);
                                        onsets(iB).winlose(n) = onsets(iB).cue(iT);
                                        n = n + 1; 
                                        %l = l + 1;
                                    case 3
                                        trial.winlose(iT,iB) = 0;                                         
                                        onsets(iB).winlose(n) = onsets(iB).cue(iT);
                                        n = n + 1;
                                    case 5
                                        trial.winlose(iT,iB) = 0;                                         
                                        onsets(iB).winlose(n) = onsets(iB).cue(iT);
                                        n = n + 1;
                                    case 4
                                        trial.loselose(iT,iB) = 0;
                                        onsets(iB).loselose(k) = onsets(iB).cue(iT);
                                        k = k + 1;
                                    case 6
                                        trial.loselose(iT,iB) = 0;
                                        onsets(iB).loselose(k) = onsets(iB).cue(iT);
                                        k = k + 1;
                                end
                            otherwise
                               disp('some outcome was missed in the code');
                        end
                        if B>0 %don't check state for missed trials
                            model.Qchosen(iT,iB) = Q(B,iT,iB);
                            model.Qunchosen(iT,iB) = Q(C,iT,iB);
                            %there might be an issue here with the split
                            %phases anaylsis (only test)
                            model.Vrelative(iT,iB) = Q(B,iT,iB) - Q(C,iT,iB);
                            model.Vstate(iT,iB)= p(C,B)*Q(B,iT,iB) + p(B,C)*Q(C,iT,iB); % I originally mest up row and column in posterior.probability!!!
                            model.Vsoftmax(iT,iB) = p(C,B);
                        end
                  % end
               %end
            end
			
			%remove null events from total number of events for block, but only after iterating over the whole block
			numevents(iB) = numevents(iB) - sum(trial.cue(:,1,iB)==0);
			trial.correct(iB) = nansum(trial.winwin(:,iB)) + ...
				nansum(trial.loselose(:,iB)) + ...
				nansum(trial.winlose(:,iB));
			if iB==1
                %count correct trials divided by bins. 12 is a good divider. count NaNs (missed events) as zeros because this makes the bins fixed size
                [trial.correct_bins.all] = count_bins(trial.winlose(:,iB), missed_events, binSizeAll)'; %winlose in block 1 are all the pairs
                %repeat for single pairs
                %in order to avoid errors down the line, only temporarily
                %changing trials.pairs, consider refactoring the code used
                %later
                ABs = trial.AB(:,iB);
                ABs(find(trial.choice(:,1,iB))==0)=[]; 
                CDs = trial.CD(:,iB);
                CDs(find(trial.choice(:,1,iB))==0)=[]; 
                EFs = trial.EF(:,iB);
                EFs(find(trial.choice(:,1,iB))==0)=[]; 
                [trial.correct_bins.AB] = count_bins(ABs, missed_AB, binSize)';
                [trial.correct_bins.CD] = count_bins(CDs, missed_CD, binSize)';
                [trial.correct_bins.EF] = count_bins(EFs, missed_EF, binSize)';
            end
            if iB==2

                onsets(iB).loselose(isnan(onsets(iB).loselose)) = [];
                onsets(iB).winwin(isnan(onsets(iB).winwin)) = []; 
                onsets(iB).winlose(isnan(onsets(iB).winlose)) = []; 
                onsets(iB).choose1(isnan(onsets(iB).choose1)) = [];
                onsets(iB).avoid2(isnan(onsets(iB).avoid2)) = []; 
                onsets(iB).not_12(isnan(onsets(iB).not_12)) = [];
            end
    end
    
    model.Qchosen(isnan(model.Qchosen),:) = [];
    model.Qunchosen(isnan(model.Qunchosen),:) = [];
    model.Vrelative(isnan(model.Vrelative),:) = []; 
    model.Vstate(isnan(model.Vstate),:) = []; 
    model.Vsoftmax(isnan(model.Vsoftmax),:) = []; 
    
    if strcmp(phase,'only_test_phase')
        model.Qchosen = model.Qchosen';
        model.QchosenTest = model.Qchosen;
        model.Qunchosen = model.Qunchosen';
        model.Vrelative = model.Vrelative'; 
        model.Vstate = model.Vstate'; 
        model.Vsoftmax = model.Vsoftmax'; 
    else
        %%some bug with test_only is making these vectors wrong. trimmed down to the two column but need to review the correctness
        model.Qchosen(:,3:end) = []; 
        if(not(isvector(model.Qchosen))) %%skip for 7873 which doesn't have transfer phase
            model.QchosenTest =  nonzeros(model.Qchosen(:,2)); 
        end
        model.Qunchosen(:,3:end) = [];
        model.Vrelative(:,3:end) = []; 
        model.Vstate(:,3:end) = []; 
        model.Vsoftmax(:,3:end) = []; 
    end
    
    if iB==2 %skip for 7683 
        [forTest.durations forTest.Qchosen] = sort_duration_and_Qchosen_test(onsets, model);
    else
        forTest = 'no transfer phase was aquired for this subject'
    end
end