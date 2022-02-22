function smart_gunzip (source, wildcard, target, onlycopy) 
    %%smart_gunzip (source, wildcard, target, onlycopy) 
    %%gunzips the file from source folder to target folder.
    %%if it's a nii and not a nii.gz file, simply copies from source to
    %%target folder.
    %%this is a probably quite stupid way of finding the file with path, think of a better way
    img = dir(fullfile(source, wildcard)); %this is a stupid way of getting the file name, imrpove this
    if exist('onlycopy') %check if target_img exists, make it the unzipped for bolds and zipped for AP/PA
       onlycopy = 0;
    else
        onlycopy = 3;
    end
    if not(exist('target'))
        target = source;
    end
    
    target_img = dir(fullfile(target, wildcard(1:end-onlycopy))); %make sure the unzipped file (no .gz)  is not yet existent
    img = [img.folder '/' img.name];
    target_img = [target_img.folder '/' target_img.name]; %if target doesn't exist, gives '/'
    
    %make gunzip accept multiple possibilities for filename in target
    %folder, to check if renamed 4D file already exists
    %target_img = dir(fullfile(target{1}, wildcard(1:end-onlycopy))); 
    %img = [img.folder '/' img.name];
    %target_img = [target_img.folder '/' target_img.name]; %if target doesn't exist, gives '/'
    % if target_img == '/' && size(target,2)> 1
    %   target_img = dir(fullfile(target{2}, wildcard(1:end-onlycopy))); 
    %   img = [img.folder '/' img.name];
    %   target_img = [target_img.folder '/' target_img.name]; %if target doesn't exist, gives '/'
    %end
    if nargin < 2
        fprintf('not enough input for smart_gunzip');
    elseif nargin < 4 
        if target_img == '/'
		fprintf('gunzipping %s',img);
            gunzip(img, target);
        end
    elseif nargin == 4 || not(onlycopy)
        if target_img == '/'
		fprintf('copying %s',img);
            copyfile(img, target);
        end
    end
end