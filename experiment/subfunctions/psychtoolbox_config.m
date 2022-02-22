function [window, screen_config] = psychtoolbox_config(simulation)
    screens = Screen('Screens'); %Define display screen
    screen_config.screenNumber = max(screens);
    % % Set priority for script execution to realtime priority:
    % priorityLevel=MaxPriority(window);
    % Priority(priorityLevel);    
    PsychDefaultSetup(2);
    Screen('Preference', 'VisualDebugLevel', 0); % before:3; Remove blue screen flash and minimize extraneous warnings.
    Screen('Preference', 'SuppressAllWarnings', 1);
    Screen('Preference', 'SkipSyncTests', 1);
    %if not(simulation)
        Screen('Preference', 'Verbosity', 0); %optimization for real runs output no errors, so code won't overload
    %end
    oldResolution=Screen('Resolution', screen_config.screenNumber);
    screen_config.screenRes=[0 0 oldResolution.width oldResolution.height];
    AssertOpenGL;
    if not(simulation)
        HideCursor;
    end
    
    screen_config.black = BlackIndex(screen_config.screenNumber);
    screen_config.white = WhiteIndex(screen_config.screenNumber);
    
    [window, screen_config.screenrect] = Screen('OpenWindow',screen_config.screenNumber, screen_config.black); %screenRes
    [screen_config.screenXpixels, screen_config.screenYpixels] = Screen('WindowSize', window);
    [screen_config.xCenter, screen_config.yCenter] = RectCenter(screen_config.screenrect);
    
end