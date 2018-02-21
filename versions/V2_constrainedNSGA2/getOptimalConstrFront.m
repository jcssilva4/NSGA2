function optimalConstrFront = getOptimalConstrFront(gaobj)
    npoints = 80;
    optimalConstrFront = zeros(2*npoints,gaobj.problem.m);
    solcounter = 1;
    for x1 = 0.39:(0.67-0.39)/npoints:0.67
        x = [x1 (6-(9*x1))];
        optimalConstrFront(solcounter,1) = gaobj.problem.getFitness(1, x);
        optimalConstrFront(solcounter,2) = gaobj.problem.getFitness(2, x);
        solcounter = solcounter + 1;
    end
    for x1 = 0.67:(1-0.67)/npoints:1
        x = [x1 0];
        optimalConstrFront(solcounter,1) = gaobj.problem.getFitness(1, x);
        optimalConstrFront(solcounter,2) = gaobj.problem.getFitness(2, x);
        solcounter = solcounter + 1;
    end
end
