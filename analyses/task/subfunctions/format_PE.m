%%auxiliary function for analyze task

function [pos_PE, neg_PE] = format_PE(PE)
    %%the only PE equal to zero should be from the transfer phase. can be
    %%ignored 
    PE = nonzeros(PE);
    
    for i = 1:numel(PE)
         if PE(i) > 0
                pos_PE(i) = PE(i);
            elseif PE(i) < 0
                neg_PE(i) = PE(i);
         end
    end
    
    pos_PE = nonzeros(pos_PE);
    neg_PE = nonzeros(neg_PE);
    
end