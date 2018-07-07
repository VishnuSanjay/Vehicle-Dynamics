clear all
close all
clc

%% Inputs for the simulation and unit conversion:
m = 1600;%% mass of the vehicle, in kgs
kdash = 0; %%k' = k/(a*b) - 1
wb = 2.747; % wheelbase in metres
a = wb * 600 / m;%%distance from CG to front axle in m
b = wb * 1000 / m;%%distance from CG to rear axle in m
mf = m * b / (a+b); %%mass on front axle, kg
mr = m * a / (a+b);
DF = 6; %%front corenering compliance in deg/g
DR = 3;
IZZ = (kdash+1) * m * a * b;%% yaw moment of inertia of the vehicle, in kg m^2
CF =  57.3 * mf * 9.81 / DF;%% Front tire cornering stiffness, input in N/deg, gets converted to N/rad
CR =  57.3 * mr * 9.81 / DR;%% Same as above, for rear tires
u = 100 / 3.6 ;%% vehicle forward velocity in m/s
SR = 16;%%degrees of steer wheel angle per degree of wheel angle. Assumed constant

%%% Note: CF and CR can also be considered as effective front and rear
%%% cornering compliances, according to the paper by Bundorf and Leffert


%% Computation area
D1 = m * u * IZZ;
D2 = (IZZ * (CF+CR)) + (m * (a^2 * CF + b^2 * CR));
D3 = ((a+b)^2 * CF * CR / u) + (m * u * (b * CR - a * CF));
denom = [D1 D2 D3];

%%% Yaw velocity numerator
N1 = a * m * u * CF;
N2 = (a+b) * CF * CR;
yawn = [N1 N2];
yawan = [N1 N2 0];

%%% Sideslip angle numerator
N3 = IZZ * CF;
N4 = (CF * CR * (b^2 + a * b) / u) - a * m * u * CF;
betan = [N3 N4];
dbetan = [N3 N4 0];

%%% Lateral acceleration numerator
N5 = u * IZZ * CF;
N6 = CF * CR * (b^2 + a * b);
N7 = (a+b) * CF * CR * u;
ayn = [N5 N6 N7];

%%% transfer functions
yawvtxy = tf(yawn, denom); %%yaw velocity to steer 
betatxy = tf(betan, denom); %% sideslip by steer
sstxy = tf(ayn, denom); %% lateral acceleration by steer
betagtxy = tf(betan, ayn); %% sideslip by lateral acceleration
yawatxy = tf(yawan, denom); %%yaw acceleration to steer
dbetatxy = tf(dbetan, denom); %%sideslip velocity by steer

%%% Steer function 
t=[0:.1:2];
tmid = 1.5; %% point about which the step function is symmetric
hw=1; %% half width of steer function duration
pwr=147; %steer velocity in deg/sec
swamp= 100; %%degrees of steering wheel angle
steerdeg=(-2./pi*atan(abs((t-tmid)./hw).^pwr)+1.).*swamp; %% in degrees
steer = steerdeg / 57.3;


%% Responses and plots
r = lsim(yawvtxy,steer / SR ,t); %% yaw response wrt wheel angle
beta = lsim(betatxy, steer / SR, t); %%beta response wrt wheel angle
ay = lsim(sstxy, steer / SR ,t);
rd = lsim(yawatxy, steer / SR , t); %%yaw acceleration response wrt wheel angle
betad = lsim(dbetatxy, steer / SR, t);

[mag,phase,w] = bode(yawvtxy);
mag           = squeeze(mag);
w             = squeeze(w);
[mag1,phase1,w1] = bode(betagtxy);
mag1           = squeeze(mag1);
w1             = squeeze(w1);
[mag2,phase2,w2] = bode(sstxy);
mag2           = squeeze(mag2);
w2             = squeeze(w2);
[mag3,phase3,w3] = bode(yawatxy);
mag3           = squeeze(mag3);
w3            = squeeze(w3);

figure
subplot(4,1,1)
plot(w/2/pi,mag*100/SR,'b-');
xlim([0 4])
grid on
ylabel('Yaw velocity Gain (deg / sec / 100 deg SWA)')
legend('Theory')

subplot(4,1,2)
plot(w1/2/pi,mag1 * 57.3 * 9.807,'b-');
xlim([0 4])
grid on
ylabel('Sideslip Gain')
legend('Theory')

subplot(4,1,3)
plot(w2/2/pi,mag2* 100/ 57.3 /SR /9.807,'b-');
xlim([0 4])
grid on
ylabel('Lateral acceleration Gain (gs per 100 deg SWA)')
legend('Theory')

subplot(4,1,4)
plot(w/2/pi,mag3*100/SR,'b-');
xlim([0 4])
grid on
ylabel('Yaw acceleratoin (deg / sec^2 / 100 deg SWA)')
legend('Theory')

%%% Time plots
figure
subplot(4,1,1)
plot(t, r * 180 / pi, 'k')
xlabel('Time (s)') 
ylabel('Yaw velocity (deg/sec)')

subplot(4,1,2)
plot(t,beta * 180 / pi , 'r')
xlabel('Time (s)') 
ylabel('Sideslip angle (deg)')

subplot(4,1,3)
plot(t,ay / 9.807 , 'b')
xlabel('Time (s)') 
ylabel('Lateral acceleration (g)')

subplot(4,1,4)
plot(t ,steerdeg, 'y')
xlabel('Time (s)') 
ylabel('Steer (deg)')

%% Outputs
%%% steady state gains;
yawvss = N2 / D3; %%steady state yaw velocity gain rad/s/rad of WA
betass = N4 / D3;  %%steady state sideslip angle gain rad/rad of WA
ayss = N7 / D3; %% steady state lateral acceleration gain ms^-2/rad
ss = betass / ayss; %% steady state sideslip gain rad/ms^-2

ayssg = ayss / 9.807 / 57.3;  %%steady state lateral acceleration gain g's/deg
steeringsens = ayssg * 100 / SR; %%steering sensitivity. g's per 100 deg

yaw_bw=bandwidth(yawvtxy); 
beta_bw=bandwidth(betatxy); 
ay_bw=bandwidth(sstxy);

R_BW = yaw_bw/(2*pi); %in Hertz
TAU_R = 2/yaw_bw ;  %in seconds

B_BW = beta_bw/(2*pi); %in Hertz
TAU_B = 2/beta_bw ;  %in seconds

AY_BW = ay_bw/(2*pi); %in Hertz
TAU_AY = 2/ay_bw ;  %in seconds

[wn,z]=damp(yawvtxy);
WN = wn(1) / (2*pi); %first natural frequency in Hertz
ZETA = z(1); %damping ratio

yawv_p2ss= ((max(r)/r(end))-1)*100; %yaw velocity peak to steady state ratio
%%%ayssg is steering sensitivity in terms of g's per 1 deg wheel angle
%%%ayss is steering sensitivity in terms of ms^-2 per radian wheel angle





