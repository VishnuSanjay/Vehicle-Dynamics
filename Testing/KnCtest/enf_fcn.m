function [enf]= enf_fcn(X, nf)
enfb = X(1);
enfc = X(2);
%%nf=[-100:10:100];

enf=sign(nf).*enfb*enfc/100.*log(abs(nf)./enfc+1);
