function matingPool = constrainedTSO(obj, lastFrontIdx)
    matingPoolIdxs = zeros(1,obj.N); %sizeQt = sizePt 
    %get mating pool solution vector
    matingPool = cell(1,obj.N);
    for i = 1:obj.N
        if(matingPoolIdxs(i)>obj.N) %the i belongs to Qt
            matingPool{1,i} = obj.Qt{1,matingPoolIdxs(i)-obj.N};
        else %then i belongs to Pt
            matingPool{1,i} = obj.Pt{1,matingPoolIdxs(i)};
        end
    end
end