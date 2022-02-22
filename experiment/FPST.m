%%===================FOOD REWARD PROBABILISTIC TASK===================
%Coded by: Omer Reiner
%Modified code snippits from: B Kuzmanovic; S Thanarajah; A DiFeliceantonio and N Kroemer
%Coded with: Matlab R2017b using Psychtoolbox 3.0.14

%Script has two runs: learning trails / reinforcment learning (with fixed cue pairs and Gustometer Runs) and test trial / choice task (all cue pair permutations, no feedback)
%Script will present learning trials as customized by text input files (animal_cues.txt, jitter_list.txt)
%trial cue variables: 1-6 are cues, 0 are null events, -9 didn't choose in time, -1 filler for matching vector length
%================================

%%interesting variables/structs for after test finishes: subj.trigger (fin=first pic after dummies, all=dummy volumes) or clock, trial, onsets

clc; clear variables; close all;
addpath subfunctions;
fprintf('Starting new session....\n\n\n');

%% specify variables
blocks=2;           % 2 blocks - learning trials and test trials555
repetitions = 46;   %40*(number of fixed pairs is 3)*2=240 events   % how many repetitions of each pair should be in the learning trial (reinforcment learing) (one directional, so total is x2 for the flipped order)
repetitions_test = 4; %4*(number of pair permutations is 15)*2=120 events   % how many repetitions of each pair should be in the test trial (choice task) (one directional, so total is x2 for the flipped order)
null_events_learning = 0.1; % amount of null events to add to learning trial (reinforcment learing): 0.1 is adding 10% to the cue events as null events   
null_events_test = 0.1; % amount of null events to add to test trial (choice task): 0.1 adding 10% to the cue events as null events  
dummy_volumes = 10;  % seconds to leave off record from the beginning of scan, while magnet field stabilizes. depends on MRI sequence (TR)
dur.max = 4;        % total trial time, used only in choice task
dur.choice=0.3;     % duration of chosen cue presentation in secs, used only in choice task
dur.resp=1.7;       % duration of maximal response time, added 0.1 to test time
dur.pump=1.2;         % time between pump-start command and shake delivery
dur.shake=3.1;      % duration of pump and shake delivery
dur.rinse=2.7;      % duration of pump and shake delivery
dur.miss=2;         % duration of "time out" presentation
dur.null_event(1) = dur.resp + dur.shake + dur.pump; %+ dur.rinse + dur.pump; %duration of null event in learning trial (reinforcment learing)
dur.null_event(2) = dur.max;  %duration of null event in test trial (choice task)
rinse_pump = 3;     % start with run0 as neutral fluis pump (and alternate with later)
shake_pump = 2;     % start with run1 as shake pump (and alternate with 1 later)
pseudorandomize_bins = 10; %size of bin to be randomize for each Stimulus. helps avoiding "wrong paths" for subjects (for example, with pure random a subject might experience a set of consecutive losses for the A stimulus at the beginning) 
%Jitter Variables
jittermin = 0;
jittermax = 1500;
jitter_trials(1) = 3*repetitions*2;
jitter_trials(2) = 15*repetitions_test*2;

%%choose session type
%simulation: 1 if running at home and runs immediately. 2 needs simulating MRI-Pulses by pressing 5
%pilot_proband: 0 for test-subjects. 1 shows milkshake/rinse images while pumps are working. 2 is for pilot without gustometer, 3 is for full pilot with fprintf for experimenter 
ok = 0;
while not(ok)
options = {'Proband', 'Simulation', 'Pilot'}; 
[sessiontype,ok]= listdlg('PromptString','choose session type:',...
                    'SelectionMode','single',...
                    'Listsize', [100 60],...
                    'ListString',options);
                
