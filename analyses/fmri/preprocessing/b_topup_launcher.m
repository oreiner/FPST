function b_topup_launcher(subject, sequence)

    fprintf('launching topup %s %s\n',subject,sequence);
    pathToScript = fullfile(pwd,'b_topup_sbatch.sh');
    cmdStr = sprintf("%s %s %s", 'bash -x', pathToScript, [subject ' ' sequence]) ;
    [status, output] = FPST_call_fsl(cmdStr); %matlab directory in fsl/etc needs to be (uncommented and) in path!!! or call_fsl in folder

end