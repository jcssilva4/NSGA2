classdef Solution
    properties
        binString %chromossome
        nBits %nBits of each var
        realVals %vector containing real values of each var
    end
    methods
        function obj = Solution(nBits, problem, binStr)
            obj.nBits = nBits;
            if nargin < 3 %new pop member
                obj.binString = randi([0 1],1,nBits*problem.nVars);
            else %offspring member
                obj.binString = binStr;
            end
                obj.realVals = obj.getRealVal(problem);
        end
        function r = getRealVal(obj, problem)
            MAXDV = Solution.setgetMAXDV; %get maxDV
            for i = 1:problem.nVars   
                stringLB = (obj.nBits*(i-1)) + 1;
                stringUB = obj.nBits*i;
                A = MAXDV/(problem.ub(i)-problem.lb(i));
                string_i = obj.binString(1,stringLB:stringUB);
                bi2de(string_i);
                r(i) = (bi2de(string_i)/A) + problem.lb(i);
            end
        end
    end
    methods(Static)
        function out = setgetMAXDV(nBits) %define maxDV as a static integer
            persistent maxDV; %max real number range with nBits
            if nargin
                maxDV = 0;
                for i = 1:nBits
                    maxDV = maxDV + (2^(i-1));
                end
            end
            out = maxDV;
        end
    end
end