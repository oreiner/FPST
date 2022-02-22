%%===================FOOD REWARD PROBABILISTIC TASK===================
%Coded by: Omer Reiner
%Modified code from: B Kuzmanovic; A DiFeliceantonio and N Kroemer; S Thanarajah
%Coded with: Matlab R2017b using Psychtoolbox 3.0.14

%Script has two runs: learning trails / reinforcment learning (with fixed cue pairs and Gustometer Runs) and test trial / choice task (all cue pair permutations, no feedback)
%Script will present learning trials as customized by text input files (animal_cues.txt, jitter_list.txt)
%trial cue variables: 1-6 are cues, 0 are null events, -9 didn't choose in time, -1 filler for matching vector length
%================================

%changed clear all to clear variables because matlab recommended. make sure
%this isn't a problem
clc; clear variables; close all;
%fprintf('Starting new session....\n\n\n');

%% specify variables
simulation= 1;      % 1 if running at home
blocks=2;           % 2 blocks - learning trials and test trials
numstimpairs = 5;
pilot_proband = 2;  % 1 shows milkshake/rinse images while pumps are working. simulation variable should be set to zero! 2 is for pilot without gustometer
repetitions = 1;   %30*(number of fixed pairs is 3)*2=180 events   % how many repetitions of each pair should be in the learning trial (reinforcment learing) (one directional, so total is x2 for the flipped order)
repetitions_test = 1/5; %3*(number of pair permutations is 15)*2=90 events   % how many repetitions of each pair should be in the test trial (choice task) (one directional, so total is x2 for the flipped order)
null_events_learning = 0.1; % amount of null events to add to learning trial (reinforcment learing): 0.1 is adding 10% to the cue events as null events   
null_events_test = 0.1; % amount of null events to add to test trial (choice task): 0.1 adding 10% to the cue events as null events  
dummy_volumes = 0;  % seconds to leave off record from the beginning of scan, while magnet field stabilizes. depends on MRI sequence (TR)
dur.max = 4;        % total trial time, used only in choice task
dur.choice=0.3;     % duration of chosen cue presentation in secs, used only in choice task
dur.resp=1.7;       % duration of maximal response time
dur.pump=2;         % time between pump-start command and shake delivery
dur.shake=3.7;      % duration of pump and shake delivery
dur.rinse=2.7;      % duration of pump and shake delivery
dur.miss=2;         % duration of "time out" presentation
dur.null_event(1) = dur.resp + dur.shake + dur.pump; %+ dur.rinse + dur.pump; %duration of null event in learning trial (reinforcment learing)
dur.null_event(2) = dur.max;  %duration of null event in test trial (choice task)
rinse_pump = 3;     % start with run3 as rinse pump (and alternate with 0 later)
%Jitter Variables
jittermin = 0;
jittermax = 1500;
jitter_trials(1) = 3*repetitions*2;
jitter_trials(2) = 15*repetitions_test*2;

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

%% load source files
% load the list of jitters
%jitterfile ='./source_files/jitter_list.txt';
%jitter = textread(jitterfile,'%f');
%uniform pseudorandom jitters. with second digit precision 
jitter = zeros(jitter_trials(1),2);
%jitter(:,1) = round(randi([jittermin jittermax], jitter_trials(1), 1)/1000,2); 
%jitter(1:jitter_trials(2),2) = round(randi([jittermin jittermax], jitter_trials(2), 1)/1000,2);  
%exponential pseudorandom jitters
jitter(:,1) = round((0.7+exprnd(0.3,jitter_trials(1),1)),2);
jitter(1:jitter_trials(2),2) = round((0.7+exprnd(0.3,jitter_trials(2),1)),2);

stimulusfile ='./source_files/animal_cues.txt';
% cue: which cue? associated with the contigency and assigned a random picture
% contingency: e.g., 0.8 -> milkshake 80% neutral rinse 20%; 0.2 -> milkshake 20%
% cuename: picture file name, e.g. swan.jpg
[ cues, contingency, cuename ] = textread(stimulusfile,'%d %f %s');

rng('shuffle');                       % ensure random is random
nCues=length(cues);                   % get number of trials
randomorder=randperm(nCues);          % randomize an array, size = numel trials
cuename = cuename(randomorder);       % only randomize the pictures. The training should always be constant pairs (80/20, 70/30, 60/40). in order to evaluate them later it should always be (1/2, 3/4, 5/6)

cue_set(:,:,1) = [1,3 ; 2,4 ; 6,5; 0,0; 3,1 ];      
cue_set(:,:,2) = [1,4; 3,6 ; 4,2 ; NaN,NaN ; NaN,NaN]; 

