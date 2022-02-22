%% after fluids from all 4 pumps are brought to end of tube, make them all run phase 03
% to pump back the dead volume 
function pump_back
  s1=serial('com8','baudrate',19200,'databits',8,'terminator',13);
  fopen(s1);
  for i = 0:3
    fprintf(s1,[num2str(i) 'run03']);
  end
  fclose(s1);
end
