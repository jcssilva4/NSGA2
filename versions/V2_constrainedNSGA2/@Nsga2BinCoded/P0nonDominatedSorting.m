%F is a cell containing F1, F2, F3...
function [Fronts,Rt] = P0nonDominatedSorting(obj)
    Fronts = cell(1,1);
    nfronts = 0;
    %do Rt = P_t U Q_t
    Rt = getRt(obj);
    %get fronts
    tempRt = Rt; %tempRt is used to get the NDFronts
    allIdx = []; %auxiliar stop criterion. This will contain all indexes of Rt 
    while(length(allIdx)<obj.N)
        idx = getNDFront(obj, allIdx, Rt);
        allIdx = union(allIdx, idx);
        nfronts = nfronts + 1;
        Fronts{1,nfronts} = idx;
    end
end
function Rt = getRt(obj)
    %this Qt was extracted from table.20 of Deb's 2003book
    f = zeros(1,obj.problem.m); %auxiliar vector of objectives
    Rt = zeros(obj.N,obj.problem.m); %initialize Rt
    for i = 1:obj.N
        for k = 1:obj.problem.m
            f(k) = obj.problem.getFitness(k,obj.Pt{1,i}.realVals); %get objective fitness from parents
        end
        Rt(i,:) = f(:);
    end
end

function nonDominated = getNDFront(obj, allIdx, Rt) 
    %get non-dominated solutions
    [nsols, ~] = size(Rt);
    dominated = 0;
    countcrit = 0; %count losses in an objective
    nonDominated = []; %list containing non dominated sols!
    for i = 1:nsols
        if(~ismember(i,allIdx)) %if i is not contained in any Front...
            for j = 1:nsols
                if(~ismember(j,allIdx)) %if j is not contained in any Front...
                    if(~dominated) 
                        for m = 1:obj.problem.m%loop over objectives
                            %j dominates i?
                            fm_i = obj.problem.prefDir(m)*Rt(i,m);
                            fm_j = obj.problem.prefDir(m)*Rt(j,m);
                            if(fm_i - fm_j < 0) %check objective m
                                countcrit = countcrit + 1; 
                                %fprintf('%d dominates %d in respect to F%d\n' , j, i, m);
                            end 
                            if(countcrit > 1) 
                                %fprintf('%d dominates %d\n' , j, i);
                                dominated = 1;
                            end
                        end
                    end
                    countcrit = 0;
                end
            end
            if(~dominated), nonDominated = [nonDominated i]; end
            dominated = 0;
        end
    end
end