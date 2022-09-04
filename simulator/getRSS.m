function RSS = getRSS(x,y, originX,originY)
arguments
    x
    y
    originX double = 0;
    originY double = 0;
end
r = sqrt((x-originX)^2+(y-originY)^2);
RSS = -102.4-10*2.4*(log(r)/log(10));


end
