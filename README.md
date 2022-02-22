# Food Probabilistic Selection Task 
> ### Pilot-Study to "16-426 Formation of approach and avoidance behavior in obese adults"

## Abstract

> Provide here a general overview of your project.

## Motivation

> In this section, explain the questions you want to answer with your experiement, and what are your predictions.

### Questions

### Hypotheses

## Experimental procedure

* After informed consent was obtained, subjects were weighed and measured (including a bioelectrical impedance analysis)
* Blood was taken and sent for analysis for glucose and insulin.
* Subjects were taking to rating computer and a taste-test was conducted:
>>in free form for the neutral solution selection

>>with FPST_Ratings.m for milkshake selection (with preintervention setting)   
* On rating computer, subjects were briefly trained on the task, using FPST_Trainer.m 
* Syringes and Pumps were set up (also using pump_back.m function) and subject was put into MRI-Machine
* Subject performed task in fMRI, running FPST.m
* Subject performed Rating again, this time in MRI (postintervention setting)

### Tested population

 30 Healthy subjects with BMI within normal range (future study is planned to compare healthy subjects with obese subjects)

### Experimental design

The code to run the experiment is [here](experiment/README.md) and collected data are listed [here](data/README.md).

## Analyses

* Task logfiles were formatted and analyzed for reinforcement learning results: choose A / avoid B trials, high conflict trials, and AB/CD/EF trials in test phase. results were statistically analyzed across subjects
* fMRI data were analyzed in SPM using the formatted data from the logfiles
