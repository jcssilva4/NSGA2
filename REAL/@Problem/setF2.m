function F2 = setF2(x,a,b,dir)
    
    %Minimization example problem: Min-Ex - Deb2003book, pg.166 
    F2 = dir*((1+(a*x(2)))/(b*x(1)));
    
    
end