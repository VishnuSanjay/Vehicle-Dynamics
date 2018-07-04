clear all
close all
clc

%% Inputs for the simulation and unit conversion:
m = 220;%% mass of the vehicle, in kgs
kdash = 0; %%k' = k/(a*b) - 1
wb = 1.745; % wheelbase in metres
a = wb * 120 / m;%%distance from CG to front axle in m
b = wb * 100 / m;%%distance from CG to rear axle in m
mf = m * b / (a+b); %%mass on front axle, kg
mr = m * a / (a+b);
DF = 3; %%front corenering compliance in deg/g
DR = 2;
IZZ = (kdash+1) * m * a * b;%% yaw moment of inertia of the vehicle, in kg m^2
CF =  57.3 * mf * 9.81 / DF;%% Front tire cornering stiffness, input in N/deg, gets converted to N/rad
CR =  57.3 * mr * 9.81 / DR;%% Same as above, for rear tires
u = 100 / 3.6 ;%% vehicle forward velocity in m/s
SR = 5;%%degrees of steer wheel angle per degree of wheel angle. Assumed constant

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
fintim = 10.24;
dt = 0.01;
t=[0:dt:fintim];
swamp= 100; %%degrees of steering wheel angle

%%% sine and cosine params: not used if pulse selected
f0 = 0.01;
f1 = 4;

%%% pulse parameters, not used if sine or cosine selected
tmid = 1.5; %% point about which the step function is symmetric
hw=1; %% half width of steer function duration
pwr=147; %steer velocity in deg/sec

%%% Signal selection
choice=menu('Select input signal','Sine','Cosine','Pulse');
switch choice
    case 1
        steerdeg = chirp(t,f0,t(end),f1,[],-90)*swamp;
    case 2
        steerdeg = chirp(t,f0,t(end),f1,[],0)*swamp;
    case 3
        steerdeg=(-2./pi*atan(abs((t-tmid)./hw).^pwr)+1.).*swamp; %% in degrees
end        
steer = steerdeg / 57.3;


%% Creation of time signals
r = lsim(yawvtxy,steer / SR ,t); %% yaw response wrt wheel angle
beta = lsim(betatxy, steer / SR, t); %%beta response wrt wheel angle
ay = lsim(sstxy, steer/ SR ,t);
rd = lsim(yawatxy, steer / SR , t); %%yaw acceleration response wrt wheel angle
betad = lsim(dbetatxy, steer / SR, t);

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

