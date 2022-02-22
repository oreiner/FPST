%%auxiliary function in result jobs (including 2nd level) to create con
%%vectors which are faster to read
%%e.g. con_vector(5,3,1) = [-1 0 1 0 0]
%%use negative value to skip unwanted positive 1 (5,-9,1) = [-1 0 0 0 0]
function [v] = con_vector(length, pos_one, pos_minusone)
    v = zeros(1,length);
    if pos_one>0
     v(pos_one)=1;
    end
    if exist('pos_minusone','var')
        if pos_minusone>0
            v(pos_minusone)=-1;
        end
    end      
end