function matingPool = rankTSO(obj, lastFrontIdx)
    matingPoolIdxs = zeros(1,obj.N); %sizeQt = sizePt 
    solutions = cell(2,length(matingPoolIdxs)); %1st line-> ranks, 2nd line-> distances
    %get ranks and distances for each Pt individual
    solIdx = 1;%current sol index
    frontUB = 0; %front upper bound
    sum_nsolutions = 0;
    for f = 1:lastFrontIdx %loop over all fronts from 1 to lastFronIdx
        if(f~=lastFrontIdx)
            frontUB  = length(obj.F{1,f}); 
            sum_nsolutions = sum_nsolutions + frontUB;
        else
            frontUB = length(obj.mpCandidates) -  sum_nsolutions; %calculate num of remaining solutions
        end
        for i = 1:frontUB
            solutions{1,solIdx} = f; %set rank
            %we don't need to store distances, since obj.Pt is sorted in
            %respect to distances (descendent order). We just need to compare indexes.
            %Therefore, if idx1 < idx2, then d1 >= d2
            solIdx = solIdx + 1;
        end
    end
    tournament = generateTournament(solutions, length(matingPoolIdxs));
    for i = 1:length(matingPoolIdxs)
        matingPoolIdxs(i) = obj.mpCandidates(getWinner(solutions,...
            tournament(i,1),tournament(i,2)));
    end
    %get mating pool solution vector
    matingPool = cell(1,obj.N);
    for i = 1:obj.N
        if(matingPoolIdxs(i)>obj.N) %the i belongs to Qt
            matingPool{1,i} = obj.Qt{1,matingPoolIdxs(i)-obj.N};
        else %then i belongs to Pt
            matingPool{1,i} = obj.Pt{1,matingPoolIdxs(i)};
        end
    end
end

function tournament = generateTournament(solutions,nsols)
    tournament = zeros(length(solutions), 2);
    remainingIdxs = 1:nsols;%contains index of solutions which haven't been allocated to 2 duels
    duelCounter = zeros(1,nsols); %counts how many duels each solution is participating 
    tIdx = 1; %tournament index
    %rng('twister');
    while(~isempty(remainingIdxs))
        %get a duel
        if(length(remainingIdxs) > 2)
            idx1 = randi([1 length(remainingIdxs)],1,1);
            idx2 = idx1;
            while(idx2 == idx1)
                idx2 = randi([1 length(remainingIdxs)],1,1);
            end
            duelCounter(remainingIdxs(idx1)) = duelCounter(remainingIdxs(idx1)) + 1;
            duelCounter(remainingIdxs(idx2)) = duelCounter(remainingIdxs(idx2)) + 1;
            tournament(tIdx,1) = remainingIdxs(idx1);
            tournament(tIdx,2) = remainingIdxs(idx2);
            %update remainingIdxs
            %remainingIdxs
            %idx1
            %idx2
            %duelCounter
            element1 = remainingIdxs(idx1);
            element2 = remainingIdxs(idx2);
            if(duelCounter(element1) == 2)
                remainingIdxs = setdiff(remainingIdxs, element1); end
            if(duelCounter(element2) == 2)
                 remainingIdxs = setdiff(remainingIdxs, element2); end
            tIdx = tIdx + 1;
        else %only 2 indexes remaining...obviously they will duel with each other
            if(ismember(0,duelCounter)) %for cases when there are two remaining individuals not included in any duel yet and others...
                %start again
                %duelCounter
                remainingIdxs = 1:nsols;%contains index of solutions which haven't been allocated to 2 duels
                duelCounter = zeros(1,nsols); %counts how many duels each solution is participating 
                tIdx = 1; %tournament index
            else
                tournament(tIdx,1) = remainingIdxs(1);
                tournament(tIdx,2) = remainingIdxs(2);
                duelCounter(remainingIdxs(1)) = duelCounter(remainingIdxs(1)) + 1;
                duelCounter(remainingIdxs(2)) = duelCounter(remainingIdxs(2)) + 1;
                %duelCounter
                remainingIdxs = [];
            end
        end
    end
end

function winner = getWinner(solutions,s1, s2)
    sol1Wins = 1; %assume that 1 is the winner...
    if(solutions{1,s1} > solutions{1,s2}) %rank criterion: check if r1 < r2
        sol1Wins = 0; %solution 2 wins! r2 > r1
        %fprintf('\nsolution %d is the winner( rank%d > rank%d)',s2,s2,s1)
    end
    winner = (sol1Wins*s1) + ((1-sol1Wins)*s2);
end