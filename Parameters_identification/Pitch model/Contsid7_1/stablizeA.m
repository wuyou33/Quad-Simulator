function As_hat = stablizeA(As_hat)
rootss=roots(As_hat);
neg=0;
for i=1:length(rootss)
    if real(rootss(i))>0
        rootss(i)=-real(rootss(i))+imag(rootss(i))*sqrt(-1);
        neg=1;
    end
end
if neg
    As_hat=poly(rootss);
end