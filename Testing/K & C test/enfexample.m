enfb1=5.00;
enfc1=10;

nf=[-100:10:100];
figure
enf1 = [enfb1, enfc1];
enf1=enf_fcn(enf1,nf);

enfb2 =.5; 
enfc2 =100;
enf2=[enfb2, enfc2];
enf2=enf_fcn(enf2,nf);

enfb3 =15;
enfc3 =5;
enf3=[enfb3, enfc3];
enf3=enf_fcn(enf3,nf);

enfb4 =4.15;
enfc4 =37;
enf4=[enfb4, enfc4];
enf4=enf_fcn(enf4,nf);
plot(nf,enf1,'ro-',nf,enf2,'bo-',nf,enf3,'go-', nf, enf4, 'yo-')

legend(['ENFB= ' num2str(enfb1) ', ENFC = ' num2str(enfc1)], ...
['ENFB= ' num2str(enfb2) ', ENFC = ' num2str(enfc2)], ...
['ENFB= ' num2str(enfb3) ', ENFC = ' num2str(enfc3)], ...
['ENFB= ' num2str(enfb4) ', ENFC = ' num2str(enfc4)],'Location','SouthEast');
legend boxoff

xlabel('Aligning Moment (Nm)')
ylabel('Aligning Moment Steer Compliance (deg/100Nm per wheel)')
grid
title('Two Parameter Nonlinear Compliance Steer Model')