for i=1:nCues
    stimuli.cues(i).contingency = contingency(i);
    stimuli.cues(i).cuename = cuename(i);
end

%stimuli struct: associate each cue (1,2,3,4,5,6) with a contigency (0.8,0.2,0.7,0.3,0.6,0.4) and a random picture
%cue_set is a matrix for the cue pairs for the learning trials [1,2 ; 3,4 ; 5,6], therfore dimension is 1 cue_set(:,:,1).
%afterwards expand cue_set to desired length and randomize order.


%% prepare responses/scanner input codes
keyTrigger=KbName('5');
keyTrigger2=KbName('5%');
keyQuit=KbName('q');

%% prepare screen
screens = Screen('Screens'); %Define display screen
screenNumber = max(screens);
% % Set priority for script execution to realtime priority:
% priorityLevel=MaxPriority(window);
% Priority(priorityLevel);

PsychDefaultSetup(2);
Screen('Preference', 'VisualDebugLevel', 0); % before:3; Remove blue screen flash and minimize extraneous warnings.
Screen('Preference', 'SuppressAllWarnings', 1);
Screen('Preference', 'SkipSyncTests', 1);
oldResolution=Screen('Resolution', screenNumber);
screenRes=[0 0 oldResolution.width oldResolution.height];
%if not(simulation)
    HideCursor;
%end
[window, screenrect] = Screen('OpenWindow',screenNumber,[0 0 0]); %, screenRes
[screenXpixels, screenYpixels] = Screen('WindowSize', window);
[xCenter, yCenter] = RectCenter(screenrect);

%% correct timing
flipTime=Screen('GetFlipInterval',window);
for ff = fieldnames(dur)'
    dur.(ff{1}) = dur.(ff{1}) - flipTime;
end

%% prepare text screens
textsize = 30;
rectangle_width = 6;
cue_size = [000 000 400 400];
rect_size = cue_size + [0 0 100 100];
cue_left = CenterRectOnPointd(cue_size, xCenter - 0.5*xCenter, yCenter);
cue_right = CenterRectOnPointd(cue_size, xCenter + 0.5*xCenter, yCenter);
rect_left = CenterRectOnPointd(rect_size, xCenter - 0.5*xCenter, yCenter);
rect_right = CenterRectOnPointd(rect_size, xCenter + 0.5*xCenter, yCenter);
% Screen('TextSize', window, textsize);
% Screen('TextFont',window,'Arial');

%text
textsizelong = 20;
waitinstructions = ['Der Scanner wird jetzt fuer die Messung vorbereitet.' ...
    '\n\n Wenn sie anfaengt wird es laut werden.' ...
    '\n\n\n Am Ende der Messung kommt eine laengere Pause,' ...
    '\n\n waehrend der Sie ein + auf dem Bildschirm sehen (ca. 10 sec.).' ...
    '\n\n Bleiben Sie ruhig liegen bis die Messung aufhoert und es wieder leise wird.'];

testinstructions = ['Jetzt beginnt der zweite Teil der Untersuchung' ...
    '\n\n Ab sofort bekommen Sie kein Feedback zu Ihren Entscheidungen.'];

endinstructions = ['Das Test ist jetzt beendet.' ...
    '\n\n Es werden noch ein paar kurze Messungen durchgefuhrt.' ...
    '\n\n Bleiben Sie ruhig liegen bis die Messung aufhoert und es wieder leise wird.'];


choice_screen_left =  Screen('OpenOffscreenwindow',window,[0 0 0]); Screen('FrameRect', window, [255 255 255], cue_left , rectangle_width);
choice_screen_right =  Screen('OpenOffscreenwindow',window,[0 0 0]); Screen('FrameRect', window, [255 255 255], cue_right , rectangle_width);

wait_screen= Screen('OpenOffscreenwindow',window,[0 0 0]); Screen('TextSize',wait_screen,textsizelong); Screen('TextFont',wait_screen,'Arial');
miss_screen= Screen('OpenOffscreenwindow',window,[0 0 0]); Screen('TextSize',miss_screen,textsize); Screen('TextFont',miss_screen,'Arial');
cross_screen = Screen('OpenOffscreenwindow',window, [0 0 0]); Screen('TextSize',cross_screen,textsize); Screen('TextFont',cross_screen,'Arial');
test_screen = Screen('OpenOffscreenwindow',window, [0 0 0]); Screen('TextSize',test_screen,textsizelong); Screen('TextFont',test_screen,'Arial');
end_screen = Screen('OpenOffscreenwindow',window, [0 0 0]); Screen('TextSize',end_screen,textsizelong); Screen('TextFont',end_screen,'Arial');
%these are just for simulation needs
    milkshake_screen = Screen('MakeTexture', window, imread('stimuli/milkshake.jpg'));
    water_screen = Screen('MakeTexture', window, imread('stimuli/water.jpg'));
    rinse_screen = Screen('MakeTexture', window, imread('stimuli/rinse.jpg'));
    pump_screen = Screen('MakeTexture', window, imread('stimuli/pump.jpg'));
    happy_screen = Screen('MakeTexture', window, imread('stimuli/happy.jpg'));
    sad_screen = Screen('MakeTexture', window, imread('stimuli/sad.jpg'));
