% spm12 job: prepare images
matlabbatch{1}.spm.util.exp_frames.files = '<UNDEFINED>';
matlabbatch{1}.spm.util.exp_frames.frames = 11:4000;
matlabbatch{2}.spm.util.cat.vols(1) = cfg_dep('Expand image frames: Expanded filename list.', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));
matlabbatch{2}.spm.util.cat.name = '<UNDEFINED>';
matlabbatch{2}.spm.util.cat.dtype = 0;
matlabbatch{3}.cfg_basicio.file_dir.file_ops.file_move.files(1) = cfg_dep('Expand image frames: Expanded filename list.', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));
matlabbatch{3}.cfg_basicio.file_dir.file_ops.file_move.action.delete = false;