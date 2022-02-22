function [status, output] = dvars_launcher(subject, sequence)

    fprintf('launching dvars %s %s\n',subject,sequence);
    pathToScript = fullfile([pwd '/dvars'],'dvars.sh');
    cmdStr = sprintf("%s %s %s", 'bash -x', pathToScript, [subject ' ' sequence]) ;
    [status, output] = FPST_call_fsl(cmdStr); %matlab directory in fsl/etc needs to be (uncommented and) in path!!! or call_fsl in folder
    fprintf('finished dvars %s %s\n',subject,sequence);
     
end