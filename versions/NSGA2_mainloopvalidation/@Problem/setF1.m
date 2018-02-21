function F1 = setF1(x,a,b,dir)
    %dir = 1 -> original direction
    %dir = -1 -> inverse direction
    F1 = dir*(a*x(1) + b*x(2));
end