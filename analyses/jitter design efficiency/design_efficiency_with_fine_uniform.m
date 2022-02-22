%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Design Efficiency for FPST
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all; clc; 

% Run this line only once after starting up matlab & then comment
addpath '/DATA/reinero/Dokumente/FPST/analyses/jitter design efficiency';
outputPath= ['/DATA/reinero/Dokumente/FPST/results/jitter design efficiency/output'];

%%fetch subjects
subjectpath= '/DATA/reinero/Dokumente/FPST/results/task';
jitterpath = '/DATA/reinero/Dokumente/FPST/data/task';
subjects = {'2899','4643','4806','7873','8159','8904','8909','8947','9012','9013'};

spm_jobman('initcfg');
numtrial=46*6;
list = '_with_fine_uniform_dissversion'; %gives the run a unique name
dummy_volumes = 10;
knum=500;	 

% some MR parameters.
TR      = 1.220;      % in seconds
nSlices = 60;
onsetSlice = 6;
nVols= 2160;
highPassThresh = 128;

%preallocating variables
numreg = 8;
%cnr = 1;
%cons = zeros (numreg, cnr);
% cue Qchosen PShake pm NShake pm   miss constant
%  1     2       3   4     5    6     7      8
%define conditions of interest
%{
clear cons;
cnr = 1;
cons = zeros (numreg, cnr);
cons(2,1) = 1;
cnr=cnr+1;
cons(4,1) = 1; cons(6,1) = -1;
%}

%%%%%the above conditions seems to be wrong to me!!! the pms arn't counted?
%so maybe it's 
%cue Pshake Nshake
% 1    2      3
clear cons;
cnr=1;
cons(cnr,:)=zeros(1,numreg); cons(cnr,1)= 1;
cnr=cnr+1;
cons(cnr,:)=zeros(1,numreg); cons(cnr,2)= 1;
cnr=cnr+1;
cons(cnr,:)=zeros(1,numreg); cons(cnr,3)= 1;
cnr=cnr+1;
cons(cnr,:)=zeros(1,numreg); cons(cnr,3)= 1; cons(cnr,5)= -1;
cnr=cnr+1;
cons(cnr,:)=zeros(1,numreg); cons(cnr,4)= 1; 
cnr=cnr+1;
%cons(cnr,:)=zeros(1,numreg); cons(cnr,4)= 1; cons(cnr,6)= -1;
%cnr=cnr+1;
%cons(cnr,:)=zeros(1,numreg); cons(cnr,4)= -1; cons(cnr,6)= 1;
%cnr=cnr+1;


cons=cons';

for iJitter = 1:17
    
    designName= ['vox2_' num2str(iJitter)];
    savePath=fullfile(outputPath, ['With_real_subjects_bestjitt_list' num2str(list)], designName);
    if not(exist(savePath))
        mkdir(savePath); % create directory and cd to it.
    end
    cd(savePath);

