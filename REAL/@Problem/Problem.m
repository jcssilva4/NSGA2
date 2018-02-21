classdef Problem
    properties
        prefDir; %if prefDir = 1, its max; if prefDir = -1, its min. 
        m; %number of objectives
        F; %cell of functions
        OCV; %overallconstraint violation
        nconstr; %number of constraints
        FMAX; %vector containing max possible values for each objectivefunc
        FMIN;%vector containing min possible values for each objectivefunc
        lb; %lower boundary
        ub; %upper boundary
        nVars;%number of variables
    end
    methods
        function obj = Problem(prefDir, nv)
            obj.nVars = nv;
            %set objective functions
            obj.prefDir = prefDir;
            obj.m = length(prefDir);
            obj.F = cell(2,obj.m); %line 1: original dir/line2: inverse dir
            obj.F{1,1} = @(x)Problem.setF1(x,1,0,1); %min (dir = 1)
            obj.F{2,1} = @(x)Problem.setF1(x,1,0,-1); %max (dir = -1)
            obj.F{1,2} = @(x)Problem.setF2(x,1,1,1); %min (dir = 1)
            obj.F{2,2} = @(x)Problem.setF2(x,1,1,-1); %max (dir = -1)
            %set number of constraints
            obj.nconstr = 2;
            obj.OCV = @(x)Problem.setConstraints(obj.nconstr, x);
            obj.lb = [0.1 0];
            obj.ub = [1 5];
            %get max and min for each objfunc
            %{
            obj.FMAX = zeros(1,obj.m);
            obj.FMIN = zeros(1,obj.m);
            for m = 1:obj.m
                [obj.FMIN(m), obj.FMAX(m)] = obj.getMinMax(m);
            end
            obj.FMAX(1) = 100;obj.FMAX(2) = 100;
            obj.FMIN(1) = 0;obj.FMIN(2) = 0;
            %}
        end
        function F = getFitness(obj, m, x)
            f = obj.F{1,m}; %get anonymous function of the mth objective
            F = f(x);
        end
        function OCV = getConstrViolation(obj, x)
            c = obj.OCV; %get anonymous function that represents constraints
            OCV = c(x);
        end
        [fmin, fmax] = getMinMax(obj, m);
    end
    methods(Static)
        F1 = setF1(x,a,b,dir); % a and b are F associated coefficients
        F2 = setF2(x,a,b,dir);
        C = setConstraints(obj, x);
    end
end