# Food Probabilistic Selection Task 
> ### This study was a decision making experiment performed in an fMRI setting, performed on healthy volunteers and intended to be a pilot for further studies comparing cohorts of obese vs. lean adults.
>> #### For a more in depth review of the motivation, methods and results, see my thesis (To be added later) 
>> #### This study was done as my dissertation project in the [Multimodal Neuroimaging Cologne research group](https://mmni.de/) of the van-Eimeren lab.

## Abstract

One of the main challenges for global public health in the modern world is the rising prevalence of obesity. Obtaining a better understanding of the dysregulated feeding behaviour that leads to obesity, by investigating the decision making and learning processes underlying it, could advance our capabilities in battling the obesity epidemic. 
Consequently, our aim in this study was to design and validate an experiment that could evaluate these processes.

To do so, we examined ten healthy participants using a modified version of the "[probabilistic selection task](https://www.science.org/doi/10.1126/science.1102941)" (PST)  - an established behavioural task for evaluating learning behaviour. In the first phase of this task, the participants are presented with pairs of visual cues and are required to select one cue on each trial. Each cue has a different win probability and participants are tasked with identifying the more rewarding options. We modified the paradigm by delivering gustatory stimuli as a replacement for monetary rewards, to assess the effect of nutritional rewards on the learning behaviour. 
We subsequently analysed the behavioural results with computational modelling and combined this with imaging data simultaneously acquired with an functional magnetic resonance imaging (fMRI) multiband sequence.

Results of the experiment showed this setup can indeed be used to perform the PST with gustatory feedback. 
However, our fMRI-settings were supoptimal and while we found the main effects we expected in the visual, motor and sensory cortices, we did not detect the neurological activity we expected in the reward system, which was central to our scientific question. We suspect the optimised system could indeed show these effects as well, and thus an optimised system could be used in further studies to improve our understanding of the neurobiological mechanisms of learning that lead to obesity and elucidate the role of food as a distinctive reinforcer. 

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
