%{
A Fast Elitist Multiobjective Genetic Algorithm: NSGA-II, Deb et al (2002)

Procedure (Deb's 2003book, pg.234):

1. Elitism: 
Combine parent (P_t) and offspring(Q_t) populations and create R_t = P_t U
Q_t. Perform a non-dominated sorting to Rt and identify different fronts:
Fi, i = 1,2,...
obs.: sizeP_t = N, sizeQ_t = N, sizeR_t = 2N

2. Set new population P_t+1 = []. Set a counter i = 1. Until |P_t+1| +
|F_i| < N, perform P_t+1 = P_t+1 U F_i and i = i + 1.
obs.: sizeP_t+1 = N.

3. Perform the Crowding-sort (F_i < c) procedure (described on pg.
236) and include the most widely spread (N - |P_t+1|) solutions by using
the crowding distance values in sorted F_i to P_i+1

4. Create offspring population Q_t+1 from P_t+1 by using the crowded
tournament selection, crossover and mutation operators
%}

classdef Nsga2BinCoded
    properties
        problem; %problem object  
        N; %size of parent and offspring populations
        F; %current fronts 
        Rt; %current Rt
        Pt; %current Parent population
        Mpool; %current mating pool
        Qt; %current offspring  population
        pX; %crossover probability
        pM; %mutation probability
        mpCandidates; %mating pool candidates
        finalFront; %final solution
    end
    methods
        function obj = Nsga2BinCoded(nIndividuals, nBits, probs, problem)
            obj.N = nIndividuals; %get number of initial solutions and number of vars
            obj.pX = probs(1); obj.pM = probs(2); %get pX and pM
            obj.problem = problem; %get the vector of objfunctions, constraints...
            MAXDV = Solution.setgetMAXDV(nBits); %set static maxDV
            %fprintf('\ngenerate random parents...');
            obj.Pt = obj.getInitialPop(nBits, nIndividuals); %get initial population of sols
            %fprintf('ok\nnon-dominated sorting...');
            [obj.F ,obj.Rt] = obj.P0nonDominatedSorting(); 
            %fprintf('ok\nset total number of fronts needed to continue building P0...');
            lastFrontIdx = length(obj.F);
            for i = 1:lastFrontIdx
                obj.mpCandidates = [obj.mpCandidates obj.F{1,i}];
            end
            %fprintf('ok\nget mating pool...');
            obj.Mpool = obj.rankTSO(lastFrontIdx); 
            %fprintf('ok\nget Q0...');
            obj.Qt = obj.getOffspring();
            %fprintf('ok\n');
        end
        [Fronts, Rt] = nonDominatedSorting(obj);
        [Fronts, Rt] = P0nonDominatedSorting(obj); %used to build P0 and Q0
        [P_new, FrontIdx] = setNewPopulation(obj);
        [newParentPopIdxs, newParentPop, distances] = getCrowdingDistances(obj, FrontIdx, newPopIdx);
        matingPool = crowdedTSO(obj, lastFrontIdx); 
        matingPool = rankTSO(obj, lastFrontIdx); 
        initialPop = getInitialPop(obj, nBits, nIndividuals);
        Qt = getOffspring(obj);
        finalFront = getFinalFront(obj);
        [Qt, currentIndividual, L, mutated] = Moperator(obj, i_in, l_in, mut_in, qtX);
    end
    methods(Static)
    end
end