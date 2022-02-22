function [subj] = get_fmri_signal(cross_screen, window, simulation, do_fmri_flag, dummy_volumes, iBlock)
    
    %% prepare responses/scanner input codes
    keyTrigger=KbName('5');
    keyTrigger2=KbName('5%');
    keyQuit=KbName('q');
    
    count_trigger = 0;
    subj.trigger.pre = GetSecs;
    
    if do_fmri_flag == 1
        KbQueueCreate();
        KbQueueFlush();
        KbQueueStart(); 
        [b,c] = KbQueueCheck;
        while c(keyQuit) == 0
            [b,c] = KbQueueCheck;
            if c(keyTrigger) || c(keyTrigger2) > 0
                if iBlock == 1
                    Screen('CopyWindow',cross_screen, window);
                    Screen('Flip', window);
                end
                count_trigger = count_trigger + 1;
                subj.trigger.all(count_trigger,1) = GetSecs;
                if simulation == 1
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
end
