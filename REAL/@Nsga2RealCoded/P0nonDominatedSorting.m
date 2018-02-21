%F is a cell containing F1, F2, F3...
function [Fronts,Rt] = P0nonDominatedSorting(obj)
    Fronts = cell(1,1);
    nfronts = 0;
    %do Rt = P_t U Q_t
    [Rt, OCV, feasible] = get_Rt_OCV_feasibility(obj);
    %get fronts
    allIdx = []; %auxiliar stop criterion. This will contain all indexes of Rt 
    while(length(allIdx)<obj.N)
        idx = getNDFront(obj, allIdx, Rt, OCV, feasible);
        allIdx = union(allIdx, idx);
        nfronts = nfronts + 1;
        Fronts{1,nfronts} = idx;
    end
end

function [Rt,OCV,feasible] = get_Rt_OCV_feasibility(obj)
    f = zeros(1,obj.problem.m); %auxiliar vector of objectives
    Rt = zeros(obj.N,obj.problem.m); %initialize Rt
    OCV = zeros(1, obj.N); %initialize OCV for all sols
    feasible = ones(1, obj.N); %assuming that all sols are feasible
    for i = 1:obj.N
        for k = 1:obj.problem.m
            f(k) = obj.problem.getFitness(k,obj.Pt(i,:)); %get objective fitness from parents
        end
        Rt(i,:) = f(:);
        OCV(i) = obj.problem.getConstrViolation(obj.Pt(i,:));%i constraint violation
        if(OCV(i)>0), feasible(i) = 0; end %i is not feasible
    end
end

function nonDominated = getNDFront(obj, allIdx, Rt, OCV, feasible) 
    %get non-dominated solutions
    [nsols, ~] = size(Rt);
    dominated = 0;
    nonDominated = []; %list containing non dominated sols!
    for i = 1:nsols
        if(~ismember(i,allIdx)) %if i is not contained in any Front...
            for j = 1:nsols
                if(~ismember(j,allIdx)) %if j is not contained in any Front...
                    if(~dominated) 
                        if((~feasible(i)) && (~feasible(j))) %if both are infeasible
                            if(OCV(i) > OCV(j))
                                %fprintf('\n%dOCV > %dOCV (%d,%d infeasible), then %d is dominated',i,j,i,j,i);
                                dominated = 1; %i is constrain-dominated by j in respect to OCV
                            end
                        else
                            if((~feasible(i)) && feasible(j)) %if i is infeasible but j is feasible
                                %fprintf('\n%d is infeasible and %d is feasible, then %d is dominated',i,j,i);
                                dominated = 1; %i is constrain-dominated by j in respect to feasibility
                            else 
                                if(feasible(i) && feasible(j)) %if both are feasible
                                    dominated = ObjDominated(obj, Rt, i, j); %check domination in the usual sense
                                end
                            end
                        end
                    end
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

function dominated = ObjDominated(obj, Rt, i, j) %check domination in respect to objectives
    %understanding objective domination
    %{
    Example
    Rt = [1 1; 1 2; 2 3; 3 4]
    we need a draw counter and a loss counter
    solution 1 = solution 2 in respect to F1 (1 draw)
    solution 1 dominates solution 2 in respect to F2 (1 WIN)
    soltuion 1 is non dominated (and solution 2 is dominated by sol 1)
    remeber that sola dominates solb when it wins in at least 1 objective
    %}
    dominated = 0; %assume that i is not dominated by j
    countcrit = 0; %count losses in comparissons
    countdraws = 0; %count draws in comparissons
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