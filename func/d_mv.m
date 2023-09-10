function [tasks] = d_mv(A,d,l)
% Written by Doyeon Kim @ Jul. 2022
% IEEE Trans. on Information Theory
% Majority voting

fprintf('------- Majority Voting -------\n')
m = size(A,1);
tasks = zeros(m,length(l));
tasks_assign = cell(m,length(l));

for ii = 1:m
   candidateIdx = find(A(ii,:)~=0);
   for jj = 1:length(l)
       if jj == 1
           if length(candidateIdx) >= l(jj)*d
               tasks_assign{ii,jj} = datasample(candidateIdx,l(jj)*d,'replace',false);
           else
               if length(candidateIdx) == 0
                   tasks_assign{ii,jj} = [];
               else
%                    tasks_assign{ii,jj} = candidateIdx;
                   tasks_assign{ii,jj} = datasample(candidateIdx,l(jj)*d);
               end               
           end
       else
           if length(tasks_assign{ii,jj-1}) >= (l(jj-1)-l(jj))*d
               tasks_assign{ii,jj} = datasample(tasks_assign{ii,jj-1},l(jj)*d,'replace',false);
           else
               if length(tasks_assign{ii,jj-1}) == 0
                   tasks_assign{ii,jj} = [];
               else
%                    tasks_assign{ii,jj} = tasks_assign{ii,jj-1};
                   tasks_assign{ii,jj} = datasample(tasks_assign{ii,jj-1},(l(jj-1)-l(jj))*d);
               end
           end
       end
       tmpSum = sum(A(ii,tasks_assign{ii,jj}));
       if tmpSum > 0
           tasks(ii,jj) = 1;
       elseif tmpSum < 0
           tasks(ii,jj) = -1;
       else
           tasks(ii,jj) = 2*(rand<0.5)-1;
       end
   end
end


end

