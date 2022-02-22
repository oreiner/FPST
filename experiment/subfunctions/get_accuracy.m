function [trial, numevents] = get_accuracy(trial, first_block, last_block)   
    %%initiziale variables
    %number of total events
    numevents = sum(~isnan(trial.cue(:,1,:)));
    %variables for test outcome
    trial.choose1 = nan(numevents(2),2);
    trial.avoid2= nan(numevents(2),2);
    trial.learningpairintest = nan(numevents(2),2);
    trial.winwin = nan(numevents(2),2);
    trial.loselose = nan(numevents(2),2);
    trial.AB = nan(numevents(1),2);
    trial.CD = nan(numevents(1),2);
    trial.EF = nan(numevents(1),2);

    for iB = first_block:last_block
            for iT=1:numevents(iB)
               A = nonzeros(trial.cue(iT, :, iB));
               B = trial.choice(iT, 1, iB); 
               if not(isnan(A)) %if not NaN (only end of block?, redundent?)
                   if A %if not null event as Zero, redundent through A = nonzeros(... ?
                        switch B 
                            case -9 %time elapsed events are defined by -9
                              outcome.missed_events(iB,iSub) = outcome.missed_events(iB,iSub) + 1;
                            case 1
                                trial.choose1(iT,iB) = 1;
                                switch A(A~=B)
                                    case 2
                                        trial.AB(iT,iB) = 1;  
                                        trial.avoid2(iT,iB) = 1;
                                    case 3
                                        trial.winwin(iT,iB) = 1;
                                    case 4
                                        trial.notinteresting(iT,iB) = 1;
                                    case 5
                                        trial.winwin(iT,iB) = 1;
                                    case 6
                                        trial.notinteresting(iT,iB) = 1;
                                end
                            case 3  
                                switch A(A~=B)
                                    case 1
                                        trial.choose1(iT,iB) = 0;
                                        trial.winwin(iT,iB) = 0;
                                    case 2
                                        trial.avoid2(iT,iB) = 1;
                                        trial.notinteresting(iT,iB) = 1;
                                    case 4
                                        trial.CD(iT,iB) = 1;  
                                    case 5
                                        trial.winwin(iT,iB) = 1;
                                    case 6
                                        trial.notinteresting(iT,iB) = 1;
                                end
                            case 5
                                switch A(A~=B)
                                    case 1
                                        trial.choose1(iT,iB) = 0;
                                        trial.winwin(iT,iB) = 0;
                                    case 2
                                        trial.avoid2(iT,iB) = 1;
                                        trial.notinteresting(iT,iB) = 1;
                                    case 4
                                        trial.notinteresting(iT,iB) = 1;
                                    case 3
                                        trial.winwin(iT,iB) = 0;
                                    case 6
                                        trial.EF(iT,iB) = 1; 
                                end
                            case 6
                                switch A(A~=B)
                                    case 1
                                        trial.choose1(iT,iB) = 0;
                                    case 2
                                        trial.avoid2(iT,iB) = 1;
                                        trial.loselose(iT,iB) = 1;
                                    case 3
                                        trial.notinteresting(iT,iB) = 0;
                                    case 4
                                        trial.loselose(iT,iB) = 1;
                                    case 5
                                        trial.EF(iT,iB) = 0; 
                                end
                            case 4
                                switch A(A~=B)
                                    case 1
                                        trial.choose1(iT,iB) = 0;
                                    case 2
                                        trial.avoid2(iT,iB) = 1;
                                        trial.loselose(iT,iB) = 1;
                                    case 3
                                        trial.CD(iT,iB) = 0; 
                                    case 5
                                        trial.notinteresting(iT,iB) = 0; 
                                    case 6 
                                         trial.loselose(iT,iB) = 0;
                                end
                            case 2
                                trial.avoid2(iT,iB) = 0;
                                switch A(A~=B)
                                    case 1
                                        trial.choose1(iT,iB) = 0;
                                        trial.AB(iT,iB) = 0;
                                    case 3
                                        trial.notinteresting(iT,iB) = 0;
                                    case 5
                                        trial.notinteresting(iT,iB) = 0;
                                    case 4
                                        trial.loselose(iT,iB) = 0;
                                    case 6
                                        trial.loselose(iT,iB) = 0;
                                end
                            otherwise
                               disp('some outcome was missed in the code');
                        end
                   end
               end
            end
            trial.correct(iB) = nansum(trial.AB(:,iB)) + ...
                nansum(trial.CD(:,iB)) + ...
                nansum(trial.EF(:,iB)) + ...
                nansum(trial.winwin(:,iB)) + ...
                nansum(trial.loselose(:,iB)) + ...
                nansum(trial.notinteresting(:,iB));
    end
end