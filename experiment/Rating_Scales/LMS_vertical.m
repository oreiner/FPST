%%===================LMS vertical===================
%(general) labeled magnitude scale (cf. Green, 1993)
%

%Coded by: Nils Kroemer modified from mood_VAS (coded by Ying Lee) and BDM task (coded by Jean Liu)

%Update coded with: Matlab R2014a using Psychtoolbox 3.0.11

%========================================================
function [output] = LMS_vertical(subjectID, studyID, sessionID, sensationslist, window, screen_config, preset, out_ind, trial_i)
    %% Preparation
    %{
    if preset == 0
        clc; clear all; close all;

        % Setup

        screen_config.feedback_delay = 1.5; % specifies the duration that the confirmed rating will be display on the screen

        %Screen('Preference', 'SkipSyncTests', 1);
        % Input subject ID
        studyID=input('StudyID: ','s');
        subjectID=input('SubjectID: ','s');
        sessionID=input('SessionID: ','s');

        % Preparation: Set paths
        filepath=pwd;
        sensationsfile=[pwd,'/sensationslist.txt'];
        fid=fopen(sensationsfile);
        sensationslist = textscan(fid,'%s','Delimiter','\n');

        fclose(fid);

        % Preparation: General Psychtoolbox
        screens = Screen('Screens'); %Define display screen
        screen_config.screenNumber = max(screens);
        oldResolution=Screen('Resolution', screen_config.screenNumber);
        screenRes=[0 0 oldResolution.width oldResolution.height];
        Screen('Preference', 'VisualDebugLevel', 3); % Remove blue screen flash and minimize extraneous warnings.
        Screen('Preference', 'SuppressAllWarnings', 1);
        Screen('Preference', 'SkipSyncTests', 1);
        AssertOpenGL;
        HideCursor; %Hide cursor

        %% Instructions for mood task
        [window,screenrect] = Screen('OpenWindow',screen_config.screenNumber,[0 0 0],[0 0 1024 768]);
        %[window,screenrect] = Screen('OpenWindow',screen_config.screenNumber,[0 0 0], screenRes);
        text = ['INSTRUCTIONS:' ...
            '\n\n You will be asked a series of questions.'...
            '\n\n\n\n For every question,' ... 
            '\n\n please indicate your rating by using the mouse to indicate on the bar.' ...
            '\n\n\n\n Should you have any questions, please approach the experimenter.' ...
            '\n\n\n\nClick once to continue.'];
        Screen('TextSize',window,20);
        Screen('TextFont',window,'Arial');
        [positionx,positiony,bbox] = DrawFormattedText(window, text, 'center', 'center', [250 250 250],80);
        Screen('Flip',window);
        GetClicks(screen_config.screenNumber);
        Screen_width = screenrect(3)-screenrect(1);
        Screen_height = screenrect(4)-screenrect(2);

        output.rating(i) = NaN;
        trial_i = 1;
        out_ind = 1;
    end;
    %}
    %% Start experiment:

    %--- Start trial---
    for i=1:length(sensationslist{1,1}); %number of questions within the loop

        trial.question = sensationslist{1,1}{i};
        trial.runstart = GetSecs; %Time run starts

        %--- Prepare off-screen windows---

        %rating window (4s)
        rating_scr = Screen('OpenOffscreenwindow',window,[0 0 0]);
        text_freerating = [trial.question]; %free rating

        Screen('TextSize',rating_scr,16);
        Screen('TextFont',rating_scr,'Arial');
        anchor_1 = ['stärkste Wahrnehmung, die vorstellbar ist'];
        anchor_2 = ['sehr stark'];
        anchor_3 = ['stark'];
        anchor_4 = ['moderat'];
        anchor_5 = ['schwach'];
        anchor_6 = ['kaum wahrnehmbar'];
        anchor_7 = ['keine Wahrnehmung'];
        instruction = ['Die Bewertung soll in Abhängigkeit \nder gesamten Spannweite Ihrer bisher \nerlebten Sinneserfahrungen stattfinden'];

        Screen_width = screen_config.Screen_width;
        Screen_height = screen_config.Screen_height;
        %rescale screen_height to scale_height
        Scale_height = round(Screen_height * .75);
        Scale_offset = round((Screen_height - Scale_height) * .75);

        DrawFormattedText(rating_scr, anchor_1, (Screen_width/2+20), (Scale_offset - 10) + Scale_height * 0.000, [205 201 201],80);
        %comment in if you want to use different sensations in a row
        DrawFormattedText(rating_scr, (text_freerating), (Screen_width/2+20), (Scale_offset - 10) + 20, [205 201 201],80);
        DrawFormattedText(rating_scr, anchor_2, (Screen_width/2+20), (Scale_offset - 10) + Scale_height * 0.467, [205 201 201],80);
        DrawFormattedText(rating_scr, anchor_3, (Screen_width/2+20), (Scale_offset - 10) + Scale_height * 0.646, [205 201 201],80);
        DrawFormattedText(rating_scr, anchor_4, (Screen_width/2+20), (Scale_offset - 10) + Scale_height * 0.828, [205 201 201],80);
        DrawFormattedText(rating_scr, anchor_5, (Screen_width/2+20), (Scale_offset - 10) + Scale_height * 0.939, [205 201 201],80);
        DrawFormattedText(rating_scr, anchor_6, (Screen_width/2+20), (Scale_offset - 10) + Scale_height * 0.986, [205 201 201],80);
        DrawFormattedText(rating_scr, anchor_7, (Screen_width/2-200), (Scale_offset - 10) + Scale_height * 1.000, [205 201 201],80);
        DrawFormattedText(rating_scr, instruction, (Screen_width/10), 'center', [220 0 0],80,[],[],2);

        % horizontal scale elements
        Screen('DrawLine',rating_scr,[250 250 250],(Screen_width / 2 - 15), Scale_offset + Scale_height * 0.000, (Screen_width / 2 + 15), Scale_offset + Scale_height * 0.000,3)
        Screen('DrawLine',rating_scr,[250 250 250],(Screen_width / 2 - 15), Scale_offset + Scale_height * 0.467, (Screen_width / 2 + 15), Scale_offset + Scale_height * 0.467,3)
        Screen('DrawLine',rating_scr,[250 250 250],(Screen_width / 2 - 15), Scale_offset + Scale_height * 0.646, (Screen_width / 2 + 15), Scale_offset + Scale_height * 0.646,3)
        Screen('DrawLine',rating_scr,[250 250 250],(Screen_width / 2 - 15), Scale_offset + Scale_height * 0.828, (Screen_width / 2 + 15), Scale_offset + Scale_height * 0.828,3)
        Screen('DrawLine',rating_scr,[250 250 250],(Screen_width / 2 - 15), Scale_offset + Scale_height * 0.939, (Screen_width / 2 + 15), Scale_offset + Scale_height * 0.939,3)
        Screen('DrawLine',rating_scr,[250 250 250],(Screen_width / 2 - 15), Scale_offset + Scale_height * 0.986, (Screen_width / 2 + 15), Scale_offset + Scale_height * 0.986,3)
        Screen('DrawLine',rating_scr,[250 250 250],(Screen_width / 2 - 15), Scale_offset + Scale_height * 1.000, (Screen_width / 2 + 15), Scale_offset + Scale_height * 1.000,3)

        % vertical scale element
        Screen('DrawLine',rating_scr,[250 250 250],(Screen_width / 2), Scale_offset, (Screen_width / 2), Scale_offset + Scale_height,3)

        %--- Start display for trial---

        %rating window
        Screen('CopyWindow',rating_scr,window);
        Screen('Flip',window);


        %----Mouse response----

        %Move cursor to anchor_7 (lowest)
        X = round(Screen_width/2);
        Y = round(Scale_offset + Scale_height); %Fix y coordinate
        Slider_y_pos = Y;
        SetMouse(X,Y);


        %Put slider on the screen
        Screen('CopyWindow',rating_scr,window)

        Screen('DrawLine',window,[250 0 0],(Screen_width / 2 - 10), Slider_y_pos, (Screen_width / 2 + 10), Slider_y_pos,5)

        Screen('Flip',window);

        %Loop and track mouse such that rating slider moves according to mouse position (edited from MouseTraceDemo)
        sampleTime = 0.01;
        startTime = GetSecs;
        nextTime = startTime+sampleTime;

        [mouseX, mouseY, mousebuttons] = GetMouse(screen_config.screenNumber); %Find out coordinates of current mouse position

        while mousebuttons(1)~=1

            if (GetSecs > nextTime) %Sample every 0.01 seconds
                [mouseX, mouseY, mousebuttons] = GetMouse(screen_config.screenNumber); %Find out coordinates of current mouse position

                if mousebuttons(1)==1 %Terminate and record rating on left mouseclick
                    output.rating(trial_i,out_ind) = 100-((Slider_y_pos - Scale_offset)/Scale_height)*100; %rescaling of scale_height independent of screen resolution [0-100]
                    output.rating_label{trial_i,out_ind} = text_freerating;
                    out_ind = out_ind + 1;

                elseif (mouseY ~= Y) %Update screen if participant has scrolled up or down
                    Screen('CopyWindow',rating_scr,window);
                    Slider_y_pos = (mouseY);

                    %restrict range of slider to defined scale
                    if Slider_y_pos < Scale_offset
                        Slider_y_pos = Scale_offset;
                    elseif Slider_y_pos > (Scale_offset + Scale_height)
                        Slider_y_pos = (Scale_offset + Scale_height);
                    end

                    Screen('DrawLine',window,[250 0 0],(Screen_width / 2 - 10), Slider_y_pos, (Screen_width / 2 + 10), Slider_y_pos,5)

                    Screen('Flip',window);
                end

                nextTime = nextTime+sampleTime;
            end
        end

        WaitSecs(screen_config.feedback_delay); %Show screen for 1.5s post-mouseclick

    end

    if preset ~= 1;
        Screen('CloseAll');

    save_filename=[studyID,'_',subjectID,'_',sessionID,sess_type,'_temp_pre','.mat'];
    save(fullfile(backup_dir,save_filename),'output','studyID','subjectID','sessionID');

    end
    end