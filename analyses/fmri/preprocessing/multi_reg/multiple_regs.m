function [metr_thr, threshold, nroutl, multi_reg] = multiple_regs(subject, sequence)
% generate text file with motion parameters, WM/CSF-mean signal and motion outliers
% -> multiple regressors in your GLM -> regress out effects of motion by

%% specify paths
datapath = '[Home Directory]/results/fmri/nii/';
datapathsub = fullfile(datapath, subject);

%% motion parameters
% Friston's 24-Parameter Model (1996):
% The 6 motion parameters of the current volume and the preceding volume,
% plus each of these values squared

% calculate Friston's 24
% Friston's 24-Parameter Model (1996):
% The 6 motion parameters of the current volume and the preceding volume,
% plus each of these values squared
fslfile = dir(fullfile(datapathsub,  ['*' sequence '_' subject '*.par']));
motion=load(fullfile(datapathsub, fslfile.name));
motionS = motion.^2;
motiontm1 = [zeros(1,6); motion(1:end-1,:)];
motiontm1S = motiontm1.^2;

% % calculate motion derivatives --> no improvement
% tr   = 1.05;
% for iVOL = 2:size(motion,1)
%     for iPAR = 1:6
%        motionD(iVOL,iPAR) = (motion(iVOL,iPAR)-motion(iVOL-1,iPAR))/tr;
%     end
% end
% motionDS = motionD.^2;

%% DVARS metrics
metrics = load(fullfile(datapathsub, ['moconf_metrics_dvars_' sequence '.txt']));
metr_thr=metrics(2:end);

% initial threshold (submitted paper)
% sd = std(metr_thr);
% threshold = 4*sd + median(metr_thr);

% new threshold
% specify the interquartile range of metrics
perc75 = prctile(metr_thr, 75);
threshold = perc75 + 2.5*iqr(metr_thr);

outl(1:numel(metrics)) = zeros;
for iVol = 1:numel(metrics)
    if metrics(iVol)>threshold
        outl(iVol) = 1;
    end
end
nroutl=numel(outl(outl==1));

%% signal from WM and CSF
means_wm = load(fullfile(datapathsub, ['means_wm_' sequence '.txt']));
means_cs = load(fullfile(datapathsub, ['means_cs_' sequence '.txt']));

%% motion outlier
if nroutl > 0
    matrix(numel(metrics),nroutl) = zeros;
    outl_index = find(outl);
    for iOutl = 1:nroutl
        matrix(outl_index(iOutl),iOutl) = 1;
    end
else matrix = []; % if there are no outliers
end

%% generate confound matrix
output = fullfile(datapathsub, ['75p25_24mp_WMCSF_' sequence '.txt']);
if ~exist(output, 'file')
    fprintf('saving confound matrix *.txt\n')
    % combine all confounds into a matrix
    multi_reg = [motion, motionS, motiontm1, motiontm1S, means_wm, means_cs, matrix];
    save(fullfile(datapathsub, ['75p25_24mp_WMCSF_' sequence '.txt']), 'multi_reg', '-ascii');
    %without WM
    %multi_reg = [motion, motionS, motiontm1, motiontm1S, means_cs, matrix];
    %save(fullfile(datapathsub, '75p25_24mp_CSF_noWM.txt'), 'multi_reg', '-ascii');
end

%% generate confound matrix with WM test ero 4
%{
for kernel = ['6','7']
    means_wm_test = load(fullfile(datapathsub, ['means_wm_' sequence '_testwith' kernel '.txt']));
    output = fullfile(datapathsub, ['75p25_24mp_WMCSF_' sequence '_' kernel '_WMtest.txt']);
    if ~exist(output, 'file')
        fprintf(['saving confound matrix with test WM ' kernel ' ero *.txt\n']);
        % combine all confounds into a matrix
        multi_reg = [motion, motionS, motiontm1, motiontm1S, means_wm_test, means_cs, matrix];
        save(fullfile(datapathsub, ['75p25_24mp_WMCSF_' sequence '_' kernel '_WMtest.txt']), 'multi_reg', '-ascii');
        %without WM
        %multi_reg = [motion, motionS, motiontm1, motiontm1S, means_cs, matrix];
        %save(fullfile(datapathsub, '75p25_24mp_CSF_noWM.txt'), 'multi_reg', '-ascii');
    end
end
%}

fprintf(['done ' subject ' :)\n'])

end
