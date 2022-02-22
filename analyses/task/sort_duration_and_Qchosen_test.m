function [durations Qchosens] = sort_duration_and_Qchosen_test(onsets , model)

     [values1,idx1] = intersect(onsets(2).cue,onsets(2).choose1, 'stable');
     [values2,idx2] = intersect(onsets(2).cue,onsets(2).avoid2, 'stable');
     [values12,idx12] = intersect(onsets(2).cue,nonzeros(onsets(2).not_12), 'stable');
   

        %%%%%%%%%%%%%%%%%%% choose avoid 1 resgressor with 3 pms
        
    Qchosens.pm3.choose1 = zeros(numel(onsets(2).cue),1); 
    Qchosens.pm3.avoid2 = zeros(numel(onsets(2).cue),1); 
    Qchosens.pm3.not_12 = zeros(numel(onsets(2).cue),1); 
      
        %%%%%%%%%%%%%%%%%%% choose avoid 3 resgressors with 1 pm each
    
     if size(model.Qchosen,2)==2
         Qchosens.choose1 = model.Qchosen(idx1,2);
         Qchosens.avoid2 = model.Qchosen(idx2,2);
         Qchosens.not_12 = model.Qchosen(idx12,2);
         
         Qchosens.pm3.choose1(idx1) = model.Qchosen(idx1,2);
         Qchosens.pm3.avoid2(idx2) = model.Qchosen(idx2,2);
         Qchosens.pm3.not_12(idx12) = model.Qchosen(idx12,2);
         
     else
         Qchosens.choose1 = model.Qchosen(idx1);
         Qchosens.avoid2 = model.Qchosen(idx2);
         Qchosens.not_12 = model.Qchosen(idx12);
         
         Qchosens.pm3.choose1(idx1) = model.Qchosen(idx1);
         Qchosens.pm3.avoid2(idx2) = model.Qchosen(idx2);
         Qchosens.pm3.not_12(idx12) = model.Qchosen(idx12);
     end
     
     durations.choose1 =  onsets(2).choicescreen(idx1) - onsets(2).choose1' + 0.3;
     durations.avoid2 =  onsets(2).choicescreen(idx2) - onsets(2).avoid2' + 0.3;
     durations.not_12 =  onsets(2).choicescreen(idx12) - nonzeros(onsets(2).not_12') + 0.3;
     
          %%%%%%%%%%%%%%%%%%%%% winwin 3 resgressors with 1 pm each
     
     [values1,idxwin] = intersect(onsets(2).cue,onsets(2).winwin, 'stable');
     [values2,idxlose] = intersect(onsets(2).cue,onsets(2).loselose, 'stable');
     [values12,idxwinlose] = intersect(onsets(2).cue,onsets(2).winlose, 'stable');
     
     if size(model.Qchosen,2)==2
         Qchosens.winwin = model.Qchosen(idxwin,2);
         Qchosens.loselose = model.Qchosen(idxlose,2);
         Qchosens.winlose = model.Qchosen(idxwinlose,2);
     else
        Qchosens.winwin = model.Qchosen(idxwin);
         Qchosens.loselose = model.Qchosen(idxlose);
         Qchosens.winlose = model.Qchosen(idxwinlose);
     end
     durations.winwin =  onsets(2).choicescreen(idxwin) - onsets(2).winwin' + 0.3;
     durations.loselose =  onsets(2).choicescreen(idxlose) - onsets(2).loselose' + 0.3;
     durations.winlose =  onsets(2).choicescreen(idxwinlose) - nonzeros(onsets(2).winlose') + 0.3;
end