%% Selection of windowing function
nfft = pow2(round(log2(length(steer))));
sps = 1/dt;
fft_window=menu('Select windowing function','Bartlett','Barthannwin','blackman','blackmanharris','bohmanwin','chebwin','flattopwin','gausswin','hamming','hann','kaiser','nutall','parzenwin','rectwin','tukeywin','triang');
switch fft_window
case 1
[sstxy_dat,f]  = tfestimate(steer,ay,  bartlett(nfft),nfft/2,nfft,sps); % ayg by steer transfer function
[betatxy_dat,f]= tfestimate(steer,beta,bartlett(nfft),nfft/2,nfft,sps); % beta by steer transfer function
[betagtxy_dat,f]= tfestimate(ay,beta,  bartlett(nfft),nfft/2,nfft,sps); % beta by ay transfer function
[yawvtxy_dat,f]= tfestimate(steer,r,   bartlett(nfft),nfft/2,nfft,sps); % yawv by steer transfer function
[yawatxy_dat,f]= tfestimate(steer,rd,   bartlett(nfft),nfft/2,nfft,sps); % yawa by steer transfer function
case 2
[sstxy_dat,f]  = tfestimate(steer,ay,  barthannwin(nfft),nfft/2,nfft,sps); % ayg by steer transfer function
[betatxy_dat,f]= tfestimate(steer,beta,barthannwin(nfft),nfft/2,nfft,sps); % beta by steer transfer function
[betagtxy_dat,f]= tfestimate(ay,beta,  barthannwin(nfft),nfft/2,nfft,sps); % beta by ay transfer function
[yawvtxy_dat,f]= tfestimate(steer,r,   barthannwin(nfft),nfft/2,nfft,sps); % yawv by steer transfer function
[yawatxy_dat,f]= tfestimate(steer,rd,   barthannwin(nfft),nfft/2,nfft,sps); % yawa by steer transfer function
case 3    
[sstxy_dat,f]  = tfestimate(steer,ay,  blackman(nfft),nfft/2,nfft,sps); % ayg by steer transfer function
[betatxy_dat,f]= tfestimate(steer,beta,blackman(nfft),nfft/2,nfft,sps); % beta by steer transfer function
[betagtxy_dat,f]= tfestimate(ay,beta,  blackman(nfft),nfft/2,nfft,sps); % beta by ay transfer function
[yawvtxy_dat,f]= tfestimate(steer,r,   blackman(nfft),nfft/2,nfft,sps); % yawv by steer transfer function
[yawatxy_dat,f]= tfestimate(steer,rd,   blackman(nfft),nfft/2,nfft,sps); % yawa by steer transfer function
case 4        
[sstxy_dat,f]  = tfestimate(steer,ay,  blackmanharris(nfft),nfft/2,nfft,sps); % ayg by steer transfer function
[betatxy_dat,f]= tfestimate(steer,beta,blackmanharris(nfft),nfft/2,nfft,sps); % beta by steer transfer function
[betagtxy_dat,f]= tfestimate(ay,beta,  blackmanharris(nfft),nfft/2,nfft,sps); % beta by ay transfer function
[yawvtxy_dat,f]= tfestimate(steer,r,   blackmanharris(nfft),nfft/2,nfft,sps); % yawv by steer transfer function
[yawatxy_dat,f]= tfestimate(steer,rd,   blackmanharris(nfft),nfft/2,nfft,sps); % yawa by steer transfer function
case 5        
[sstxy_dat,f]  = tfestimate(steer,ay,  bohmanwin(nfft),nfft/2,nfft,sps); % ayg by steer transfer function
[betatxy_dat,f]= tfestimate(steer,beta,bohmanwin(nfft),nfft/2,nfft,sps); % beta by steer transfer function
[betagtxy_dat,f]= tfestimate(ay,beta,  bohmanwin(nfft),nfft/2,nfft,sps); % beta by ay transfer function
[yawvtxy_dat,f]= tfestimate(steer,r,   bohmanwin(nfft),nfft/2,nfft,sps); % yawv by steer transfer function
[yawatxy_dat,f]= tfestimate(steer,rd,  bohmanwin(nfft),nfft/2,nfft,sps); % yawa by steer transfer function
case 6       
[sstxy_dat,f]  = tfestimate(steer,ay,  chebwin(nfft),nfft/2,nfft,sps); % ayg by steer transfer function
[betatxy_dat,f]= tfestimate(steer,beta,chebwin(nfft),nfft/2,nfft,sps); % beta by steer transfer function
[betagtxy_dat,f]= tfestimate(ay,beta,  chebwin(nfft),nfft/2,nfft,sps); % beta by ay transfer function
[yawvtxy_dat,f]= tfestimate(steer,r,   chebwin(nfft),nfft/2,nfft,sps); % yawv by steer transfer function
[yawatxy_dat,f]= tfestimate(steer,rd,  chebwin(nfft),nfft/2,nfft,sps); % yawa by steer transfer function
case 7    
[sstxy_dat,f]  = tfestimate(steer,ay,  flattopwin(nfft),nfft/2,nfft,sps); % ayg by steer transfer function
[betatxy_dat,f]= tfestimate(steer,beta,flattopwin(nfft),nfft/2,nfft,sps); % beta by steer transfer function
[betagtxy_dat,f]= tfestimate(ay,beta,  flattopwin(nfft),nfft/2,nfft,sps); % beta by ay transfer function
[yawvtxy_dat,f]= tfestimate(steer,r,   flattopwin(nfft),nfft/2,nfft,sps); % yawv by steer transfer function
[yawatxy_dat,f]= tfestimate(steer,rd, flattopwin(nfft),nfft/2,nfft,sps); % yawa by steer transfer function
case 8    
[sstxy_dat,f]  = tfestimate(steer,ay,  gausswin(nfft),nfft/2,nfft,sps); % ayg by steer transfer function
[betatxy_dat,f]= tfestimate(steer,beta,gausswin(nfft),nfft/2,nfft,sps); % beta by steer transfer function
[betagtxy_dat,f]= tfestimate(ay,beta,  gausswin(nfft),nfft/2,nfft,sps); % beta by ay transfer function
[yawvtxy_dat,f]= tfestimate(steer,r,   gausswin(nfft),nfft/2,nfft,sps); % yawv by steer transfer function
[yawatxy_dat,f]= tfestimate(steer,rd,  gausswin(nfft),nfft/2,nfft,sps); % yawa by steer transfer function
case 9   
[sstxy_dat,f]  = tfestimate(steer,ay,  hamming(nfft),nfft/2,nfft,sps); % ayg by steer transfer function
[betatxy_dat,f]= tfestimate(steer,beta,hamming(nfft),nfft/2,nfft,sps); % beta by steer transfer function
[betagtxy_dat,f]= tfestimate(ay,beta,  hamming(nfft),nfft/2,nfft,sps); % beta by ay transfer function
[yawvtxy_dat,f]= tfestimate(steer,r,   hamming(nfft),nfft/2,nfft,sps); % yawv by steer transfer function
[yawatxy_dat,f]= tfestimate(steer,rd,  hamming(nfft),nfft/2,nfft,sps); % yawa by steer transfer function
case 10   
[sstxy_dat,f]  = tfestimate(steer,ay,  hann(nfft),nfft/2,nfft,sps); % ayg by steer transfer function
[betatxy_dat,f]= tfestimate(steer,beta,hann(nfft),nfft/2,nfft,sps); % beta by steer transfer function
[betagtxy_dat,f]= tfestimate(ay,beta,  hann(nfft),nfft/2,nfft,sps); % beta by ay transfer function
[yawvtxy_dat,f]= tfestimate(steer,r,   hann(nfft),nfft/2,nfft,sps); % yawv by steer transfer function
[yawatxy_dat,f]= tfestimate(steer,rd,  hann(nfft),nfft/2,nfft,sps); % yawa by steer transfer function
case 11   
[sstxy_dat,f]  = tfestimate(steer,ay,  kaiser(nfft),nfft/2,nfft,sps); % ayg by steer transfer function
[betatxy_dat,f]= tfestimate(steer,beta,kaiser(nfft),nfft/2,nfft,sps); % beta by steer transfer function
[betagtxy_dat,f]= tfestimate(ay,beta,  kaiser(nfft),nfft/2,nfft,sps); % beta by ay transfer function
[yawvtxy_dat,f]= tfestimate(steer,r,   kaiser(nfft),nfft/2,nfft,sps); % yawv by steer transfer function
[yawatxy_dat,f]= tfestimate(steer,rd,  kaiser(nfft),nfft/2,nfft,sps); % yawa by steer transfer function
case 12   
[sstxy_dat,f]  = tfestimate(steer,ay,  nuttallwin(nfft),nfft/2,nfft,sps); % ayg by steer transfer function
[betatxy_dat,f]= tfestimate(steer,beta,nuttallwin(nfft),nfft/2,nfft,sps); % beta by steer transfer function
[betagtxy_dat,f]= tfestimate(ay,beta,  nuttallwin(nfft),nfft/2,nfft,sps); % beta by ay transfer function
[yawvtxy_dat,f]= tfestimate(steer,r,   nuttallwin(nfft),nfft/2,nfft,sps); % yawv by steer transfer function
[yawatxy_dat,f]= tfestimate(steer,rd,  nuttallwin(nfft),nfft/2,nfft,sps); % yawa by steer transfer function
case 13   
[sstxy_dat,f]  = tfestimate(steer,ay,  parzenwin(nfft),nfft/2,nfft,sps); % ayg by steer transfer function
[betatxy_dat,f]= tfestimate(steer,beta,parzenwin(nfft),nfft/2,nfft,sps); % beta by steer transfer function
[betagtxy_dat,f]= tfestimate(ay,beta,  parzenwin(nfft),nfft/2,nfft,sps); % beta by ay transfer function
[yawvtxy_dat,f]= tfestimate(steer,r,   parzenwin(nfft),nfft/2,nfft,sps); % yawv by steer transfer function
[yawatxy_dat,f]= tfestimate(steer,rd, parzenwin(nfft),nfft/2,nfft,sps); % yawa by steer transfer function
case 14   
[sstxy_dat,f]  = tfestimate(steer,ay,  rectwin(nfft),nfft/2,nfft,sps); % ayg by steer transfer function
[betatxy_dat,f]= tfestimate(steer,beta,rectwin(nfft),nfft/2,nfft,sps); % beta by steer transfer function
[betagtxy_dat,f]= tfestimate(ay,beta,  rectwin(nfft),nfft/2,nfft,sps); % beta by ay transfer function
[yawvtxy_dat,f]= tfestimate(steer,r,   rectwin(nfft),nfft/2,nfft,sps); % yawv by steer transfer function
[yawatxy_dat,f]= tfestimate(steer,rd, rectwin(nfft),nfft/2,nfft,sps); % yawa by steer transfer function
case 15   
[sstxy_dat,f]  = tfestimate(steer,ay,  tukeywin(nfft),nfft/2,nfft,sps); % ayg by steer transfer function
[betatxy_dat,f]= tfestimate(steer,beta,tukeywin(nfft),nfft/2,nfft,sps); % beta by ay transfer function
[betagtxy_dat,f]= tfestimate(ay,beta,  tukeywin(nfft),nfft/2,nfft,sps); % beta by ay transfer function
[yawvtxy_dat,f]= tfestimate(steer,r,   tukeywin(nfft),nfft/2,nfft,sps); % yawv by steer transfer function
[yawatxy_dat,f]= tfestimate(steer,rd, tukeywin(nfft),nfft/2,nfft,sps); % yawa by steer transfer function
case 16   
[sstxy_dat,f]  = tfestimate(steer,ay,  triang(nfft),nfft/2,nfft,sps); % ayg by steer transfer function
[betatxy_dat,f]= tfestimate(steer,beta,triang(nfft),nfft/2,nfft,sps); % beta by steer transfer function
[betagtxy_dat,f]= tfestimate(ay,beta,  triang(nfft),nfft/2,nfft,sps); % beta by ay transfer function
[yawvtxy_dat,f]= tfestimate(steer,r,   triang(nfft),nfft/2,nfft,sps); % yawv by steer transfer function
[yawatxy_dat,f]= tfestimate(steer,rd,   triang(nfft),nfft/2,nfft,sps); % yawa by steer transfer function

