function [cuename, nCues, numstimpairs, cue_set, stimuli, stimuli_outcomes] = create_trials_list(stimulusfile, blocks, repetitions, repetitions_test, pseudorandomize_bins, null_events_learning, null_events_test)
    % cue: which cue? associated with the contigency and assigned a random picture
    % contingency: e.g., 0.8 -> milkshake 80% neutral rinse 20%; 0.2 -> milkshake 20%
    % cuename: picture file name, e.g. swan.jpg
    [ cues, contingency] = textread(stimulusfile,'%d %f');
    %load all 31 images and choose 6 at random
    cuename = load_pictures('obj*','stimuli');

    rng('shuffle');                       % ensure random is random
    nCues=length(cues);                   % get number of trials
    nNames=length(cuename);
    randomorder=randperm(nNames);          % randomize an array, size = numel trials
    cuename = cuename(randomorder);       % only randomize the pictures. The training should always be constant pairs (80/20, 70/30, 60/40). in order to evaluate them later it should always be (1/2, 3/4, 5/6)
    cuename = cuename(1:nCues);           % choose 6 images from the pool           
    cue_set = zeros(nCues,2,blocks);      % preallocate cue_set for a faster code

    stimuli_outcomes = pseudorandomize(cues, contingency, repetitions*2, pseudorandomize_bins); %create a pseudorandom outcome for each stimuli.
    %stimuli struct: associate each cue (1,2,3,4,5,6) with a contigency (0.8,0.2,0.7,0.3,0.6,0.4) and a random picture
    %cue_set is a matrix for the cue pairs for the learning trials [1,2 ; 3,4 ; 5,6], therfore dimension is 1 cue_set(:,:,1).
    %afterwards expand cue_set to desired length and randomize order.
    for i=1:nCues
        stimuli.cues(i).contingency = contingency(i);
        stimuli.cues(i).cuename = cuename(i);
        if mod(i,2)
            cue_set(i,:,1) = [i,i+1]; 
        else
            cue_set(i,:,1) = [i,i-1];
        end
    end
    cue_set = repmat(cue_set,[repetitions,1]);
    %add null events, a bit tricky because it's a multidimensional matrix. so
    %needed to reshape(permut()), then cat extra zeros and (+transpose) reshape back
    cue_set = reshape(permute(cue_set, [1 3 2]), [], 2);
    %fix array length in case repetitions number with null events doesn't divide by 6
    if mod(round(null_events_learning*length(cue_set)),2)
        extra = 1;
    else
        extra = 0;
    end
    cue_set = [cue_set; zeros(round(null_events_learning*length(cue_set)-extra),2)];
    % turn 2d matrix to 3d matrix with 2 depth dimensions
    %[r,c] = size(a);
    %nlay  = 3;
    %out   = permute(reshape(a',[c,r/nlay,nlay]),[2,1,3]);
    cue_set = permute ( reshape (cue_set',[2,length(cue_set)/blocks,blocks]) , [2 1 3]);
    numstimpairs = length(cue_set);
    %randomize rows but keep columns so fixed pairs stay
    cue_set(:,:,1) = cue_set(randperm(numstimpairs),:,1);
    %create test set with all pair permutations, already in doubled form (e.g.
    %both (1,2) and (2,1) are in the set) & excluding twin-pairs (1,1) (2,2)
    %cue_set(:,:,2) is test trials set
    [ii,jj]=ndgrid(1:nCues,1:nCues);
    cue_set_test = [jj(:) ii(:)];
    cue_set_test(~(cue_set_test(:,1)-cue_set_test(:,2)),:)=[];
    cue_set_test = repmat(cue_set_test,[repetitions_test,1]);
    %add null events
    cue_set_test = [cue_set_test; zeros(round(null_events_test*length(cue_set_test)),2)];
    numstimpairs_test = length(cue_set_test);
    cue_set_test = cue_set_test(randperm(numstimpairs_test),:);
    %match dimensions (with -1 as each element), because block 2 is shorter than 1 
    match_vector = zeros(length(cue_set)-length(cue_set_test),2);
    match_vector(:,:) = -1;
    cue_set_test = [cue_set_test ; match_vector];
    cue_set(:,:,2) = cue_set_test(:,:);
end
