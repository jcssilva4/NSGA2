clear
clc
fprintf('\n starting NSGA2 test...\n')
%{
heuristic setup test
heuristic = Nsga2(1);
heuristic2 = Nsga2(30);
heuristic.mutationProb = heuristic.setMutationProb(0.5);
heuristic2.mutationProb = heuristic2.setMutationProb(0.5);
%}
%{
getF1F2 test
problem = Problem();
[problem.F1, problem.F2] = problem.getF1F2([1 0]);
%}

%define your optimisation problem
problem = Problem([-1 -1], 2);
%create initial population - extracted from table.20 of Deb's 2003book
%you're going to create a population
initialPop = [0.31 0.89; 0.43 1.92; 0.22 0.56; 0.59 3.63; 0.66 1.41; 
                0.83 2.51];
%{
%checking values of f1 and f2
Rt = [];
for i = 1:6
    x = initialPop(i,:);
    fvector = [problem.getFitness(1,x), problem.getFitness(2,x)];
    Rt = [Rt; fvector]
end
%}
%create an instance of NSGA-II
mobjga = Nsga2(problem, initialPop);
%start loop
[mobjga.F ,mobjga.Rt] = mobjga.nonDominatedSorting(); %remember to exclude Qt from here!
%initialize P(t+1) and the total number of fronts needed to create P(t+1)
[newPopIdxs, lastFrontIdx] = mobjga.setNewPopulation();
%get full P(t+1) 
[mobjga.Pt, distances] = mobjga.getCrowdingDistances(lastFrontIdx, newPopIdxs); 
%get mating pool
mobjga.Mpool = mobjga.crowdedTSO(lastFrontIdx); %remember to exclude tournament from here!
matingPool = mobjga.Mpool
%get Q(t+1)
%crossover operator
%mutation opeator

fprintf('\nDone!\n');