end 

%%% processing the installed transfer functions
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

%%% processing the estimated transfer functions
yawv_gain     = abs(yawvtxy_dat);
beta_gain =  abs(betagtxy_dat);
ay_gain       = abs(sstxy_dat);

figure
subplot(4,1,1)
plot(w/2/pi,mag*100/SR,'b-',f,yawv_gain*100,'r.');
xlim([0 4])
grid on
ylabel('Yaw velocity Gain (deg / sec / 100 deg SWA)')
legend('Theory','Processing')

subplot(4,1,2)
plot(w1/2/pi,mag1 * 57.3 * 9.807,'b-',f,beta_gain* 57.3 * 9.807,'r.');
xlim([0 4])
grid on
ylabel('Sideslip Gain')
legend('Theory','Processing')

subplot(4,1,3)
plot(w2/2/pi,mag2* 100/ 57.3 /SR /9.807,'b-',f,ay_gain* 100/ 57.3 /9.807,'r.');
xlim([0 4])
grid on
ylabel('Lateral acceleration Gain (gs per 100 deg SWA)')
legend('Theory','Processing')

subplot(4,1,4)
plot(w3/2/pi,mag3*100/SR,'b-');
xlim([0 4])
grid on
ylabel('Yaw acceleratoin (deg / sec^2 / 100 deg SWA)')
legend('Theory')



%% Outputs
%%% steady state gains;
yawvss = N2 / D3; %%steady state yaw velocity gain rad/s/rad of WA
betass = N4 / D3;  %%steady state sideslip angle gain rad/rad of WA
ayss = N7 / D3; %% steady state lateral acceleration gain ms^-2/rad
ss = betass / ayss; %% steady state sideslip gain rad/ms^-2

ayssg = ayss / 9.807 / 57.3;  %%steady state lateral acceleration gain g's/deg
steeringsens = ayssg * 100 / SR; %%steering sensitivity. g's per 100 deg

%%%ayssg is steering sensitivity in terms of g's per 1 deg wheel angle
%%%ayss is steering sensitivity in terms of ms^-2 per radian wheel angle

%% Data processing inputs




