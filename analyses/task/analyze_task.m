%run from "analyses" Folder

function analyze_task(subject)
    datapath = ['../../data/task/FPST_' subject];
    resultspath = ['../../results/task/' subject];
    
    if not(exist(resultspath,'dir'))
        mkdir(resultspath)
    end
    
    if not(exist('binSize', 'var'))
        binSize = 4 ;
    end
    if not(exist('binSizeAll', 'var'))
        binSizeAll = 12 ;
    end
    binSize=1;binSizeAll=1;
   
    logfile = (fullfile (datapath, ['FPST_' subject '_logs.mat']));
    load(logfile);
    
   %for muX0 = 0:0.5:1 %compare prior states (cue starting value) - all as losers, 50%/50% or winners. 
   %for muX0 = 0.25 %removed 0.5 because I already have igt
   for muX0 = 0.5 %for learning curve purposes, but maybe I would take it for action values?
        for i = 0:1	%compare asymettrical with unitary learning rate
        %for i=1 %for learning curves only asym
            if i
                flag = 'asymmetrical';
            else
                flag = 'unitary';
            end

            for j = 0:1
            %for j=1 %for learning curves only normal temp
                 if j
                    flag2 = 'normal_temperature';
                else
                    flag2 = 'fixed_temperature'; %sigmaPhi=0 is fixed               
                 end

                for k = 1:3
                %for k=3 %for learning curves it doesn't matter
                    [end_results.onsets, data] = format_data(onsets, trial, size(trial.cue,3)); 
                    trialstest = sum(isnan(data.feedbacks)); %seperate phases by using feedbacks vector: learn phase has no nans, test phase has only nans
                     if k == 1 
                        flag0 = 'only_learn_phase';
                        data.feedbacks = data.feedbacks(1:end-trialstest);
                        data.choices = data.choices(1:end-trialstest);
                        data.cues = data.cues(:,1:end-trialstest);
                     elseif k == 2
                        flag0 = 'only_test_phase';
                        data.feedbacks = data.feedbacks((end-trialstest+1):end);
                        data.choices = data.choices((end-trialstest+1):end);
                        data.cues = data.cues(:,(end-trialstest+1):end);
                        muTheta = posterior.muTheta;
                        muPhi = posterior.muPhi;
                     else
                        flag0 = 'both_phases';
                     end

                    if k == 2 && not(j) %only test phase, fix, so no PE 
                       [posterior, out] = demo_QlearningAsymetric (data, i, j, muX0, muTheta, muPhi);  %perform inversion for test by using a fixed learning rate & temperature from the previous inversion      
                    elseif k ~= 2 
                       [posterior, out] = demo_QlearningAsymetric (data, i, j, muX0); 
                       [end_results.model.pos_PE, end_results.model.neg_PE] = format_PE(posterior.PE);
                    else
                        continue;
                    end
                    %added block 1 to format_test_phase instead of only going through block 2, in order to get the Qchosen values for
                    %the 1st level. make sure this doens't create bugs
                    first_block = 1; last_block = 2;
                    %hard coded exception for 7873, as he has no tranfer phase
                    %data
                    if strcmp(subject,'7873')
                        last_block = 1;
                    end
                    [end_results.onsets, end_results.trial, end_results.model, end_results.forTest] = format_test_phase(trial, end_results.model, end_results.onsets, posterior, first_block, last_block, flag0, binSize, binSizeAll);   
                    save(fullfile(resultspath,[ subject '_task_results_' flag0 '_' flag '_' flag2 '_priorX0_' num2str(muX0) '_binSize_' num2str(binSize) '.mat']), 'end_results', 'posterior', 'out', 'data');

                end
            end  
        end
    end
end