clear k;
clear jitter;
jitter.u = zeros(2, numtrial);
for k=1:knum
      
    %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % 1. Automatic adaptation of batch due to modification
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %load subjects one after the other to also allow for more variability
    %taken into account in the simulation
     subnum = mod(k,numel(subjects));
     if not(subnum)
         subnum=10;
     end
     response_time=0; %simulate response times by default
     %create jitter lists
    if iJitter == 1
        % real jitters 
        % jitt1 mean=0.9s; total=4.1min
        realjitters = load(fullfile(jitterpath,['FPST_' subjects{subnum}],[ 'FPST_' subjects{subnum} 'full.mat']), 'jitter');
        jitter(k).u(1,:)= realjitters.jitter(:,1);
        response_time = 1; %use the real response time as  
    elseif iJitter == 2
        % potential of the jitter formula used
        % jitt1 mean=0.9s; total=4.06min
        jitter(k).u(1,:)=0.6+exprnd(0.3,numtrial,1);
        response_time = 1; %use the real response time as resp time
    elseif iJitter == 3
        % potential of the jitter formula used when maximizing response time
        % without a second jitter
        % jitt1 mean=0.9s; total=4.06min
        jitter(k).u(1,:)=0.6+exprnd(0.3,numtrial,1);
        response_time=repmat(1.7,1,numtrial);
        
    elseif iJitter == 4
        %time=1.7min
        jitter(k).u(1,:)=randi([0 750],1,numtrial);
        jitter(k).u(1,:)=round((jitter(k).u(1,:)/1000),1)';

    elseif iJitter == 5
        %time=1.7min
        jitter(k).u(1,:)=randi([0 750],1,numtrial);
        jitter(k).u(1,:)=round((jitter(k).u(1,:)/1000),1)';
        response_time=repmat(1.7,1,numtrial);
        
    elseif iJitter == 6
        %time=3.5min
        jitter(k).u(1,:)=randi([0 1500],1,numtrial);
        jitter(k).u(1,:)=round((jitter(k).u(1,:)/1000),1)';

    elseif iJitter == 7
        %time=3.5min
        jitter(k).u(1,:)=randi([0 1500],1,numtrial);
        jitter(k).u(1,:)=round((jitter(k).u(1,:)/1000),1)';
        response_time=repmat(1.7,1,numtrial);
        
    elseif iJitter == 8
        
          % 0 or 500 or 1000 or  1500 
        % jitt1 mean=0.75s; total=3.45min
        x = [0,500,1000,1500];
        y = repmat(x,1,numtrial/numel(x));
        jitter(k).u(1,:)=y(randperm(numel(y)));
        jitter(k).u(1,:)=round((jitter(k).u(1,:)/1000),1)';  
        
    elseif iJitter == 9
   
          % 0 or 500 or 1000 or  1500 
        % jitt1 mean=0.75s; total=3.45min
        x = [0,500,1000,1500];
        y = repmat(x,1,numtrial/numel(x));
        jitter(k).u(1,:)=y(randperm(numel(y)));
        jitter(k).u(1,:)=round((jitter(k).u(1,:)/1000),1)';  
        response_time=repmat(1.7,1,numtrial);
        
    elseif iJitter == 10
        %total = 3.4min
        jitter(k).u(1,:)=randi([0 750],1,numtrial);
        jitter(k).u(1,:)=round((jitter(k).u(1,:)/1000),1)';
        jitter(k).u(2,:)=randi([0 750],1,numtrial);
        jitter(k).u(2,:)=round((jitter(k).u(1,:)/1000),1)';
        
     elseif iJitter == 11
         %total = 3.4min
        jitter(k).u(1,:)=randi([0 750],1,numtrial);
        jitter(k).u(1,:)=round((jitter(k).u(1,:)/1000),1)';
        jitter(k).u(2,:)=randi([0 750],1,numtrial);
        jitter(k).u(2,:)=round((jitter(k).u(1,:)/1000),1)';
        response_time=repmat(1.7,1,numtrial);
    elseif iJitter == 12
            %total = 7min
     jitter(k).u(1,:)=randi([0 1500],1,numtrial);
        jitter(k).u(1,:)=round((jitter(k).u(1,:)/1000),1)';
        jitter(k).u(2,:)=randi([0 1500],1,numtrial);
        jitter(k).u(2,:)=round((jitter(k).u(1,:)/1000),1)';
        
     elseif iJitter == 13
         %total = 7min
        jitter(k).u(1,:)=randi([0 1500],1,numtrial);
        jitter(k).u(1,:)=round((jitter(k).u(1,:)/1000),1)';
        jitter(k).u(2,:)=randi([0 150],1,numtrial);
        jitter(k).u(2,:)=round((jitter(k).u(1,:)/1000),1)';
        response_time=repmat(1.7,1,numtrial);

    elseif iJitter == 14
    %total = 7min
         % 0 or 500 or 1000 or  1500 
        % jitt1 mean=1; jitt2 mean=3
        x = [0,500,1000,1500];
        y = repmat(x,1,numtrial/numel(x));
        jitter(k).u(1,:)=y(randperm(numel(y)));
        jitter(k).u(1,:)=round((jitter(k).u(1,:)/1000),1)';
        jitter(k).u(2,:)=y(randperm(numel(y)));
        jitter(k).u(2,:)=round((jitter(k).u(1,:)/1000),1)';  
        
        
       
     elseif iJitter == 15
         
           % 0 or 500 or 1000 or  1500 
        % jitt1 mean=1; jitt2 mean=3 ; total=7min
        x = [0,500,1000,1500];
        y = repmat(x,1,numtrial/numel(x));
        jitter(k).u(1,:)=y(randperm(numel(y)));
        jitter(k).u(1,:)=round((jitter(k).u(1,:)/1000),1)';
        jitter(k).u(2,:)=y(randperm(numel(y)));
        jitter(k).u(2,:)=round((jitter(k).u(1,:)/1000),1)';  
        response_time=repmat(1.7,1,numtrial); 

    elseif iJitter == 16
        %total=6.7+6.7
          jitter(k).u(1,:)=randi([0 3000],1,numtrial);
        jitter(k).u(1,:)=round((jitter(k).u(1,:)/1000),1)';
        jitter(k).u(2,:)=randi([0 3000],1,numtrial);
        jitter(k).u(2,:)=round((jitter(k).u(1,:)/1000),1)';
        
       
    elseif iJitter == 17
         %total=6.7+6.7
          jitter(k).u(1,:)=randi([0 3000],1,numtrial);
        jitter(k).u(1,:)=round((jitter(k).u(1,:)/1000),1)';
        jitter(k).u(2,:)=randi([0 3000],1,numtrial);
        jitter(k).u(2,:)=round((jitter(k).u(1,:)/1000),1)';
        response_time=repmat(1.7,1,numtrial);   
            
    end

 
    %% define onsets dependent upon random jitter
    %addpath '/DATA/reinero/Dokumente/FPST/results/task/9013'
   %?
    %% get choices and PE
    load(fullfile(subjectpath,subjects{subnum},[ subjects{subnum} '_task_results_both_phases_asymmetrical_normal_temperature.mat']));
    close;
    
    %remove missed events from cue because I formatted the cue onsets
    %vector without them, unfortunatly
    if (response_time==1) %if set to zero, simulate random time length around a N-distribution 
        response_time = end_results.onsets(1).choicescreen - end_results.onsets(1).cue;
    end
    
    [simulation endtime] = FPST_simulate_onsets(jitter(k).u, end_results.trial, posterior.PE, response_time);
    
    %real timings for the real subjects
    if iJitter==1
          simulation = end_results.onsets(1);
    end
    
    %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % 2. Specify batch
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    matlabbatch{1}.spm.stats.fmri_design.dir = {savePath};
    matlabbatch{1}.spm.stats.fmri_design.timing.units = 'secs';
    matlabbatch{1}.spm.stats.fmri_design.timing.RT = TR;
    matlabbatch{1}.spm.stats.fmri_design.timing.fmri_t = nSlices;
    matlabbatch{1}.spm.stats.fmri_design.timing.fmri_t0 = onsetSlice;
    matlabbatch{1}.spm.stats.fmri_design.sess.nscan = nVols;
    
    c=1;
    matlabbatch{1}.spm.stats.fmri_design.sess.cond(c).name = 'cue'; 
    matlabbatch{1}.spm.stats.fmri_design.sess.cond(c).onset = simulation.cue; 
    matlabbatch{1}.spm.stats.fmri_design.sess.cond(c).duration = 0;
     matlabbatch{1}.spm.stats.fmri_design.sess.cond(c).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_design.sess.cond(c).pmod(1).name = 'Qchosen';
    matlabbatch{1}.spm.stats.fmri_design.sess.cond(c).pmod(1).param = end_results.model.Qchosen(:,1);
    matlabbatch{1}.spm.stats.fmri_design.sess.cond(c).pmod(1).poly = 1;
    matlabbatch{1}.spm.stats.fmri_design.sess.cond(c).orth = 1;
    c=c+1;
    
    matlabbatch{1}.spm.stats.fmri_design.sess.cond(c).name = 'Pshake';
    matlabbatch{1}.spm.stats.fmri_design.sess.cond(c).onset = simulation.Pshake;
    matlabbatch{1}.spm.stats.fmri_design.sess.cond(c).duration = 0;
    matlabbatch{1}.spm.stats.fmri_design.sess.cond(c).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_design.sess.cond(c).pmod(1).name = 'pos_PE';
    matlabbatch{1}.spm.stats.fmri_design.sess.cond(c).pmod(1).param = end_results.model.pos_PE;
    matlabbatch{1}.spm.stats.fmri_design.sess.cond(c).pmod(1).poly = 1;
    matlabbatch{1}.spm.stats.fmri_design.sess.cond(c).orth = 1;
    c=c+1;
    
    matlabbatch{1}.spm.stats.fmri_design.sess.cond(c).name = 'Nshake';
    matlabbatch{1}.spm.stats.fmri_design.sess.cond(c).onset = simulation.Nshake;
    matlabbatch{1}.spm.stats.fmri_design.sess.cond(c).duration = 0;
    matlabbatch{1}.spm.stats.fmri_design.sess.cond(c).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_design.sess.cond(c).pmod(1).name = 'neg_PE';
    matlabbatch{1}.spm.stats.fmri_design.sess.cond(c).pmod(1).param = end_results.model.neg_PE;
    matlabbatch{1}.spm.stats.fmri_design.sess.cond(c).pmod(1).poly = 1;
    matlabbatch{1}.spm.stats.fmri_design.sess.cond(c).orth = 1;
    c=c+1;
 %{
    matlabbatch{1}.spm.stats.fmri_design.sess.cond(c).name = 'null_events';
    matlabbatch{1}.spm.stats.fmri_design.sess.cond(c).onset = end_results.onsets(1).null;
    matlabbatch{1}.spm.stats.fmri_design.sess.cond(c).duration = 0;
    matlabbatch{1}.spm.stats.fmri_design.sess.cond(c).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_design.sess.cond(c).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_design.sess.cond(c).orth = 1;
    c=c+1;
  %}  
    matlabbatch{1}.spm.stats.fmri_design.sess.cond(c).name = 'miss_events';
    matlabbatch{1}.spm.stats.fmri_design.sess.cond(c).onset = simulation.miss;
    matlabbatch{1}.spm.stats.fmri_design.sess.cond(c).duration = 0;
    matlabbatch{1}.spm.stats.fmri_design.sess.cond(c).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_design.sess.cond(c).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_design.sess.cond(c).orth = 1;
    
    
    
    %define other things
    matlabbatch{1}.spm.stats.fmri_design.sess.multi = {''};
    matlabbatch{1}.spm.stats.fmri_design.sess.regress = struct('name', {}, 'val', {});
    matlabbatch{1}.spm.stats.fmri_design.sess.multi_reg = {''};
    matlabbatch{1}.spm.stats.fmri_design.sess.hpf = highPassThresh;
    matlabbatch{1}.spm.stats.fmri_design.fact = struct('name', {}, 'levels', {});
    matlabbatch{1}.spm.stats.fmri_design.bases.hrf.derivs = [0 0]; %no time derivatives. consider adding
    matlabbatch{1}.spm.stats.fmri_design.volt = 1;
    matlabbatch{1}.spm.stats.fmri_design.global = 'None';
    matlabbatch{1}.spm.stats.fmri_design.mthresh = 0.8;
    matlabbatch{1}.spm.stats.fmri_design.cvi = 'AR(1)';
    
    %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % 3. Run Efficiency calculation for different design configurations
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %spm_jobman('interactive', matlabbatch); % for debugging
    
    delete(fullfile(savePath, 'SPM.mat')); % just make sure there is no SPM in the folder
    %spm_jobman('interactive', matlabbatch);
    spm_jobman('run', matlabbatch);
    pause(0.5); % pause to assure that data can be saved to be reloaded
    
    load(fullfile(savePath, 'SPM.mat'));
    
    %% A) Alternative: Access before prewhitening and filtering
   %  X = SPM.xX.X;
    
    %% B) High-pass filter X as SPM would do in spm_spm
    
    % create filter according to spm_sp and spm_filter
    xX = SPM.xX;
    xX.K.row = 1:nVols; xX.K.RT = TR; xX.K.HParam=128; xX.K = spm_filter(xX.K);
    
    % we cannot prewhiten without data (hyperparameter estimation);
    W = eye(nVols);
    xX.xKXs   = spm_sp('Set',spm_filter(xX.K,W*xX.X));
    % after pre-whitening and filtering
    X = xX.xKXs.X;
    %%
    for indC = 1:size(cons,2)
        c = cons(:,indC);
        eff(indC) = 1/(c'*pinv(X'*X)*c);
    end
    cc=corrcoef(X);
    effall(k,:)=eff;
    save(sprintf('para_%02.0f',k),'X','xX');
    %figure(10);
    %subplot(7,2,k); plot(X(:,1:2)); title(sprintf('sum: %0.3f; diff: %0.3f;',eff(1)));%,eff(2)));

    % compute Laplace Chernoff risk as global efficiency
    LC_risk(k) = -trace(cons'*pinv(X'*X)*cons);
    save('endtime');
end

save(fullfile(savePath,'efftest'),'effall','LC_risk','jitter','cc'); %'dur_scans'
 figure; boxplot(effall)
 max_eff.jitt2_uni(1:numel(max(effall))) = max(effall); %(1:3)
 save('max_effs','max_eff')
end
