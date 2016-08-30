function xbar=invWie(x)
NL_W=[1 1.5 1];
xbar=x+NL_W(2)*x.^2+NL_W(3)*x.^3;
