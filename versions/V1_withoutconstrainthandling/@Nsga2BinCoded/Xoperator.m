%crossover operator -> single-point X operator 
function [Qt1, Qt2] = Xoperator(obj, parent1, parent2)
    %set a random crossing site
    crossSite = randi([2 length(parent1)], 1, 1);
    stringsQt1 = [parent1(1:crossSite-1) parent2(crossSite:length(parent2))];
    stringsQt2 = [parent2(1:crossSite-1) parent1(crossSite:length(parent1))];
    Qt1 = Solution(obj.Pt{1,1}.nBits, obj.problem, stringsQt1);
    Qt2 = Solution(obj.Pt{1,1}.nBits, obj.problem, stringsQt2);
end