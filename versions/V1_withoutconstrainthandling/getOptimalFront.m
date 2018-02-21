function optimalFront = getOptimalFront(gaobj)
    lb = [0.1 0];
    ub = [1 5];
    npoints = 150;
    optimalFront = zeros(npoints,gaobj.problem.m);
    solcounter = 1;
    for lambda = 0.1:0.1/npoints:1
        optimalFront(solcounter,1) = lambda;
        optimalFront(solcounter,2) = 1/lambda;
        solcounter = solcounter + 1;
    end
end

function f = setF(x, lambda)
    f = (lambda*x(1)) + ((1-lambda)*((1+x(2))/x(1)));
end