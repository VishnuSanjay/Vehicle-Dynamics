function [RATIO] = sr_func(SR,swa)
%VHTRIMS Overall Steer Ratio fitting function
% [RATIO] = sr_func(A0,A1,A2,B,C,D,F,G,swa)

% sample data typical for full blown curve fit:
%A0 = 15.57 Ratio Points
%A1 * 10^3 = -0.4974 ASYMMETRY
%A2 * 10^6 = -9.4283 BOW
%B = -0.56 LUMPINESS AMPLITUDE (Ratio Points)
%C = -14.84 LUMPINESS PHASE POSITION (Degrees SWA)
%D = 2.70 VARIABLE RATIO AMPLITUDE (Ratio Points)
%F = 550.82 VARIABLE RATIO RANGE (Degrees SWA)
%G = 13.75 VARIABLE RATIO ZERO OFFSET (Degrees SWA)

A0 = SR(1);
A1 = SR(2);
A2 = SR(3);
B = SR(4);
C = SR(5);
D = SR(6);
F = SR(7);
G = SR(8);

F(F==0)=realmax; % realsteve could do the job, too.

RATIO = A0 + A1/10^3*(swa) + A2/10^6*(swa).^2 + B*cos(2*(swa- C)/57.3) + D*exp(-(4*(swa-G)/F).^2) ;
return