simulation= 0;
pilot_proband =0;

    if sessiontype == 2 %Proband
         suboptions = {'run immediately', 'require pressing 5 & choose automatically'};
         [simulation,ok]= listdlg('PromptString','choose subtype:',...
                                     'SelectionMode','single',...
                                    'Listsize', [120 60],...
                                    'ListString',suboptions);
    end
     if sessiontype == 2 || sessiontype == 3 
         suboptions = {'show pumps & feedback', 'smily as feedback', 'run normal, trial output in matlab screen'};
        [pilot_proband,ok]= listdlg('PromptString','choose subtype:',...
                                    'SelectionMode','single',...
                                    'Listsize', [220 60],...
                                    'ListString',suboptions);

    end
end
    

%%Inizialize: Gustometer,...
if not(simulation)
    % prepare gustometer pumps
    % open port to pumps
    if exist('s1') == 1 % if a previous script exited with an error, you want to delete the serial communications to avoid an error in this script
        fclose(s1);
    end
    s1=serial('com8','baudrate',19200,'databits',8,'terminator',13);
    fopen(s1);
    
    % prompt
    studyID='FPST';
    prompt={'Subject ID', 'Height', 'Weight', 'Handedness', 'Age'};
    dlg_title='Input';
    numlines=1;
    answer=inputdlg(prompt,dlg_title,numlines);
    subjectID=char(answer(1));
    height=str2double(cell2mat(answer(2)));
    weight=str2double(cell2mat(answer(3)));
    handedness=char(answer(4));
    age=str2double(cell2mat(answer(5)));
    % synchronize with scanner
    do_fmri_flag = 1;
else % if simulation
    studyID = 'FPST';
    subjectID = 'simulation_subject';
    do_fmri_flag = 0;
end

if simulation == 2
     do_fmri_flag = 1;
end

%% load source files
% load the list of jitters
%jitterfile ='./source_files/jitter _list.txt';
%jitter = textread(jitterfile,'%f'); 
%uniform pseudorandom jitters. with second digit precision 
jitter = zeros(jitter_trials(1),2);
%jitter(:,1) = round(randi([jittermin jittermax], jitter_trials(1), 1)/1000,2); 
%jitter(1:jitter_trials(2),2) = round(randi([jittermin jittermax], jitter_trials(2), 1)/1000,2);  
%exponential pseudorandom jitters
jitter(:,1) = round((0.6+exprnd(0.3,jitter_trials(1),1)),2);
jitter(1:jitter_trials(2),2) = round((0.6+exprnd(0.3,jitter_trials(2),1)),2);

%%prepate cue and feedback set
stimulusfile ='./source_files/contingencies.txt';
[cuename, nCues, numstimpairs, cue_set, stimuli, stimuli_outcomes] = create_trials_list(stimulusfile, blocks, repetitions, repetitions_test, pseudorandomize_bins, null_events_learning, null_events_test);

%% prepare screen
[window, screen_config] = psychtoolbox_config(simulation);

%% correct timing
flipTime=Screen('GetFlipInterval',window);
for ff = fieldnames(dur)'
    dur.(ff{1}) = dur.(ff{1}) - flipTime;
end
    %these two shouldn't be corrected for fliptime, sense they have nothing
    %to do with the screen
dur.shake = dur.shake + flipTime;
dur.pump = dur.pump + flipTime;

%% prepare text screens
textsize = 30;
rectangle_width = 6;
cue_size = [000 000 400 400];
rect_size = cue_size + [0 0 100 100];
cue_left = CenterRectOnPointd(cue_size, screen_config.xCenter - 0.5*screen_config.xCenter, screen_config.yCenter);
cue_right = CenterRectOnPointd(cue_size, screen_config.xCenter + 0.5*screen_config.xCenter, screen_config.yCenter);
rect_left = CenterRectOnPointd(rect_size, screen_config.xCenter - 0.5*screen_config.xCenter, screen_config.yCenter);
rect_right = CenterRectOnPointd(rect_size, screen_config.xCenter + 0.5*screen_config.xCenter, screen_config.yCenter);
% Screen('TextSize', window, textsize);
% Screen('TextFont',window,'Arial');
% text
textsizelong = 20;
waitinstructions = ['Der Scanner wird jetzt fuer die Messung vorbereitet.' ...
    '\n\n Wenn sie anfaengt wird es laut werden.' ...
    '\n\n\n Am Ende der Messung kommt eine laengere Pause,' ...
    '\n\n waehrend der Sie ein + auf dem Bildschirm sehen (ca. 10 sec.).' ...
    '\n\n Bleiben Sie ruhig liegen bis die Messung aufhoert und es wieder leise wird.'];

