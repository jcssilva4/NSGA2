function [fmin,fmax] = getMinMax(obj,m)
%in the CCPO...should we use the sum(wi) = 1 constraint? or only boundaries? 
    fmin = obj.F{1,m};
    fmax = obj.F{2,m};
    options = optimoptions('fmincon','Display', 'off');
    [~,fmin] = fmincon(fmin, zeros(1,obj.nVars), [], [], [], [],...
                            obj.lb, obj.ub, [], options);
    [~,fmax] = fmincon(fmax, zeros(1,obj.nVars), [], [], [], [],...
                            obj.lb, obj.ub, [], options);
    fmax = -fmax;
end