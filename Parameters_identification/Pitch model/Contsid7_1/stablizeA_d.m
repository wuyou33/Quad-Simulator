function As_hat = stablizeA_d(As_hat)
rootss=roots(As_hat);
neg=0;
for i=1:length(rootss)
    if abs(rootss(i))>1
        rootss(i)=1/rootss(i);
        neg=1;
    end
end
if neg
    As_hat=poly(rootss);
end