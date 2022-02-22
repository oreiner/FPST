

screens = Screen('Screens'); %Define display screen
screenNumber = max(screens);
PsychDefaultSetup(2);
Screen('Preference', 'VisualDebugLevel', 0); % before:3; Remove blue screen flash and minimize extraneous warnings.
Screen('Preference', 'SuppressAllWarnings', 1);
Screen('Preference', 'SkipSyncTests', 1);
Screen('Preference', 'Verbosity', 0);
oldResolution=Screen('Resolution', screenNumber);
screenRes=[0 0 oldResolution.width oldResolution.height];
[window, screenrect] = Screen('OpenWindow',screenNumber,[0 0 0]); %, screenRes
[screenXpixels, screenYpixels] = Screen('WindowSize', window);
[xCenter, yCenter] = RectCenter(screenrect);

textsize = 40;
cross_screen = Screen('OpenOffscreenwindow',window, [0 0 0]); Screen('TextSize',cross_screen,textsize); Screen('TextFont',cross_screen,'Arial');
click_screen = Screen('OpenOffscreenwindow',window, [0 0 0]); Screen('TextSize',click_screen,textsize); Screen('TextFont',click_screen,'Arial');
%pump_screen = Screen('MakeTexture', window, imread('stimuli/pump.jpg'));
milkshake_screen = Screen('MakeTexture', window, imread('stimuli/milkshake.jpg'));
 
 DrawFormattedText(cross_screen, '+', 'center', 'center', [255 255 255]);
 DrawFormattedText(click_screen, 'click', 'center', 'center', [255 255 255]);
 resp = zeros(5,1); 
 for i=1:5
     clicked = 0;
     time0 = GetSecs;
 Screen('CopyWindow',click_screen, window);
Screen('Flip', window);
 while not(clicked)
                [x,y,buttons] = GetMouse;

                if buttons(3) == 1 %cue_set(iTrial,2,iBlock) is right side cue
                        clicked = 1;
                        resp(i) = GetSecs - time0;
                elseif buttons(1) == 1 %cue_set(iTrial,1,iBlock) is left side cue
clicked = 1;
                        resp(i) = GetSecs - time0;
                end
                pause(0.01); %slow down the loop to avoid the computer freezing
            end

Screen('CopyWindow',cross_screen, window);
Screen('Flip', window);

WaitSecs(3);
 end

 
 
 Screen('CloseAll');
