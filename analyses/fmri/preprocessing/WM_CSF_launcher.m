function [status, output] = WM_CSF_launcher(subject, sequence)

    fprintf('launching WM_CSF %s %s\n',subject,sequence);
    pathToScript = fullfile([pwd '/WM_CSF'],'WM_CSF.sh');
    cmdStr = sprintf(" %s %s %s", 'bash -x', pathToScript, [subject ' ' sequence]) ;
    [status, output] = FPST_call_fsl(cmdStr); %matlab directory in fsl/etc needs to be (uncommented and) in path!!! or call_fsl in folder
    fprintf('finished WM_CSF %s %s\n',subject,sequence);
     
end