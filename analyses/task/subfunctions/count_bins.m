%% AUX function for format_test_phase
%%count correct answers divided by bins, counting missed events as false
%%as this makes the bins fixed size - better comparible
%% for learn phase 12 is a good divider (for 96). [trial.correct_bins] = count_bins(trial.winlose(:,iB), missed_events, 12);
%% for test phase 4 or 23? unfortunatly no good divider for 92

function [correct_bins] = count_bins(bins, missed_events, divider) 
                %bins = trial.winlose(:,iB); %winlose in block 1 are all the pairs
                %reinsert missed events as zeros
                insert = @(a,x,n)cat(1, x(1:n-1), a, x(n:end));
                if not(isnan(missed_events))
                    if missed_events(1)==1
                        bins = [0 ; bins];
                        missed_events(1)=[];
                    end                
                    for iN = missed_events'
                        bins = insert (0, bins ,iN);
                    end
                end
                bins(isnan(bins))=[];
                jBin = 1;
                for iBin = 1:divider:numel(bins)
                    correct_bins(jBin) =  sum(bins(iBin:(iBin+divider-1)))'; 
                    jBin = jBin + 1;
                end              
                %return correct_bins;
end