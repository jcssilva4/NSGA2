function initialPop = getInitialPop(obj, nIndividuals) %returns vector of solutions
    initialPop = zeros(nIndividuals, obj.problem.nVars); %initialization
    for individual = 1:nIndividuals
        for var = 1:obj.problem.nVars
            initialPop(individual, var) = obj.problem.lb(var) + ...
                (rand()*obj.problem.ub(var));
        end
    end
end
