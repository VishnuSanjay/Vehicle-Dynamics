%% aligning moment compliance test

 data=[  0         0
    0.5401   13.7340
    1.0801   30.2148
    1.2463   41.2020
    1.5372   61.8030
    1.6203   75.5370
    1.9944   89.2710
    2.0774  103.0050];

defl=data(:,1);
Nm=data(:,2);


nf=[-100:10:100];

%%fitting the data to a parametric curve
options = optimset('MaxFunEvals',100000,'MaxIter',100000,'Display','final');

AMC = [0.5 100];  
AMC = lsqcurvefit('enf_fcn',AMC, Nm, defl,[],[],options) 

enf1=enf_fcn(AMC, nf);

%%plot of fit and of original data
figure
hold on
plot(Nm,defl)
plot(nf,enf1,'ro-')

legend('Experimental values','Parametrised representation','Location', 'NorthWest')
text(60,.5,{['Enfb= ' num2str(AMC(1))],['Enfc= ' num2str(AMC(2))]})

xlabel('Aligning Moment (Nm)')
ylabel('Aligning Moment Steer Compliance (deg/100Nm per wheel)')
grid
title('Two Parameter Nonlinear Compliance Steer Model')

