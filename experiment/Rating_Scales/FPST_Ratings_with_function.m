%%===================OEAPET and HighFat Scales===================
%Script will loop through scales as customized by text input files
%Modified by: Omer Reiner
%Coded by: Nils Kroemer & A. DiFeliceantonio

%Coded with: Matlab R2017b using Psychtoolbox 3.0.11

%================================
%% Set UP  
function [output] = FPST_Ratings(subjectID, studyID, sessionID, sess_type, screen_config, , window, simulation)
    fprintf('Starting new ratings session....\n\n\n')
    % Setup
    feedback_delay = 1; %specifies the duration that the confirmed rating will be displayed on the screen
    %Get subject information
    if not(nargin)
        prompt={'Subject ID'};
        dlg_title='FPST';
        numlines=1;
        answer=inputdlg(prompt,dlg_title,numlines);
        studyID='FPST';
        subjectID=char(answer(1));
        lstsz = [120 80];
        strprots = {'PreIntervention', 'PostIntervention'};
        [orders,t]= listdlg('PromptString','Enter rating type:','SelectionMode','single','Listsize',lstsz ,'ListString',strprots);
        sessionID = char(strprots(orders));
        strprot = {'gLMS_Training', 'Milkshake_Rating', 'Internal_State_1', 'Internal_State_2'};
        [order,v]= listdlg('PromptString','Enter rating type:','SelectionMode','single','Listsize',lstsz ,'ListString',strprot);
        sess_type = char(strprot(order));
    end

    %Session type and load questions
    if any(strcmp(sess_type, 'gLMS_Training'))
        num_trials=12;
        output.version = 'v1.0.0';
        filepath=pwd;
        questionfile=which('questionlist_glms.txt');
        sensationsfile=which('sensationslist_glms.txt');
        statefile=which('statelist.txt');
    elseif any(strcmp(sess_type, 'Milkshake_Rating')) 
        if any(strcmp(sessionID, 'PreIntervention'))
            num_trials=4;
            filepath=pwd;
        elseif any(strcmp(sessionID, 'PostIntervention'))
            num_trials=1;
            filepath=[pwd '\Rating_Scales'] ; % run from main script
        end
        output.version = 'v1.0.0';
        
        questionfile=which('questionlist.txt');
        sensationsfile=which('sensationslist.txt');
        statefile=which('statelist.txt');
    elseif any(strcmp(sess_type, 'Internal_State_1')) || any(strcmp(sess_type, 'Internal_State_2'))
        num_trials=3;
        output.version = 'v1.0.0';
        filepath=pwd;
        questionfile=which('questionlist.txt');
        sensationsfile=which('sensationslist.txt');
        statefile=which('statelist.txt');
    end

    fid_q=fopen(questionfile);
    fid_s=fopen(sensationsfile);
    fid_st=fopen(statefile);
    questionlist = textscan(fid_q,'%s','Delimiter','\n');
    sensationslist = textscan(fid_s,'%s','Delimiter','\n');
    statelist = textscan(fid_st,'%s','Delimiter','\n');
    fclose(fid_q);
    fclose(fid_s);
    fclose(fid_st);


    %% Prep psych toolbox and text
    %don't open screen if already opened from FPST.m
    if not(nargin)
        [window, screen_config] = psychtoolbox_config(simulation);
    end
    
    nominalFrameRate=Screen('NominalFrameRate', window);
    pressSecs=[sort(repmat(1:10,1,nominalFrameRate), 'descend') 0];

    %Create offscreen windows
    ratings_screen = Screen('OpenOffscreenwindow',window, screen_config.black);
    Screen('TextSize',ratings_screen,18);
    Screen('TextFont',ratings_screen,'Arial');
    click_screen = Screen('OpenOffscreenwindow',window, screen_config.black);
    Screen('TextSize',click_screen,18);
    Screen('TextFont',click_screen,'Arial');

    %Text
    ratescreen = ('Bitte probieren Sie jeden Stimulus und bewerten Sie diesen auf den folgenden Skalen');
    waitscreen= ('Bitte warten');
    clickscreen=('Bitte probieren Sie den nächsten Geschmack. Klicken Sie die Maustaste um fortzufahren');

    %Create screens

    DrawFormattedText(ratings_screen, ratescreen, 'center', 'center', screen_config.white);
    DrawFormattedText(click_screen, clickscreen, 'center', 'center', screen_config.white);

    %timing

    format shortg
    pause on

    %% Ratings

    screen_config.Screen_width = screenrect(3)-screenrect(1);
    screen_config.Screen_height = screenrect(4)-screenrect(2);
    screen_config.Scale_width = 0;

    %initializes common triggering of scripts and trial-based timing
    preset = 1;
    if any(strcmp(sess_type, 'gLMS_Training'))
         %runs and initializes state ratings
        state_ind = 1;
        state_out_ind = 1;
        f_VAS_horz_state(statelist, window, screen_config, preset);
        output.time = datestr(now);
        onset_flavor_rating = GetSecs;
        %Instructions for ratings
        Screen('CopyWindow',ratings_screen,window);
        Screen('Flip',window);
        GetClicks(screenNumber);
        Screen_width = screenrect(3)-screenrect(1);
        Screen_height = screenrect(4)-screenrect(2);
        Scale_width = 0;
        if trial_i < num_trials
            for trial_i=1:num_trials
                out_ind = 1;
                LMS_vertical; %script to run labeled magnitude scales
                LHS_vertical;
                save_filename=[studyID,'_',subjectID,'_',sessionID, sess_type,'_temp_pre','.mat'];
                save(save_filename, 'output','studyID','subjectID','sessionID');
                Screen('CopyWindow',click_screen,window);
                Screen('Flip',window);
                GetClicks(screenNumber)
            end
        end
    elseif any(strcmp(sess_type, 'Internal_State_1')) || any(strcmp(sess_type, 'Internal_State_2'))
         %runs and initializes state ratings
        state_ind = 1;
        state_out_ind = 1;
        f_VAS_horz_state(statelist, window, screen_config, preset);
        output.time = datestr(now);
        onset_flavor_rating = GetSecs;

    else
        %runs milkshake or fatsensitivity ratings
        %runs and initializes state ratings
        state_ind = 1;
        state_out_ind = 1;
        f_VAS_horz_state(statelist, window, screen_config, preset);
        output.time = datestr(now);
        onset_flavor_rating = GetSecs;
        if not(any(strcmp(sessionID, 'PostIntervention')))
            %Instructions for ratings
            Screen('CopyWindow',ratings_screen,window);
            Screen('Flip',window);
            GetClicks(screenNumber);
        end
        screen_config.Screen_width = screenrect(3)-screenrect(1);
        screen_config.Screen_height = screenrect(4)-screenrect(2);
        Scale_width = 0;
        for trial_i=1:num_trials
            out_ind = 1;
            
            backup_dir = fullfile(filepath, 'Backup', num2str(subjectID));
            if not(exist(backup_dir,'dir'))
                mkdir(backup_dir)
            end
            
            LMS_vertical; %script to run labeled magnitude scales
            LHS_vertical; %script to run labaled hedonic scales
            VAS_horz; %script to run visual analogue scales
            
            if trial_i < num_trials
                for i=1:length(pressSecs)
                    number=num2str(pressSecs(i));
                    Screen('TextFont', window, 'Arial');
                    Screen('TextSize', window, 18);
                    DrawFormattedText(window, number, 'center', 'center', white);
                    DrawFormattedText(window, waitscreen, 'center', screen_config.screenYpixels*.75);
                    Screen('Flip', window);
                end
                Screen('CopyWindow',click_screen,window);
                Screen('Flip',window);
                GetClicks(screenNumber);
            end
        end
    end
    
    data_dir = fullfile(filepath, 'data', num2str(subjectID));
    if not(exist(data_dir,'dir'))
        mkdir(data_dir)
    end
    save_filename=[studyID,'_',subjectID,'_',sessionID,sess_type,'_ratings', '.mat'];
    save(fullfile(data_dir,save_filename),'output','studyID','subjectID','sessionID');

    if any(strcmp(sess_type, 'Internal_State_1')) || any(strcmp(sess_type, 'Internal_State_2'))
        hungry=output.state(:,1);
        full=output.state(:,2);
        thirsty=output.state(:,3);
        statetable=table(hungry, thirsty, full);
        statefilename=[studyID,'_',subjectID,'_',sessionID,sess_type,'_internalratings', '.csv'];
        writetable(statetable,  statefilename);
    elseif any(strcmp(sess_type, 'gLMS_Training'))
        disp('No file creation for GLMS')
    else
        sweet=output.rating(:,1);
        liking=output.rating(:,2);
        fatty=output.rating(:,3);
        creamy=output.rating(:,4);
        oily=output.rating(:,5);
        wanting=output.rating(:,6);
        hungry=output.state(:,1);
        full=output.state(:,2);
        thirsty=output.state(:,3);
        ratingtable=table(sweet, liking, fatty, creamy, oily, wanting);
        statetable=table(hungry, thirsty, full);
        ratingfilename=[studyID,'_',subjectID,'_',sessionID,sess_type,'_ratings', '.csv'];
        statefilename=[studyID,'_',subjectID,'_',sessionID,sess_type,'_internalratings', '.csv'];
        writetable(ratingtable,  ratingfilename);
        writetable(statetable,  statefilename);
    end

    %saves a backup file in a different folder using the date as unique
    %identifier including all information to avoid potential loss of data
    backup_dir = fullfile(filepath, 'Backup', num2str(subjectID));
    if not(exist(backup_dir,'dir'))
        mkdir(backup_dir)
    end
    save_filename=[studyID,'_',subjectID,'_',sessionID,datestr(now,'_yymmdd_HHMM'),'_',sess_type,'.mat'];
    save(fullfile(backup_dir, save_filename));
    
    
    if nargin
        endinstructions = ['Die Untersuchung ist jetzt beendet.' ...
    '\n\n Es werden noch ein paar kurze Messungen durchgefuhrt.' ...
    '\n\n Bleiben Sie ruhig liegen bis die Messung aufhoert und es wieder leise wird.'];

        end_screen = Screen('OpenOffscreenwindow',window, [0 0 0]); Screen('TextSize',end_screen,20); Screen('TextFont',end_screen,'Arial');
        DrawFormattedText(end_screen, endinstructions, 'center', 'center', [255 255 255]);
        
        %wait for non 5 keypress. click when all scans ended
        fprintf('dear experimenter, please click any button (other than 5) to end the test!\n');
        Screen('CopyWindow',end_screen,window);
        Screen('Flip',window);
        WaitNon5;
    end
    
    Screen('CloseAll');
end