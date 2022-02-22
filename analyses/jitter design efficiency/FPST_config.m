function [blocks, repetitions, repetitions_test, null_events_learning, null_events_test, dummy_volumes, dur, rinse_pump, shake_pump, jitter_trials] = FPST_config()
    blocks=2;           % 2 blocks - learning trials and test trials555
    repetitions = 46;   %40*(number of fixed pairs is 3)*2=240 events   % how many repetitions of each pair should be in the learning trial (reinforcment learing) (one directional, so total is x2 for the flipped order)
    repetitions_test = 4; %4*(number of pair permutations is 15)*2=120 events   % how many repetitions of each pair should be in the test trial (choice task) (one directional, so total is x2 for the flipped order)
    null_events_learning = 0.1; % amount of null events to add to learning trial (reinforcment learing): 0.1 is adding 10% to the cue events as null events   
    null_events_test = 0.1; % amount of null events to add to test trial (choice task): 0.1 adding 10% to the cue events as null events  
    dummy_volumes = 10;  % seconds to leave off record from the beginning of scan, while magnet field stabilizes. depends on MRI sequence (TR)
    dur.max = 4;        % total trial time, used only in choice task
    dur.choice=0.3;     % duration of chosen cue presentation in secs, used only in choice task
    dur.resp=1.7;       % duration of maximal response time, added 0.1 to test time
    dur.pump=1.2;         % time between pump-start command and shake delivery
    dur.shake=3.1;      % duration of pump and shake delivery
    dur.rinse=2.7;      % duration of pump and shake delivery
    dur.miss=2;         % duration of "time out" presentation
    dur.null_event(1) = dur.resp + dur.shake + dur.pump; %+ dur.rinse + dur.pump; %duration of null event in learning trial (reinforcment learing)
    dur.null_event(2) = dur.max;  %duration of null event in test trial (choice task)
    rinse_pump = 3;     % start with run0 as neutral fluis pump (and alternate with later)
    shake_pump = 2;     % start with run1 as shake pump (and alternate with 1 later)
    pseudorandomize_bins = 10; %size of bin to be randomize for each Stimulus. helps avoiding "wrong paths" for subjects (for example, with pure random a subject might experience a set of consecutive losses for the A stimulus at the beginning) 
    %Jitter Variables
    jittermin = 0;
    jittermax = 1500;
    jitter_trials(1) = 3*repetitions*2;
    jitter_trials(2) = 15*repetitions_test*2;
end
