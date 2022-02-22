cd [Home Directory]/analyses/fmri/preprocessing;
%7873 no transfer phase
subjects = {'2899','4643','4806','7873','8159','8904','8909','9012','9013'}; %'8947' lacks AP for topup
sequences = {'transfer'}; %'learning'
for i = 1:numel(subjects)
    for j = 1:numel(sequences)
        startclock = datetime('now');
        a_prepImg(subjects{i}, sequences{j});
        b_topup_launcher(subjects{i}, sequences{j});
        c_prepro(subjects{i}, sequences{j});
        [status, output] = dvars_launcher(subjects{i}, sequences{j})
        [status, output] = WM_CSF_launcher(subjects{i}, sequences{j})
        multiple_regs(subjects{i}, sequences{j});
        fprintf('finishing preprocesssing for subject %s %s preprocessing. it took %s\n', subjects{i}, sequences{j}, datetime('now') - startclock);
    end
end