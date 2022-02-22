function present_accuracy(trial, numevents, cuename) 
    screens = Screen('Screens'); %Define display screen
    screenNumber = max(screens);
    
    PsychDefaultSetup(2);
    Screen('Preference', 'VisualDebugLevel', 0); % before:3; Remove blue screen flash and minimize extraneous warnings.
    Screen('Preference', 'SuppressAllWarnings', 1);
    Screen('Preference', 'SkipSyncTests', 1);
    Screen('Preference', 'Verbosity', 0); %optimization for real runs output no errors, so code won't overload
    oldResolution=Screen('Resolution', screenNumber);
    screenRes=[0 0 oldResolution.width oldResolution.height];
    HideCursor;
    [window, screenrect] = Screen('OpenWindow',screenNumber,[0 0 0]); %, screenRes
    [screenXpixels, screenYpixels] = Screen('WindowSize', window);
    [xCenter, yCenter] = RectCenter(screenrect);
   
    textsize = 20;
    
    results_text = ['Danke, dass Sie mitgemacht haben!' ...
    '\n\n Sie haben ' num2str(trial.correct(2)) ' von ' num2str(numevents(2)) ' Punkten im Test erreicht.' ...
    '\n\n damit hatten Sie eine Erfolgsquote von ' num2str(round(trial.correct(2)/numevents(2)*100)) '%'];
    
    results_screen = Screen('OpenOffscreenwindow',window, [0 0 0]); Screen('TextSize',results_screen,textsize); Screen('TextFont',results_screen,'Arial');
    DrawFormattedText(results_screen, results_text, 'center', 'center', [255 255 255]);
    
    Screen('CopyWindow',results_screen, window);
    Screen('Flip', window);
    
    %present order
    fprintf('correct order was:\n %s\n %s\n %s\n %s\n %s\n %s\n', cuename{1}, cuename{3}, cuename{5}, cuename{6}, cuename{4}, cuename{2}); 
    %wait for non 5 keypress.
    fprintf('dear experimenter, please click any button (other than 5) to finish experiment!\n');
    WaitNon5;
    Screen('CloseAll');
end
