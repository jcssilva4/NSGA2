function initialPop = getInitialPop(obj, nBits, nIndividuals) %returns vector of solutions
    initialPop = cell(1, nIndividuals); %initialization
    for individual = 1:nIndividuals
        initialPop{individual} = Solution(nBits, obj.problem);
    end
end