testinstructions = ['Jetzt beginnt der zweite Teil der Untersuchung' ...
    '\n\n Ab sofort bekommen Sie kein Feedback zu Ihren Entscheidungen.'];

endinstructions = ['Die Untersuchung ist jetzt beendet.' ...
    '\n\n Es werden noch ein paar kurze Messungen durchgefuhrt.' ...
    '\n\n Bleiben Sie ruhig liegen bis die Messung aufhoert und es wieder leise wird.'];

ratingsinstructions = ['Das Test ist jetzt beendet.' ...
    '\n\n Bitte beantwortetn Sie den Fragebogen, der bald dargestellt wird'];

choice_screen_left =  Screen('OpenOffscreenwindow',window,[0 0 0]); Screen('FrameRect', window, [255 255 255], cue_left , rectangle_width);
choice_screen_right =  Screen('OpenOffscreenwindow',window,[0 0 0]); Screen('FrameRect', window, [255 255 255], cue_right , rectangle_width);
wait_screen= Screen('OpenOffscreenwindow',window,[0 0 0]); Screen('TextSize',wait_screen,textsizelong); Screen('TextFont',wait_screen,'Arial');
miss_screen= Screen('OpenOffscreenwindow',window,[0 0 0]); Screen('TextSize',miss_screen,textsize); Screen('TextFont',miss_screen,'Arial');
cross_screen = Screen('OpenOffscreenwindow',window, [0 0 0]); Screen('TextSize',cross_screen,textsize); Screen('TextFont',cross_screen,'Arial');
test_screen = Screen('OpenOffscreenwindow',window, [0 0 0]); Screen('TextSize',test_screen,textsizelong); Screen('TextFont',test_screen,'Arial');
end_screen = Screen('OpenOffscreenwindow',window, [0 0 0]); Screen('TextSize',end_screen,textsizelong); Screen('TextFont',end_screen,'Arial');
ratings_screen = Screen('OpenOffscreenwindow',window, [0 0 0]); Screen('TextSize',ratings_screen,textsizelong); Screen('TextFont',ratings_screen,'Arial');

%these are just for simulation needs
if simulation || pilot_proband == 1 || pilot_proband == 2
    milkshake_screen = Screen('MakeTexture', window, imread('stimuli/old/milkshake.jpg'));
    water_screen = Screen('MakeTexture', window, imread('stimuli/old/water.jpg'));
    rinse_screen = Screen('MakeTexture', window, imread('stimuli/old/rinse.jpg'));
    pump_screen = Screen('MakeTexture', window, imread('stimuli/old/pump.jpg'));
    happy_screen = Screen('MakeTexture', window, imread('stimuli/old/happy.jpg'));
    sad_screen = Screen('MakeTexture', window, imread('stimuli/old/sad.jpg'));
end
%Create screens
DrawFormattedText(wait_screen, waitinstructions, 'center', 'center', [255 255 255]);
DrawFormattedText(cross_screen, '+', 'center', 'center', [255 255 255]);
DrawFormattedText(miss_screen, 'Antwortzeit abgelaufen.', 'center', 'center', [255 255 255]);
DrawFormattedText(test_screen, testinstructions, 'center', 'center', [255 255 255]);
DrawFormattedText(end_screen, endinstructions, 'center', 'center', [255 255 255]);
DrawFormattedText(ratings_screen, ratingsinstructions, 'center', 'center', [255 255 255]);
%% prepare cue screens
tex = zeros(1,nCues);
for iStim = 1:nCues
    stimfilename=strcat('stimuli/',char(cuename(iStim)));
    tex(iStim)=Screen('MakeTexture', window, imread(char(stimfilename))); % make texture image out of image matrix 'imdata'
