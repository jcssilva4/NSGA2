function  Qt = getOffspring(obj)
    Qt = zeros(obj.N,obj.problem.nVars);
    i = 1;
    %fprintf('\nCrossover')
    if(obj.pX > 0) %is there a Xover chance?
        while(i <= obj.N)
            if(rand() <= obj.pX) %crossover will happen
                [Qt(i,:), Qt(i+1,:)] = Xoperator(obj, obj.Pt(i,:), obj.Pt(i+1,:));
            else %simply copy parents
                Qt(i,:) = obj.Mpool(i,:);
                Qt(i+1,:) = obj.Mpool(i+1,:);
            end
            i = i + 2;
        end
    end
    %{
    if(obj.pM > 0) %is there a mutation chance?
        %fprintf('\nMutation')
        L = 1; %auxiliar for the mutation clock operator (this cannot be reseted)
        %why L can't be reseted? because when L>length(binString)
        %the next var to be mutated in the next individual should be
        % L - (1-individual_index)*length(binString) in order to respect the
        % mutation clock
        mutated = 1; %just to initialize the clock (this variable is used to activate the clock)
        i = 1;
        while(i <= obj.N)
            [stringsQt, i, L, mutated] = obj.Moperator(i, L, mutated, Qt{1,i}.binString);
            if(mutated)
                if(i>1), Qt{1,i-1} = Solution(obj.Pt{1,1}.nBits, obj.problem, stringsQt); end
            end
        end
    end
    %}
end