%Create screens
DrawFormattedText(wait_screen, waitinstructions, 'center', 'center', [255 255 255]);
DrawFormattedText(cross_screen, '+', 'center', 'center', [255 255 255]);
DrawFormattedText(miss_screen, 'Antwortzeit abgelaufen.', 'center', 'center', [255 255 255]);
DrawFormattedText(test_screen, testinstructions, 'center', 'center', [255 255 255]);
DrawFormattedText(end_screen, endinstructions, 'center', 'center', [255 255 255]);

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
trial.contingency   =nan(numstimpairs, 1, blocks);
trial.shake         =nan(numstimpairs, 1, blocks);

% outuput temporal variables
onsets.jitter       =nan(numstimpairs, 1, blocks);
onsets.choicescreen =nan(numstimpairs, 1, blocks);
onsets.choice       =nan(numstimpairs, 1, blocks);
onsets.resp         =nan(numstimpairs, 1, blocks); 
onsets.shakepump    =nan(numstimpairs, 1, blocks);
onsets.shake        =nan(numstimpairs, 1, blocks);
onsets.rinsepump    =nan(numstimpairs, 1, blocks);
onsets.rinse        =nan(numstimpairs, 1, blocks);
onsets.miss         =nan(numstimpairs, 1, blocks);
onsets.null         =nan(numstimpairs, 1, blocks);
trial.endtime       =nan(numstimpairs, 1, blocks);
%decided to deprecate option for user to change his mind
%allresp.choice     =nan(numstimpairs, 30, blocks); %log user changing his mind
%allresp.RT         =nan(numstimpairs, 30, blocks); %log user changing his mind

%% synchronize with the scanner
time0 = GetSecs;
Screen('CopyWindow', wait_screen, window);
Screen('Flip', window);
if simulation
    WaitSecs(1);
else
    pause on;
    %Wait for scanner trigger
    pause;
end
count_trigger = 0;
if do_fmri_flag == 1
    KbQueueCreate();
    KbQueueFlush();
    KbQueueStart();
    [b,c] = KbQueueCheck;
    while c(keyQuit) == 0
        [b,c] = KbQueueCheck;
        if c(keyTrigger) || c(keyTrigger2) > 0
            Screen('CopyWindow',cross_screen, window);
            Screen('Flip', window);
            count_trigger = count_trigger + 1;
            subj.trigger.all(count_trigger,1) = GetSecs;
            if simulation
                subj.trigger.fin = GetSecs;
                break
            end
            if count_trigger > dummy_volumes
                subj.trigger.fin = GetSecs;
                break
            end
        end
    end
    KbQueueRelease();
end

%% start experiment
clock = GetSecs; % get time zero