end
%% predefine output variables
% output information variables
trial.cue           =nan(numstimpairs, 2, blocks); 
trial.choice        =nan(numstimpairs, 1, blocks);
trial.RT            =nan(numstimpairs, 1, blocks);
%trial.contingency   =nan(numstimpairs, 1, blocks);
trial.shake         =nan(numstimpairs, 1, blocks);
% outuput temporal variables
onsets.jitter       =nan(numstimpairs, 1, blocks);
onsets.choicescreen =nan(numstimpairs, 1, blocks);
onsets.choice       =nan(numstimpairs, 1, blocks);
%onsets.resp         =nan(numstimpairs, 1, blocks);  %=onsets.cue
onsets.cue         =nan(numstimpairs, 1, blocks);
onsets.shakepump    =nan(numstimpairs, 1, blocks);
onsets.shake        =nan(numstimpairs, 1, blocks);
%onsets.rinsepump    =nan(numstimpairs, 1, blocks); %no rinse 
%onsets.rinse        =nan(numstimpairs, 1, blocks);
onsets.miss         =nan(numstimpairs, 1, blocks);
onsets.null         =nan(numstimpairs, 1, blocks);
trial.endtime       =nan(numstimpairs, 1, blocks);
%decided to deprecate option for user to change his mind
%allresp.choice     =nan(numstimpairs, 30, blocks); %log user changing his mind
%allresp.RT         =nan(numstimpairs, 30, blocks); %log user changing his mind


%present order so I can ask user later
fprintf('correct order was:\n %s\n %s\n %s\n %s\n %s\n %s\n', cuename{1}, cuename{3}, cuename{5}, cuename{6}, cuename{4}, cuename{2}); 

%% synchronize with the scanner
time0 = GetSecs;
Screen('CopyWindow', wait_screen, window);
Screen('Flip', window);
if simulation
    WaitSecs(1);
end

