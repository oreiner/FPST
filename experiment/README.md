# Preparation and Experiment 

The partipants perform a decision making task in the MRI-machine, and recieve fluid-based feedback directly to their mouthes.

Preparation includes acquiring informed consent, taking blood samples (Glucose, Insulin), performing a BIA, performing a pre-test taste taste to choose the solutions for the experiment, training the participant for the task and send the partipant to prepare for the scan.  
While the partipant is placed into the MRI, including fitting the mirrored glasses for viewing the monitor and testing if the participant sees the screen properly, set up the computer and pump sytem. Once pumps are configurated, push each syringe manually to bring fluid to end of tube at mouth height and withdraw the fluid with the script. Make sure the tubes are at about the height of the partipant's mouth, so the fluid front will be correctly calibrated!

Once prepared, go to console room and follow the protocol to run the task.

# Requirments

## Hardware
The following hardware is required for the experiment, in addition to the MR-machine itself.
> * A Computer with Matlab (min. version 2014a) to run the task paradigm, connected to the gustometer and MRI-I/O devices.
> * MRI-I/O devices: mirror-flip box, sync-box, HDMI for monitor, aux-cable for speaker.
> * Gustometer: 4x syringe pumps (NE-1000), 4x50ml syringes loaded with fluid (2xmilkshake, 2xtastelss solution) and respective tubing, mouth piece.
> * Mouth Piece, Milkshake setup with 4x syringes and tubes.

## Software
> * Matlab, Version at least 2014a
> * The code from this repository

# Protocol before MRI
> 1. Perform taste test with on-screen questionnaire by running Rating_Scales/FPST_Ratings.m or Rating_Scales/FPST_Ratings_with_function.m
> 2. Train the participant for the task by running Trainer/FPST_trainer.m, including asking the participant to intentionally wait and miss a choice.  

# Protocol in MRI
Once the participant is prepared:
> 1. Add entire "Code" directory to default Matlab-Startup, add folder and subfolders manually, or use load_directory.m
> 2. run configure_pumps_FPST.m
> 3. bring fluids to end of tubes and enter pump_back in console window to withdraw all fluids
> 4. run FPST.m, choose Proband and enter partipant data. The paradigm would then start.
> 5. The script pauses between phases to allow rest for the partipant and to allow us time to switch to the second sequence on the fMRI-computer (a technical constraint, instead of running both phases with one mri sequence). The script should pick up from where it left without needing to adjust.
> 6. After the paradigm finishes, the script automatically runs FPST_Ratings to perform the post-test taste test, and then present_accuracy to show the participant his general results.
Once finished, the participant can be taken out of the scanner and debriefed.
