function OCV = setConstraints(nconstr, x)
    OCV = 0;
    c = zeros(1,nconstr); %vector of constraints
    b = zeros(1,nconstr); %vector of rhs
    %c1 
    b(1) = 6;
    c(1) = -9*x(1) - x(2) + b(1); % <= 0
    %c2 
    b(2) = 1;
    c(2) = -9*x(1) + x(2) + b(2); % <= 0
    %calculate OCV (Overall Constraint Violation)
    for k = 1:nconstr
        c(k) = c(k)/b(k);
        if(c(k) <= 0)
            c(k) = 0; %constraint k not violated
        else
            OCV = OCV + abs(c(k)); %constarint k violated
        end
    end
end