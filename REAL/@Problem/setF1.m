function F1 = setF1(x,a,b,dir)
    %dir = 1 -> original direction
    %dir = -1 -> inverse direction
    
    %Minimization example problem: Min-Ex - Deb2003book, pg.166 
    F1 = dir*(a*x(1) + b*x(2));
    
    
end