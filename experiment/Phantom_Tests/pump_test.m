if exist('s1') == 1 % if a previous script exited with an error, you want to delete the serial communications to avoid an error in this script
        fclose(s1);
end
s1=serial('com8','baudrate',19200,'databits',8,'terminator',13);
fopen(s1);


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
%pump_screen = Screen('MakeTexture', window, imread('stimuli/pump.jpg'));
milkshake_screen = Screen('MakeTexture', window, imread('stimuli/milkshake.jpg'));
 
 DrawFormattedText(cross_screen, '+', 'center', 'center', [255 255 255]);
  
Screen('CopyWindow',cross_screen, window);
Screen('Flip', window, [], 1);

nominalFrameRate=Screen('NominalFrameRate', window)
pressSecs=[sort(repmat(0:0.1:10,1,nominalFrameRate*0.1), 'ascend') 0];

WaitSecs(3);
timing_15 = zeros(2,10);
for j = 1:10
 fprintf(s1, '0run'); 
 %Screen('DrawTextures', window, pump_screen, [], [xCenter-400 yCenter-100 xCenter-200 yCenter+100]);
 %Screen('Flip',window, [], 1);
 time0 = GetSecs;
     for i=1:length(pressSecs)
            number=num2str(pressSecs(i));
            Screen('TextFont', window, 'Arial');
            Screen('TextSize', window, 60);
            DrawFormattedText(window, number, 'center', 'center', [255 255 255]);
            Screen('Flip', window);
            [x,y,buttons] = GetMouse;
            if buttons(1)
                timing_15(1,j) = GetSecs-time0;
            end
            if buttons(3)
                timing_15(2,j) = GetSecs-time0;
            end
         %   fprintf('time is: %f\n', GetSecs-time0);
         %   fprintf('%f\n\n',pressSecs(i));     
     end
end

timing_28 = zeros(2,10);
for j = 1:10
 fprintf(s1, '2run'); 
 %Screen('DrawTextures', window, pump_screen, [], [xCenter-400 yCenter-100 xCenter-200 yCenter+100]);
 %Screen('Flip',window, [], 1);
 time0 = GetSecs;
     for i=1:length(pressSecs)

            number=num2str(pressSecs(i));
            Screen('TextFont', window, 'Arial');
            Screen('TextSize', window, 60);
            DrawFormattedText(window, number, 'center', 'center', [255 255 255]);
            Screen('Flip', window);
            [x,y,buttons] = GetMouse;
            if buttons(1)
                timing_28(1,j) = GetSecs-time0;
            end
            if buttons(3)
                timing_28(2,j) = GetSecs-time0;
            end
           % fprintf('time is: %f\n', GetSecs-time0);
           % fprintf('%f\n\n',pressSecs(i));     
     end
end
fclose(s1);
 Screen('CloseAll');
