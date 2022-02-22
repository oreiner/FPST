function [imageArray] = load_pictures(wildcard, myFolder)
    if ~isdir(myFolder)
      errorMessage = sprintf('Error: The following folder does not exist:\n%s', myFolder);
      uiwait(warndlg(errorMessage));
      return;
    end
    filePattern = fullfile(myFolder, wildcard);
    pictures = dir(filePattern);
    imageArray = [];
    for k = 1:length(pictures)
      imageArray{k} = pictures(k).name;
    end
    %{ 
    %Matlab2017 version
    imageArray = strings(length(pictures),1);
    for k = 1:length(pictures)
      imageArray(k) = pictures(k).name;
    end
    %}
end
