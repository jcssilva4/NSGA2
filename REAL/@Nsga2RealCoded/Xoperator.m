%crossover operator -> simulated binary crossover(SBX) 
function [Qt1, Qt2] = Xoperator(obj, parent1, parent2)
    %set a random crossing site
    Qt1 = zeros(1,obj.problem.nVars); %child 1
    Qt2 = zeros(1,obj.problem.nVars); %child 2
    for i = 1:obj.problem.nVars
        Beta = getBeta(obj); %get Beta_i (spread factor)
        Qt1(i) = 0.5*(((1+Beta)*parent1(i)) + ((1-Beta)*parent2(i)));
        Qt2(i) = 0.5*(((1-Beta)*parent1(i)) + ((1+Beta)*parent2(i)));
    end
end

function Beta = getBeta(obj)
    Beta = 0;
    u = rand(); %u is like our cross site
    if(u <= 0.5)
        Beta = (2*u)^(1/(obj.Nc+1));
    else
        Beta = (1/(2*(1-u)))^(1/(obj.Nc+1));
    end
end