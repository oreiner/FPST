%%===================Identity query===================
%Asks an open and a forced-choice question about the stimulus identity
%

%Coded by: Nils Kroemer

%Update coded with: Matlab R2014a using Psychtoolbox 3.0.11

%========================================================

load(sprintf('Order/condition_mat_%s.mat',subjectID))

display_str = '';
display_char = '';

    rating_scr = Screen('OpenOffscreenwindow',window,[0 0 0]);
   
    Screen('TextSize',rating_scr,14);
    Screen('TextFont',rating_scr,'Arial');
    
    text_question = ['What flavor do you think did you try?' ...
                     '\n\n\n\n No capital letters please.'];
    
    DrawFormattedText(rating_scr, text_question, 'center', (Screen_height/4), [205 201 201],80);
    
    Screen('CopyWindow',rating_scr,window);
    Screen('Flip',window);
    
    del_key = KbName('backspace');
    conf_key = KbName('return');
    space_key = KbName('space')';
    
    while 1
        [a, b, c] = KbCheck;
        
        if c(conf_key)
            output.trial.flavor{trial_i,1} = display_str;
            break
        end
        
        if any(c) ~= 0
            
            if c(del_key)
                display_str = display_str(1:(length(display_str))-1);
                WaitSecs(0.15);
            elseif c(space_key)
                display_str = [display_str ' '];
                WaitSecs(0.15);
            else
            
                temp_char = KbName(c);
                
                if iscell(temp_char)
                     display_char = [temp_char{1,1} temp_char{1,2}];
                else
                     display_char = temp_char;
                end
                
                %restrict input vector for display
                if length(display_char) > 2
                    display_char = '';
                end
                
                display_str = [display_str display_char];

                WaitSecs(0.12);
            end
        end
        
        %DrawFormattedText(rating_scr, text_question, 'center', (Screen_height/4), [205 201 201],80);
        Screen('CopyWindow',rating_scr,window)
        
        DrawFormattedText(window, display_str, 'center', (Screen_height/2), [205 201 201],80);
               
        Screen('Flip',window);    

    end
        
        Screen(rating_scr,'FillRect', [0 0 0], [screenrect]);
        Screen('CopyWindow',rating_scr,window)
        Screen('Flip',window);
        
        text_question = ['If you had to pick one of the following flavors which one would you choose?'];
    
        flavors_val = [1 3 9 11:22];
        x_pos_options = [(Screen_width/8) (3*Screen_width/8) (5*Screen_width/8) (7*Screen_width/8)];
        x_pos_labels = [(Screen_width/8 - 20) (3*Screen_width/8 - 20) (5*Screen_width/8 - 20) (7*Screen_width/8 - 20)];

        option_corr = flavors.id(part_cond_mat(trial_i,1)).name;
        
        dist_flavors = flavors_val(part_cond_mat(trial_i,1) ~= flavors_val);

        options_drawn = datasample(dist_flavors,3,'Replace',false);
        
        x_pos_drawn = datasample(x_pos_options,4,'Replace',false);

        option_dist1 = flavors.id(options_drawn(1)).name;
        option_dist2 = flavors.id(options_drawn(2)).name;
        option_dist3 = flavors.id(options_drawn(3)).name;
        
        DrawFormattedText(rating_scr, text_question, 'center', (Screen_height/4), [205 201 201],80);
        
        DrawFormattedText(rating_scr, option_corr, x_pos_drawn(1), (Screen_height/2), [205 201 201],80);
        DrawFormattedText(rating_scr, option_dist1, x_pos_drawn(2), (Screen_height/2), [205 201 201],80);
        DrawFormattedText(rating_scr, option_dist2, x_pos_drawn(3), (Screen_height/2), [205 201 201],80);
        DrawFormattedText(rating_scr, option_dist3, x_pos_drawn(4), (Screen_height/2), [205 201 201],80);

        DrawFormattedText(rating_scr, 'a)', x_pos_labels(1), (Screen_height/2), [205 201 201],80);
        DrawFormattedText(rating_scr, 'b)', x_pos_labels(2), (Screen_height/2), [205 201 201],80);
        DrawFormattedText(rating_scr, 'c)', x_pos_labels(3), (Screen_height/2), [205 201 201],80);
        DrawFormattedText(rating_scr, 'd)', x_pos_labels(4), (Screen_height/2), [205 201 201],80);
        
        Screen('CopyWindow',rating_scr,window);
        Screen('Flip',window);
        
    while 1
    
        [a, b, c] = KbCheck;
        
%         if c(conf_key)
%             %output.trial.flavor{out_ind} = display_str;
%             break
%         end
        
        temp_char = KbName(c);
                
        if iscell(temp_char)
            display_char = temp_char{1,1};
        else
            display_char = temp_char;
        end
        
        if strcmp(display_char, 'a')
            DrawFormattedText(rating_scr, 'a)', x_pos_labels(1), (Screen_height/2), [205 0 0],80);
            output.trial.fc_quest{trial_i,1} = 'a';
            output.trial.fc_quest{trial_i,2} = x_pos_drawn(1) == x_pos_options(1);
            break
        elseif strcmp(display_char, 'b')
            DrawFormattedText(rating_scr, 'b)', x_pos_labels(2), (Screen_height/2), [205 0 0],80);
            output.trial.fc_quest{trial_i,1} = 'b';
            output.trial.fc_quest{trial_i,2} = x_pos_drawn(1) == x_pos_options(2);
            break
        elseif strcmp(display_char, 'c')
            DrawFormattedText(rating_scr, 'c)', x_pos_labels(3), (Screen_height/2), [205 0 0],80);
            output.trial.fc_quest{trial_i,1} = 'c';
            output.trial.fc_quest{trial_i,2} = x_pos_drawn(1) == x_pos_options(3);
            break
        elseif strcmp(display_char, 'd')
            DrawFormattedText(rating_scr, 'd)', x_pos_labels(4), (Screen_height/2), [205 0 0],80);
            output.trial.fc_quest{trial_i,1} = 'd';
            output.trial.fc_quest{trial_i,2} = x_pos_drawn(1) == x_pos_options(4);
            break
        end
    
    end
    
        Screen('CopyWindow',rating_scr,window);
        Screen('Flip',window);
    
    WaitSecs(feedback_delay);