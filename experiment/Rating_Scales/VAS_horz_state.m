%%===================VAS horizontal===================
%customized visual analogue scales (0-100)
%

%Coded by: Nils Kroemer modified from mood_VAS (coded by Ying Lee) and BDM task (coded by Jean Liu)

%Update coded with: Matlab R2014a using Psychtoolbox 3.0.11

%========================================================

%% Preparation
function [output] = VAS_horz_state(subjectID, studyID, sessionID, statelist, window, screen_config, preset ,state_ind, state_out_ind)
    %{
    if preset ~= 1
        clc; clear all; close all;

        % Setup
        screen_config.feedback_delay = 1.5; % specifies the duration that the confirmed rating will be displayed on the screen

        %Screen('Preference', 'SkipSyncTests', 1);
        % Input subject ID
        studyID=input('StudyID: ','s');
        subjectID=input('SubjectID: ','s');
        sessionID=input('SessionID: ','s');

        % Preparation: Set paths
        filepath=pwd;
        questionfile=[pwd,'/questionlist.txt'];
        fid=fopen(questionfile);
        questionlist = textscan(fid,'%s','Delimiter','\n');

        fclose(fid);

        % Preparation: General Psychtoolbox
        screens = Screen('Screens'); %Define display screen
        screen_config.screenNumber = max(screens);
        oldResolution=Screen('Resolution', screenNumber);
        screenRes=[0 0 oldResolution.width oldResolution.height];
        Screen('Preference', 'VisualDebugLevel', 3); % Remove blue screen flash and minimize extraneous warnings.
        Screen('Preference', 'SuppressAllWarnings', 1);
        Screen('Preference', 'SkipSyncTests', 1);
        AssertOpenGL;
        HideCursor; %Hide cursor

        %% Instructions for mood task
        [window,screenrect] = Screen('OpenWindow',screenNumber,[0 0 0],[0 0 800 600]);
        %[window,screenrect] = Screen('OpenWindow',screenNumber,[0 0 0], screenRes);
        text = ['INSTRUCTIONS:' ...
            '\n\n You will be asked a series of questions.'...
            '\n\n\n\n For every question,' ... 
            '\n\n please indicate your rating by moving the mouse to indicate your rating on the scale.' ...
            '\n\n\n\n Should you have any questions, please approach the experimenter.' ...
            '\n\n\n\nClick once to continue.'];
        Screen('TextSize',window,20);
        Screen('TextFont',window,'Arial');
        [positionx,positiony,bbox] = DrawFormattedText(window, text, 'center', 'center', [250 250 250],80);
        Screen('Flip',window);
        GetClicks(screenNumber);
        screen_config.Screen_width = screenrect(3)-screenrect(1);
        screen_config.Screen_height = screenrect(4)-screenrect(2);

        output.rating(i) = NaN;
        trial_i = 1;
    end;
    %}

    %% Start experiment:

    %--- Start trial---
    for i=1:length(statelist{1,1}); %number of questions

        trial.question = statelist{1,1}{i};
        trial.runstart = GetSecs; %Time run starts

        %--- Prepare off-screen windows---

        %rating window (4s)
        rating_scr = Screen('OpenOffscreenwindow',window,[0 0 0]);
        text_freerating = [trial.question]; %free rating
        if strcmp(trial.question, 'satt');
        Screen('TextSize',rating_scr,16);
        Screen('TextFont',rating_scr,'Arial');
        anchor_1 = ('Überhaupt nicht \n satt' );
        %anchor_4 = ['Neutral'];
        anchor_7 = ['Ich war noch \n nie so satt'];
        else
        Screen('TextSize',rating_scr,16);
        Screen('TextFont',rating_scr,'Arial');
        anchor_1 = ['Überhaupt nicht \n' trial.question];
        %anchor_4 = ['Neutral'];
        anchor_7 = ['Ich war noch nie so \n' trial.question];
        end
        text_question = ['Wie ' trial.question ' sind Sie gerade?'];

        Screen_width = screen_config.Screen_width;
        Screen_height = screen_config.Screen_height;
        %rescale screen_height to scale_height
        Scale_width = round(Screen_width * .75);
        Scale_offset = round((Screen_height - (Screen_height * .95)) * .75);

        DrawFormattedText(rating_scr, text_question, 'center', (Scale_offset+Screen_height/2 - 100), [205 201 201],80);
        DrawFormattedText(rating_scr, [anchor_1 ], (Screen_width/2-Scale_width/2 - 65), (Scale_offset+Screen_height/2 + 30), [205 201 201],80);
        %DrawFormattedText(rating_scr, [anchor_4], 'center', (Scale_offset+Screen_height/2 + 30), [205 201 201],80);
        DrawFormattedText(rating_scr, [anchor_7 ], (Screen_width/2+Scale_width/2 - 75), (Scale_offset+Screen_height/2 + 30), [205 201 201],80);

        % horizontal scale element
        Screen('DrawLine',rating_scr,[250 250 250],(Screen_width/2-Scale_width/2), (Scale_offset+Screen_height/2), (Screen_width/2+Scale_width/2), (Scale_offset+Screen_height/2),3)


        % vertical scale elements
        Screen('DrawLine',rating_scr,[250 250 250],(Screen_width/2-Scale_width/2), (Scale_offset+Screen_height/2 - 20), (Screen_width/2-Scale_width/2), (Scale_offset+Screen_height/2 + 20),3)
        %Screen('DrawLine',rating_scr,[250 250 250],(Screen_width/2), (Scale_offset+Screen_height/2 - 15), (Screen_width/2), (Scale_offset+Screen_height/2 + 15),3)
        Screen('DrawLine',rating_scr,[250 250 250],(Screen_width/2+Scale_width/2), (Scale_offset+Screen_height/2 - 20), (Screen_width/2+Scale_width/2), (Scale_offset+Screen_height/2 + 20),3)

        %--- Start display for trial---

        %rating window
        Screen('CopyWindow',rating_scr,window);
        Screen('Flip',window);


        %----Mouse response----

        %Move cursor to mean position
        X = round(Screen_width/2);
        Y = round(Scale_offset + Screen_height/2); %Fix y coordinate
        Slider_x_pos = X;
        SetMouse(X,Y);


        %Put slider on the screen
        Screen('CopyWindow',rating_scr,window)

        Screen('DrawLine',window,[250 0 0],Slider_x_pos, (Scale_offset + Screen_height / 2 - 10), Slider_x_pos, (Scale_offset + Screen_height / 2 + 10),5)

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
                    output.state(state_ind,state_out_ind) = ((Slider_x_pos - (Screen_width/2-Scale_width/2))/ Scale_width)*100; %rescaling of scale_width independent of screen resolution [0-100]
                    state_out_ind = state_out_ind + 1;

                elseif (mouseX ~= X) %Update screen if participant has scrolled up or down
                    Screen('CopyWindow',rating_scr,window);
                    Slider_x_pos = (mouseX);

                    %restrict range of slider to defined scale
                    if Slider_x_pos < (Screen_width/2 - Scale_width/2)
                        Slider_x_pos = (Screen_width/2 - Scale_width/2);
                    elseif Slider_x_pos > (Screen_width/2 + Scale_width/2)
                        Slider_x_pos = (Screen_width/2 + Scale_width/2);
                    end

                    Screen('DrawLine',window,[250 0 0],Slider_x_pos, (Scale_offset + Screen_height / 2 - 10), Slider_x_pos, (Scale_offset + Screen_height / 2 + 10),5)

                    Screen('Flip',window);
                end

                nextTime = nextTime+sampleTime;
            end
        end

        WaitSecs(screen_config.feedback_delay); %Show screen for 1.5s post-mouseclick

    end

    if preset ~= 1
        Screen('CloseAll');
    end
    
    save_filename=[studyID,'_',subjectID,'_',sessionID,'_VAS_',datestr(now,'yymmdd_HHMM'),'.mat'];
    save(save_filename, 'output','studyID','subjectID','sessionID');
    
end
