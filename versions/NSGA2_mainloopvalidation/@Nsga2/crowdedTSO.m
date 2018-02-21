function matingPool = crowdedTSO(obj, lastFrontIdx)
    matingPool = zeros(1,length(obj.Pt)); %sizeQt = sizePt 
    solutions = cell(2,length(matingPool)); %1st line-> ranks, 2nd line-> distances
    %get ranks and distances for each Pt individual
    solIdx = 1;%current sol index
    frontUB = 0; %front upper bound
    sum_nsolutions = 0;
    for f = 1:lastFrontIdx %loop over all fronts from 1 to lastFronIdx
        if(f~=lastFrontIdx)
            frontUB  = length(obj.F{1,f}); 
            sum_nsolutions = sum_nsolutions + frontUB;
        else
            frontUB = length(obj.Pt) -  sum_nsolutions; %calculate num of remaining solutions
        end
        for i = 1:frontUB
            solutions{1,solIdx} = f; %set rank
            %we don't need to store distances, since obj.Pt is sorted in
            %respect to distances (descendent order). We just need to compare indexes.
            %Therefore, if idx1 < idx2, then d1 >= d2
            solIdx = solIdx + 1;
        end
    end
    %tournament = generateTournament(solutions, length(distances));
    %{
    Tournament extracted from Deb's book (pg.239) for validation reasons
    %}
    tournament = [1 3;2 4;6 5;2 6;3 5;4 1;];
    auxMPoolIdx = 0; %auxiliar index mapping obj.Pt
    for i = 1:length(matingPool)
        auxMPoolIdx = getWinner(solutions,...
            tournament(i,1),tournament(i,2));
        matingPool(i) = obj.Pt(auxMPoolIdx);
    end
end

function tournament = generateTournament(solutions,nsols)
    tournament = zeros(length(solutions), 2);
    remainingIdxs = 1:nsols;%contains index of solutions which haven't been allocated to 2 duels
    duelCounter = zeros(1,nsols); %counts how many duels each solution is participating 
    tIdx = 1; %tournament index
    rng('twister');
    while(~isempty(remainingIdx))
        %get a duel
        if(length(remainingIdx) > 2)
            idx1 = randi([1 length(remainingIdx)],1,1);
            idx2 = idx1;
            while(idx2 == idx1)
                idx2 = randi([1 length(remainingIdx)],1,1);
            end
        else %only 2 indexes remaining...obviously they will duel with each other
            idx1 = remainingIdx(1); 
            idx2 = remainingIdx(2);
        end
        duelCounter(remainingIdxs(idx1)) = duelCounter(remainingIdxs(idx1)) + 1;
        duelCounter(remainingIdxs(idx2)) = duelCounter(remainingIdxs(idx2)) + 1;
        tournament(tIdx,1) = remainingIdxs(idx1);
        tournament(tIdx,2) = remainingIdxs(idx2);
        tIdx = tIdx + 1;
        %update remainingIdxs
        if(duelCounter(remainingIdxs(idx1)))
            setdiff(remainingIdxs, remainingIdxs(idx1)); end
        if(duelCounter(remainingIdxs(idx2)))
            setdiff(remainingIdxs, remainingIdxs(idx2)); end
    end
end

function winner = getWinner(solutions,s1, s2)
    sol1Wins = 1; %assume that 1 is the winner...
    if(solutions{1,s1} > solutions{1,s2}) %rank criterion: check if r1 < r2
        sol1Wins = 0; %solution 2 wins! r2 > r1
        %fprintf('\nsolution %d is the winner( rank%d > rank%d)',s2,s2,s1)
    else
        if(sol1Wins) %still assuming that 1 is the winner
            if(solutions{1,s1} == solutions{1,s2}) %if r1 == r2, s1 and s2 belongs to the same front
                if(s1 > s2) %distance criterion: check if d1 < d2
                    sol1Wins = 0;
                    %fprintf('\nsolution %d is the winner( d%d > d%d)',s2,s2,s1)
                else
                    %fprintf('\nsolution %d is the winner( d%d > d%d)',s1,s1,s2)
                end
            else
                %fprintf('\nsolution %d is the winner( rank%d > rank%d)',s1,s1,s2)
            end
        end
    end
    winner = (sol1Wins*s1) + ((1-sol1Wins)*s2);
end