%% start experiment
for iBlock=1:blocks
    %%show test instructions between blocks   
    if iBlock == 2        
        Screen('CopyWindow',test_screen, window);
        Screen('Flip', window);
        beep on 
        time_beep = GetSecs;
        beep; WaitSecs(1); beep; WaitSecs(1); beep; WaitSecs(1);
    end
    %%Wait for scanner trigger
    [subj(iBlock)] = get_fmri_signal(cross_screen, window, simulation, do_fmri_flag, dummy_volumes, iBlock);
    clock = GetSecs; % get time zero for each block (two seperate fMRI seqeunces!)
    
    %jitter variable. in order to skip null events without comprimising the
    % normal distrubtion, using unique variable jcount instead of iTrial
    jcount = 1;
    
    %%continue to block 2 after pause
    if iBlock == 2      
       WaitSecs(55 - (GetSecs - time_beep));
       beep on 
       beep; WaitSecs(1); beep; WaitSecs(1); beep; WaitSecs(1)
       %%give users more time to choose in test
       dur.resp = dur.resp + 0.1;
    end
    
    for iTrial=1:numstimpairs
        trialstart  = GetSecs; %used for choice task, because total trial time should be dur.max seconds
        if pilot_proband
            fprintf('iTrial:%d, block:%d, time:%f \n', iTrial, iBlock, (GetSecs - clock)); %used for debugging
        end
        %%Break loop on end of Test Block
        %test trial block cue_set(c:,:,2) is shorter than learning trial cue_set(:,:,1), but the vectors need to match 
        %so the matrix tail is filled with -1. the loop brakes on receiving a -1
        if cue_set(iTrial,1,iBlock) == -1
            break
        end
        %% jitter 1
        Screen('CopyWindow',cross_screen, window);
        Screen('Flip', window);
        %% present cue pair, unless it's a null event
        if cue_set(iTrial,1,iBlock) > 0 % 0 is null event, stays with cross screen
            onsets.jitter(iTrial, 1, iBlock) = GetSecs - clock;
            WaitSecs(jitter(jcount,iBlock));
            jcount = jcount + 1;
            %% present the cue pair 
            Screen('DrawTextures', window, tex(cue_set(iTrial,1,iBlock)), [], cue_left);
            Screen('DrawTextures', window, tex(cue_set(iTrial,2,iBlock)), [], cue_right);
            Screen('Flip',window, [], 1);

            onsets.resp(iTrial, 1, iBlock) = GetSecs - clock;
            onsets.cue(iTrial, 1, iBlock) = GetSecs - clock;
            onset_resp = GetSecs;
            trial.cue(iTrial,:, iBlock) = cue_set(iTrial,:,iBlock);
            %WaitSecs(dur.resp);

            %% get the response
            % while loop to try to get response until "dur.resp" seconds elapsed.
            while (GetSecs - onset_resp) <= dur.resp
                [x,y,buttons] = GetMouse;
                if simulation == 2
                    buttons(3)=1;
                    WaitSecs(1);
                end
                if buttons(3) == 1 %cue_set(iTrial,2,iBlock) is right side cue
                    trial.RT(iTrial, 1, iBlock) = GetSecs - onset_resp;
                    trial.choice(iTrial, 1, iBlock) = cue_set(iTrial,2,iBlock); 
                    onsets.choice(iTrial, 1, iBlock) = GetSecs - clock;
                    Screen('FrameRect', window, [255 255 255], rect_right, rectangle_width);
                    %fprintf('right choice: %d %s\n', trial.choice(iTrial,iBlock), stimuli.cues(trial.choice(iTrial,iBlock)).cuename{1});
                    break;
                elseif buttons(1) == 1 %cue_set(iTrial,1,iBlock) is left side cue
                    trial.RT(iTrial, 1, iBlock) = GetSecs - onset_resp;
                    trial.choice(iTrial, 1, iBlock) = cue_set(iTrial,1,iBlock);
                    onsets.choice(iTrial, 1, iBlock) = GetSecs - clock;
                    Screen('FrameRect', window, [255 255 255], rect_left, rectangle_width);
                    %fprintf('left choice: %d %s\n', trial.choice(iTrial,iBlock), stimuli.cues(trial.choice(iTrial,iBlock)).cuename{1});
                    break;
                %else %moved out of loop in favor of (possible?) performance
                    %trial.choice(iTrial, 1, iBlock) = -9; % if user didn't choose
                end
                pause(0.01); %slow down the loop to avoid the computer freezing
            end
            if isnan(trial.choice(iTrial, 1, iBlock))
                trial.choice(iTrial, 1, iBlock) = -9; % if user didn't choose
            end
            %% if user chose, show chosen screen, check and deliver outcome
            if trial.choice(iTrial, 1, iBlock) > 0       
                Screen('Flip', window);
                onsets.choicescreen(iTrial, 1, iBlock) = GetSecs - clock;
                if iBlock == 2
                    WaitSecs(dur.choice);
                end
                %fprintf('time choice screen: %f', GetSecs);
                %% specify the outcome: milkshake or neutral 
                if iBlock == 1
                    iAB = 0; %count through pair in order to retrieve stimulus result
                    iCD = 0;
                    iEF = 0;
                    switch trial.choice(iTrial, 1, iBlock)
                        case {1,2}
                            iAB = iAB + 1;
                            k = iAB;
                        case {3,4}
                            iCD = iCD + 1;
                            k = iCD;
                        case {5,6}
                            iEF = iEF + 1;
                            k = iEF;
                    end
                    trial.shake(iTrial, 1, iBlock) = stimuli_outcomes(k,trial.choice(iTrial, 1, iBlock)); %retrieve result for cue from pseudorandom result matrix
                    if trial.shake(iTrial, 1, iBlock)
                        if shake_pump == 1
                            shake = '2run'; %pleasant shake
                            shake_pump = 2;
                        elseif shake_pump == 2
                            shake = '1run'; %reserve pleasant shake
                            shake_pump = 1;
                        end
                        if pilot_proband
                            fprintf('won! with %s with contigency of: %f\n',stimuli.cues(trial.choice(iTrial, 1, iBlock)).cuename{1} ,stimuli.cues(trial.choice(iTrial, 1, iBlock)).contingency);
                        end
                        if simulation && (iBlock==1) && not(pilot_proband)
                            Screen('DrawTextures', window, milkshake_screen, [], [screen_config.xCenter-100 screen_config.yCenter-100 screen_config.xCenter+100 screen_config.yCenter+100]);
                            Screen('Flip',window);
                            WaitSecs(0.4);
                            Screen('CopyWindow',cross_screen, window);
                            Screen('Flip', window);
                        end
                    else 
                        if rinse_pump == 0
                            shake = '3run'; %neutral fluid
                            rinse_pump = 3;
                        elseif rinse_pump == 3
                            shake = '0run'; %reserve neutral fluid
                            rinse_pump = 0;
                        end
                        if pilot_proband
                            fprintf('lost... with %s with contigency of: %f\n',stimuli.cues(trial.choice(iTrial, 1, iBlock)).cuename{1} ,stimuli.cues(trial.choice(iTrial, 1, iBlock)).contingency);
                        end
                        if simulation && (iBlock==1) && not(pilot_proband)
                            Screen('DrawTextures', window, water_screen, [], [screen_config.xCenter-100 screen_config.yCenter-100 screen_config.xCenter+100 screen_config.yCenter+100]);
                            Screen('Flip',window);
                            WaitSecs(0.4);
                            Screen('CopyWindow',cross_screen, window);
                            Screen('Flip', window);
                        end
                    end
                

                %% provide milkshake/neutral solution, only during learning phase (iBlock==1)
                
                    if simulation
                       s1 = 'simulation.txt\n'; 
                    end
                    fprintf(s1, shake); 
                    if pilot_proband
                       fprintf('delivering from %s\n\n', shake);  
                    end
                    onsets.shakepump(iTrial, 1, iBlock) = GetSecs - clock;
                    WaitSecs(dur.choice);
                    Screen('CopyWindow',cross_screen, window);
                    Screen('Flip', window);
                    if pilot_proband == 1
                        Screen('DrawTextures', window, pump_screen, [], [screen_config.xCenter-100 screen_config.yCenter-300 screen_config.xCenter+100 screen_config.yCenter-150]);
                        Screen('Flip', window, [], 1);
                    end
                    WaitSecs(dur.pump - dur.choice); % wait for milkshake arrival
                    onsets.shake(iTrial, 1, iBlock) = GetSecs - clock;
                        if pilot_proband == 1 
                            if strcmp(shake,'1run')
                                result_shake = milkshake_screen;
                            else
                                result_shake = water_screen;
                            end
                            Screen('DrawTextures', window, result_shake, [], [screen_config.xCenter-100 screen_config.yCenter-140 screen_config.xCenter+100 screen_config.yCenter+10]);
                            Screen('Flip', window);
                        end
                        if pilot_proband == 2 
                            if strcmp(shake,'1run')
                                result_shake = happy_screen;
                            else
                                result_shake = sad_screen;
                            end
                            Screen('DrawTextures', window, result_shake, [], [screen_config.xCenter-200 screen_config.yCenter-200 screen_config.xCenter+200 screen_config.yCenter+200]);
                            Screen('Flip', window);
                            
                            WaitSecs(dur.shake); % wait for milkshake delivery
                            
                            Screen('CopyWindow',cross_screen, window);
                            Screen('Flip', window, [], 1);
                        end
                    % rinse
                    %{
                    if rinse_pump
                        %fprintf('delivering rinse from 3\n');
                        fprintf(s1, '3run');
                        rinse_pump = 0;
                    else
                        %fprintf('delivering rinse from 0\n');
                        fprintf(s1, '0run');
                        rinse_pump = 3;
                    end
                    onsets.rinsepump( iTrial, 1, iBlock)=GetSecs-clock;
                        if pilot_proband == 1
                            Screen('DrawTextures', window, pump_screen, [], [screen_config.xCenter-100 screen_config.yCenter+20 screen_config.xCenter+100 screen_config.yCenter+170]);
                            Screen('Flip', window, [], 1);
                        end
                    WaitSecs(dur.pump); % wait for rinse arrival
                    onsets.rinse( iTrial, 1, iBlock)=GetSecs-clock;
                        if pilot_proband == 1
                            Screen('DrawTextures', window, rinse_screen, [], [screen_config.xCenter-100 screen_config.yCenter+180 screen_config.xCenter+100 screen_config.yCenter+330]);
                            Screen('Flip', window);
                        end
                    %WaitSecs(dur.rinse); % wait for rinse delivery
                    %}
                    WaitSecs(dur.shake); % wait for milkshake delivery
                end   
                if iBlock == 2 %this IF condition is redundant with the current parameters(pump runs are way longer than dur.max), but wrote it in case they change...
                    trialend = GetSecs;
                    if (trialend - trialstart) < dur.max
                        Screen('CopyWindow',cross_screen, window);
                        Screen('Flip', window);
                        WaitSecs(dur.max - (trialend - trialstart));
                    end
                end
            %if the proband was to slow show miss_screen
            elseif trial.choice(iTrial, 1, iBlock) == -9
                    % display time out
                    Screen('CopyWindow',miss_screen, window);
                    Screen('Flip',window);
                    onsets.miss( iTrial, 1, iBlock)=GetSecs-clock;
                    %fprintf('maximum time elapsed\n');
                    WaitSecs(dur.miss);
                    Screen('CopyWindow',cross_screen, window);
                    Screen('Flip', window);
            end 
        %if null event, show cross screen for some seconds
        elseif cue_set(iTrial,1,iBlock) == 0
             onsets.null(iTrial, 1, iBlock)=GetSecs-clock;
             %commented out as
             %null events were previously evaluated as NaN in the
             %FPST_accuracy.m code, now as zeros
             trial.cue(iTrial, :, iBlock) = [0 0]; 
             trial.choice(iTrial, 1, iBlock) = 0;
             %fprintf('null event\n');
             WaitSecs(dur.null_event(iBlock));
        end
        trial.endtime( iTrial, 1, iBlock)=GetSecs-clock;
        %% save a backup file in a different folder using the date as unique
        %identifier including all information to avoid potential loss of data
        runtime = (GetSecs-clock)/(60);
        save_filename=[studyID '_' subjectID,'_' datestr(now,'_yymmdd_HHMM') '.mat'];
            backupdir = (fullfile('data/raw/Backup', num2str(subjectID)));
            if exist(backupdir,'dir') == 0
                mkdir (backupdir);
            end
        save(fullfile(backupdir, save_filename));
    end
    sequence_runtime(iBlock) = (GetSecs-clock)/(60);
