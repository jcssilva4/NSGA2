%{
A Fast Elitist Multiobjective Genetic Algorithm: NSGA-II, Deb et al (2002)

Procedure (Deb's 2003book, pg.234):

1. Combine parent (P_t) and offspring(Q_t) populations and create R_t = P_t U
Q_t. Perform a non-dominated sorting to Rt and identify different fronts:
Fi, i = 1,2,...
obs.: sizeP_t = N, sizeQ_t = N, sizeR_t = 2N

2. Set new population P_t+1 = []. Set a counter i = 1. Until |P_t+1| +
|F_i| < N, perform P_t+1 = P_t+1 U F_i and i = i + 1.
obs.: sizeP_t+1 = N.

3. Perform the Crowding-sort (F_i < c) procedure (described below on page
236) and include the most widely spread (N - |P_t+1|) solutions by using
the crowding distance values in sorted F_i to P_i+1

4. Create offspring population Q_t+1 from P_t+1 by using the crowded
tournament selection, crossover and mutation operators
%}

classdef Nsga2
    properties
        problem; %problem object  
        initialPop; %vector of solutions
        N; %size of parent and offspring populations
        nVars;
        F; %current fronts 
        Rt; %current Rt
        Pt; %current Parent population
        Mpool; %current mating pool
        Qt; %current offspring  population
        mutationProb;
    end
    methods
        function obj = Nsga2(problem, initialPop)
            obj.problem = problem; %get the vector of objfunctions, constraints...
            [obj.N,obj.nVars] = size(initialPop); %get number of initial solutions and number of vars
            obj.Pt = initialPop;
        end
        [Fronts, Rt] = nonDominatedSorting(obj) 
        [P_new, FrontIdx] = setNewPopulation(obj);
        [newParentPop, distances] = getCrowdingDistances(obj, FrontIdx, newPopIdx);
        matingPool = crowdedTSO(obj, distances, lastFrontIdx); %change this... now it will be called crowding distance!
    end
    methods(Static)
    end
end