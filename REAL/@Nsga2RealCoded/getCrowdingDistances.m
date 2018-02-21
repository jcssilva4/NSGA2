function [newParentPopIdxs, newParentPop, distances] = getCrowdingDistances(obj, lastFrontIdx, newPopIdxs)
    newParentPopIdxs = [];
    distances = [];
    fmax = zeros(1,obj.problem.m);
    fmin = zeros(1,obj.problem.m);
    %get fmax_m and fmin_m
    %fmax and fmin can be set as the population-maximum and
    %population-minimum of the mth obj function value
    for m = 1:obj.problem.m
        sortedVals = sort(obj.Rt(:,m),'descend');
        fmax(m) = sortedVals(1);
        fmin(m) = sortedVals(2*obj.N);
    end
    for f = 1:lastFrontIdx %loop over all fronts from 1 to lastFronIdx
        nsols = length(obj.F{1,f});
        F_Rt = zeros(nsols,obj.problem.m); %Rt for solutions of F
        for i = 1:nsols
            F_Rt(i,:) = obj.Rt(obj.F{1,f}(i),:);
        end
        di = zeros(1,nsols); %initialize dis
        for m = 1:obj.problem.m
            [~,sortedIdx] = sort(F_Rt(:,m), 'ascend'); %sorted index vector for m;
            %assign a large distance to the boundary solutions
            di(sortedIdx(1)) = sortedIdx(1) + Inf;
            di(sortedIdx(nsols)) =  di(sortedIdx(nsols)) + Inf;
            for i = 2:nsols-1 %loop over sortedIdx
                di(sortedIdx(i)) = di(sortedIdx(i)) + ...
                (F_Rt(sortedIdx(i+1),m) - F_Rt(sortedIdx(i-1),m))/...
                    (fmax(m) - fmin(m));
            end
        end
        [diVals_sorted,dsorted] = sort(di,'descend');
        nIndividuals = length(dsorted);
        if(f == lastFrontIdx) %if that's the last front
            remainingIndividuals = obj.N - length(newPopIdxs);
            nIndividuals = remainingIndividuals;
        end
        sols = zeros(1, length(nIndividuals));
        diVals = length(sols);
        for i = 1:nIndividuals
            sols(i) = obj.F{1,f}(dsorted(i));
            diVals(i) = diVals_sorted(i);
        end
        newParentPopIdxs = [newParentPopIdxs sols];
        distances = [distances diVals];
    end
    newParentPop = zeros(obj.N,obj.problem.nVars);
    for i = 1:obj.N
        if(newParentPopIdxs(i)>obj.N) %the i belongs to Qt
            newParentPop(i,:) = obj.Qt(newParentPopIdxs(i)-obj.N,:);
        else %then i belongs to Pt
            newParentPop(i,:) = obj.Pt(newParentPopIdxs(i),:);
        end
    end
end