end

%workaround for "Subscripted assignment between dissimilar structures."
 subj(1).sequence_runtime = sequence_runtime(1);
 subj(2).sequence_runtime = sequence_runtime(2); 

%% Write your data file and clean up your mess
subj(1).total_runtime = (GetSecs-time0)/(60);
outputdir = (fullfile('data/raw/logfiles' , [studyID '_' num2str(subjectID)]));
if exist(outputdir,'dir') == 0
mkdir (outputdir);
end
outputfile = [studyID '_' subjectID  '.mat'];
save(fullfile(outputdir, outputfile));
save(fullfile(outputdir, [outputfile '_logs']), 'trial', 'onsets', 'subj', 'clock');

if not(simulation)
    fclose(s1);
end
fprintf('end test');

%%run ratings
Screen('CopyWindow',ratings_screen, window);
Screen('Flip',window);
%wait for non 5 keypress.
%fprintf('dear experimenter, please click any button (other than 5) to go to ratings test!\n');
%WaitNon5;
WaitSecs(7);
Screen('CloseAll');
FPST_Ratings(subjectID, 'FPST', 'PostIntervention', 'Milkshake_Rating', screen_config, window, simulation);

[trial, numevents] = get_accuracy(trial, 2, 2); %get accuracy only for test  
present_accuracy(trial, numevents, cuename); 
%Screen('CloseAll');
clear;
sca;
