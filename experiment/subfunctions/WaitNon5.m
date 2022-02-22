function WaitNon5()

%%prepare non5 response for wait screens after block 1 / test end
non5 = KbName('KeyNames');
%idx1 = find(strcmp({non5{:}}, 'left_mouse')) ;
%idx2 = find(strcmp({non5{:}}, 'right_mouse')); 
idx3 = find(strcmp({non5{:}}, '5%'));
idx4 = find(strcmp({non5{:}}, '5'));
non5 =  1:numel(KbName('KeyNames'));
non5(idx4) = []; non5(idx3) = []; %non5(idx2) = []; %non5(idx1) = [];
KbTriggerWait(non5);

end