%F is a cell containing F1, F2, F3...
function [Fronts,Rt] = nonDominatedSorting(obj)
    Fronts = cell(1,1);
    nfronts = 0;
    %do Rt = P_t U Q_t
    Rt = getRt(obj);
    %get fronts
    tempRt = Rt; %tempRt is used to get the NDFronts
    allIdx = []; %auxiliar stop criterion. This will contain all indexes of Rt 
    while(length(allIdx)<obj.N) %you don't need to compute all fronts...just use as many fronts as necessary
        idx = getNDFront(obj, allIdx, Rt);
        allIdx = union(allIdx, idx);
        nfronts = nfronts + 1;
        Fronts{1,nfronts} = idx;
    end
end
function Rt = getRt(obj)
    %this Qt was extracted from table.20 of Deb's 2003book
    f = zeros(1,obj.problem.m); %auxiliar vector of objectives
    Rt = zeros(2*obj.N,obj.problem.m); %initialize Rt
    for i = 1:obj.N
        for k = 1:obj.problem.m
            f(k) = obj.problem.getFitness(k,obj.Pt{1,i}.realVals); %get objective fitness from parents
        end
        Rt(i,:) = f(:);
    end
    for i = 1:obj.N
        for k = 1:obj.problem.m
            f(k) = obj.problem.getFitness(k,obj.Qt{1,i}.realVals); %get objective fitness from parents
        end
        Rt(i+obj.N,:) = f(:);
    end
end

function nonDominated = getNDFront(obj, allIdx, Rt) 
    %get non-dominated solutions
    [nsols, ~] = size(Rt);
    dominated = 0;
    %understanding domination
    %{
    Example
    Rt = [1 1; 1 2; 2 3; 3 4]
    we need a draw counter and a loss counter
    solution 1 = solution 2 in respect to F1 (1 draw)
    solution 1 dominates solution 2 in respect to F2 (1 WIN)
    soltuion 1 is non dominated (and solution 2 is dominated by sol 1)
    remeber that sola dominates solb when it wins in at least 1 objective
    %}
    countcrit = 0; %count losses in comparissons
    countdraws = 0; %count draws in comparissons
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
                                %fprintf('\n%d dominates %d in respect to F%d' , j, i, m);
                            else
                                if(fm_i - fm_j == 0)
                                    countdraws = countdraws + 1; 
                                end 
                            end
                            if(countdraws == obj.problem.m) %i is equal to j 
                            else
                                if(countcrit + countdraws == obj.problem.m) %if i couldn't win in any obj
                                    %fprintf('\n->%d dominates %d' , j, i);
                                    dominated = 1;
                                end
                            end
                        end
                    end
                    countcrit = 0;
                    countdraws = 0;
                end
            end
            if(~dominated)
                nonDominated = [nonDominated i]; 
                %fprintf('\n\n** %d is nondominated **\n',i);
            end
            dominated = 0;
        end
    end
end