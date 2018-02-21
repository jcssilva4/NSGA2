function finalFront = getFinalFront(obj)
    finalFront = zeros(obj.N, obj.problem.m);
    for i = 1:obj.N
        for k = 1:obj.problem.m
            finalFront(i,k) = obj.problem.getFitness...
                (k,obj.Pt{1,i}.realVals); %get objective fitness from parents
        end
    end
%{
 finalFront = zeros(2*obj.N, obj.problem.m);
    for i = 1:2*obj.N
        for k = 1:obj.problem.m
            finalFront(i,k) = obj.Rt(i,k); %get objective fitness from parents
        end
    end
%}
end