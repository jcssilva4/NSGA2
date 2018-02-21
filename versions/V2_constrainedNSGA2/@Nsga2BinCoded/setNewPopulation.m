function [P_new,i] = setNewPopulation(obj)
    P_new = [];
    i = 1;
    while(length(P_new) + length(obj.F{1,i}) < obj.N)
        P_new = [P_new obj.F{1,i}];
        i = i + 1;
    end
end
