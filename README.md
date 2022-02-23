# Food Probabilistic Selection Task 
> ### This study was a decision making experiment performed in an fMRI setting, performed on healthy volunteers and intended to be a pilot for further studies comparing cohorts of obese vs. lean adults.
>> #### For a more in depth review of the motivation, methods and results, see my thesis (To be added later) 
>> #### This study was done as my dissertation project in the [Multimodal Neuroimaging Cologne research group](https://mmni.de/) of the van-Eimeren lab.

## Abstract

to be added once the thesis is published.

## Experimental procedure

1. After informed consent was obtained, the participants were weighed and measured (including a bioelectrical impedance analysis)
2. Blood samples were taken and sent for analysis for glucose and insulin.
3. The participants were taken to computer and a taste-test was conducted:
>> * with an on-screen questionnaire for four different milkshake flavours
>> * without the on-screen questionnaire for four different neutral tasting solution
4. The participants were trained on the task paradigm with a simulator on the same computer.
5. The participants were then taken to the MRI-machine and perfomed the task while being scanned
 
### Experimental design

The code to run the experiment is [here](experiment/README.md) and collected data are listed [here](data/README.md).

## Analyses
Analyses were performed by running the scripts found [here](experiment/README.md) 
* Task logfiles were formatted and analysed for accuracy, response time and reinforcement learning using a Q-Learning model results.
* fMRI data were preprocessed in FSL and SPM, and then analysed for statistical maps of brain activity in SPM using the formatted data from the logfiles
