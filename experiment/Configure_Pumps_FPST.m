% set up pumps parameters for San Antonio milkshake study
% this script runs 4 pumps 
% 0 = tasteless
% 1 = milkshake
% 2 = milkshake
% 3 = tasteless


%PumPdocumentation
%http://www.syringepump.com/download/NE-1000%20Syringe%20Pump%20User%20Manual.pdf
%(NE-1000 model and LA100 are the same)

%nomenclature is: fprintf (serialport , 'pump_number + command + value')
%so 'rat' changes delivery rate. 1-28 is rate value and 'mm' (ml/min) is the unit
%   'vol' changes delivered volume. .4 is 0.4ml (unit default is ml) 

%maximum rate for NE-1000 is "28mm" = 28ml/min = 0.467ml/sec
%we are delivering 0.3ml air in phase 1 and 0.4ml in phase 2
%pump is working 0.7/0.467 = 1.50sec and then withdrawing about = 0.64sec
%but real time is dependent on tube length
%empirical test actually showed about 1.1-1.2 seconds!

%withdraw time can be taken off next step (swallowing time) so no need to
%add in the calculation

s1=serial('com8','baudrate',19200,'databits',8,'terminator',13);
fopen(s1);
for i=0:3
    fprintf(s1,([num2str(i) 'dia26.59'])); %syringe inner diameter
	pause(.1);	
    fprintf(s1,([num2str(i) 'phn01']));   %BEGINNING OF PHASE 1 (before subject receives liquid, infuse to get the liquid to the end of the tube)
	pause(.1);
	fprintf(s1,([num2str(i) 'funrat'])); %function pumpint rate
    pause(.1);
    fprintf(s1,([num2str(i) 'rat28mm']));    %ml per hour converted into ml per minute (15mm equal to max rate) 
    pause(.1);
    fprintf(s1,([num2str(i) 'vol.2']));   %volume to be dispensed (takes 1.5 s)
	pause(.1);
	fprintf(s1,([num2str(i) 'dirinf']));    %dfirinf=pumping direction = infuse
	pause(.1);
	
    fprintf(s1,([num2str(i) 'phn02']));   %BEGINNING OF PHASE 2 (when subject is actually receiving the liquid)
    pause(.1);
    fprintf(s1,([num2str(i) 'funrat']));
    pause(.1);
    fprintf(s1,([num2str(i) 'rat28mm']));
    pause(.1);
    if i==0 || i==3
        fprintf(s1,([num2str(i) 'vol.6']));  %neutral solution. volume to be dispensed is .5 ml. de facto is 0.45ml
    else
        fprintf(s1,([num2str(i) 'vol.8']));  %milkshake volume to be dispensed is .5 ml. de facto is 0.
    end
    pause(.1);
    fprintf(s1,([num2str(i) 'dirinf'])); %direction infuse
    pause(.1);
    fprintf(s1,([num2str(i) 'phn03'])); %BEGINNING OF PHASE 3 (withdraw liquid to prevent any drippage)
    pause(.1);
	fprintf(s1,([num2str(i) 'funrat']));    
    pause(.1);
	fprintf(s1,([num2str(i) 'rat28mm']));   %WE WITHDRAW AT THE MAXIMUM RATE
    pause(.1);
	if i==0 || i==3
        fprintf(s1,([num2str(i) 'vol.4']));  %neutral solution. volume to be dispensed is ".4 ml". should be equal to phase01 but defacto this is gives a more stable result.
    else
        fprintf(s1,([num2str(i) 'vol.6']));  %milkshake. volume to be dispensed is ".9 ml". should be equal to phase01 but defacto this is gives a more stable result.
    end
    pause(.1);
	fprintf(s1,([num2str(i) 'dirwdr'])); % direction withdraw
    pause(.1);
	fprintf(s1,([num2str(i) 'phn04'])); %  begin phase 4 (stop)
    pause(.1);
	fprintf(s1,([num2str(i) 'funstp'])); % stop pump
end;

fclose(s1);


clear 