for iBlock=1:blocks
    % jitter variable. in order to skip null events without comprimising the
    % normal distrubtion, using unique variable jcount instead of iTrial 
    jcount = 1;
    %%show test instructions between blocks
    if iBlock == 2        
       Screen('CopyWindow',test_screen, window);
       Screen('Flip', window);
       WaitSecs(5)
    end
    
    for iTrial=1:numstimpairs
        trialstart  = GetSecs; %used for choice task, because total trial time should be dur.max seconds
        %fprintf('iTrial:%d, block:%d\n', iTrial, iBlock); %used for debugging
        %%Break loop on end of Test Block
        %test trial block cue_set(:,:,2) is shorter than learning trial cue_set(:,:,1), but the vectors need to match 
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
            onset_resp = GetSecs;
            trial.cue(iTrial,:, iBlock) = cue_set(iTrial,:,iBlock);
            %WaitSecs(dur.resp);

            %% get the response
            % while loop to try to get response until "dur.resp" seconds elapsed.
            while (GetSecs - onset_resp) <= dur.resp
                [x,y,buttons] = GetMouse;
                if buttons(3) == 1 %cue_set(iTrial,2,iBlock) is right side cue
                    trial.RT(iTrial, 1, iBlock) = GetSecs - onset_resp;
                    trial.choice(iTrial, 1, iBlock) = cue_set(iTrial,2,iBlock); 
                    onsets.choice(iTrial, 1, iBlock) = GetSecs - clock;
                    Screen('FrameRect', window, [0 200 0], rect_right, rectangle_width);
                    %fprintf('right choice: %d %s\n', trial.choice(iTrial,iBlock), stimuli.cues(trial.choice(iTrial,iBlock)).cuename{1});
                    break;
                elseif buttons(1) == 1 %cue_set(iTrial,1,iBlock) is left side cue
                    trial.RT(iTrial, 1, iBlock) = GetSecs - onset_resp;
                    trial.choice(iTrial, 1, iBlock) = cue_set(iTrial,1,iBlock);
                    onsets.choice(iTrial, 1, iBlock) = GetSecs - clock;
                    Screen('FrameRect', window, [0 200 0], rect_left, rectangle_width);
                    %fprintf('left choice: %d %s\n', trial.choice(iTrial,iBlock), stimuli.cues(trial.choice(iTrial,iBlock)).cuename{1});
                    break;
                else
                    trial.choice(iTrial, 1, iBlock) = -9; % if user didn't choose
                end
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
                trial.contingency(iTrial, 1, iBlock) = stimuli.cues(trial.choice(iTrial, 1, iBlock)).contingency(1); 
                %could add && (iBlock == 1) but didn't for the benefit of the %fprintf in debugging
                if (trial.contingency(iTrial, 1, iBlock)) > rand(1)
                    trial.shake(iTrial, 1, iBlock) = 1;
                    shake = '1run'; % pleasant shake
                    %fprintf('won! with %s with contigency of: %f\n',stimuli.cues(trial.choice(iTrial, 1, iBlock)).cuename{1} ,trial.contingency(iTrial, 1, iBlock));
                    if simulation && (iBlock==1) && not(pilot_proband)
                        Screen('DrawTextures', window, milkshake_screen, [], [xCenter-100 yCenter-100 xCenter+100 yCenter+100]);
                        Screen('Flip',window);
                        WaitSecs(0.4);
                        Screen('CopyWindow',cross_screen, window);
                        Screen('Flip', window);
                    end
                else 
                    trial.shake(iTrial, 1, iBlock) = 0;
                    shake = '2run'; % neutral shake
                    %fprintf('lost... with %s with contigency of: %f\n',stimuli.cues(trial.choice(iTrial, 1, iBlock)).cuename{1} ,trial.contingency(iTrial, 1, iBlock));
                    if simulation && (iBlock==1) && not(pilot_proband)
                        Screen('DrawTextures', window, water_screen, [], [xCenter-100 yCenter-100 xCenter+100 yCenter+100]);
                        Screen('Flip',window);
                        WaitSecs(0.4);
                        Screen('CopyWindow',cross_screen, window);
                        Screen('Flip', window);
                    end
                end

                %% provide milkshake/neutral solution, only during learning phase (iBlock==1)
                if (iBlock == 1)
                    if simulation
                       s1 = 'simulation.txt'; 
                    end
                    %fprintf(s1, shake);
                    onsets.shakepump(iTrial, 1, iBlock) = GetSecs - clock;
                    WaitSecs(dur.choice);
                    Screen('CopyWindow',cross_screen, window);
                    Screen('Flip', window);
                    if pilot_proband == 1
                        Screen('DrawTextures', window, pump_screen, [], [xCenter-100 yCenter-300 xCenter+100 yCenter-150]);
                        Screen('Flip', window, [], 1);
                    end
                    WaitSecs(dur.pump - dur.choice) % wait for milkshake arrival
                    onsets.shake(iTrial, 1, iBlock) = GetSecs - clock;
                        if pilot_proband == 1 
                            if strcmp(shake,'1run')
                                result_shake = milkshake_screen;
                            else
                                result_shake = water_screen;
                            end
                            Screen('DrawTextures', window, result_shake, [], [xCenter-100 yCenter-140 xCenter+100 yCenter+10]);
                            Screen('Flip', window);
                        end
                        if pilot_proband == 2 
                            if strcmp(shake,'1run')
                                result_shake = happy_screen;
                            else
                                result_shake = sad_screen;
                            end
                            Screen('DrawTextures', window, result_shake, [], [xCenter-200 yCenter-200 xCenter+200 yCenter+200]);
                            Screen('Flip', window);
                        end
                    WaitSecs(dur.shake); % wait for milkshake delivery        
                        if pilot_proband == 2
                            Screen('CopyWindow',cross_screen, window);
                            Screen('Flip', window, [], 1);
                        end   
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
    end
%    countjitt = countjitt+length(cues);
end

%% Write your data file and clean up your mess
total_runtime = (GetSecs-clock)/(60);
fprintf('end test');

Screen('CopyWindow',end_screen, window);
Screen('Flip',window);
KbPressWait;

Screen('CloseAll');
clear;
sca;