%mutation operator -> bitwise M operator with mutation clock operator
%mutation clock operator: reduces complexity from O(n) to O(1/pM)...on
%average, mutation will occur in 1/pM variables...
function [Qt, currentIndividual, L, mutated] = Moperator(obj, i_in, l_in, mut_in, qtX)
    %qtX -> offspring after crossover
    %currIndivid -> individual to be mutated
    stringsQt = qtX;
    currentIndividual = i_in;
    L = l_in;
    if(mut_in), L = getNextOccurrence(obj.pM,l_in); end %if mutated, proceed...
    currentIdx = L - ((currentIndividual - 1)*length(stringsQt));
    if(currentIdx <= length(stringsQt))
        if(stringsQt(currentIdx)), stringsQt(currentIdx) = 0; %if it is 1, change to 0
        else, stringsQt(currentIdx) = 1;  end %if it is 0, change to 1
        mutated = 1;
    else
        mutated = 0;
        currentIndividual = currentIndividual + 1; %move to the next individual
    end
    Qt = stringsQt;
end

function L = getNextOccurrence(pM,currentL)
    u = 1;
    while(u == 1) %avoids log0
        u = rand();
        L = -(1/pM)*(log(1-u)); %mutation clock operator
    end
    L = round(L) + currentL;
end