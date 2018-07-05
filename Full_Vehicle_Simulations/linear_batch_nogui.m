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
IZZ = (kdash+1) * m * a * b;%% yaw moment of inertia of the vehicle, in kg m^2
u = 100 / 3.6 ;%% vehicle forward velocity in m/s
SR = 5;%%degrees of steer wheel angle per degree of wheel angle. Assumed constant

DR = [1:1:6];
l1 = length(DR);
K = [1:1:6]; %%understeer DF-DR in deg/g
l2 = length(K);

%%% Steer function 
t=[0:.1:1.5];
tmid = 1.5; %% point about which the step function is symmetric
hw=1; %% half width of steer function duration
pwr=147; %steer velocity in deg/sec
swamp= 100; %%degrees of steering wheel angle
steerdeg=(-2./pi*atan(abs((t-tmid)./hw).^pwr)+1.).*swamp; %% in degrees
steer = steerdeg / 57.3;

for j = 1:1:l1
    CR(j) =  57.3 * mr * 9.81 / DR(j);%% Same as above, for rear tires
    
    for i = 1:1:l2
        %% Front tire cornering stiffness, input in N/deg, gets converted to N/rad
        DF(i) = K(i) + DR(j);
        CF(i) =  57.3 * mf * 9.81 / DF(i);

%%% Note: CF(i) and CR(j) can also be considered as effective front and rear
%%% cornering compliances, according to the paper by Bundorf and Leffert
        D1 = m * u * IZZ;
        D2 = (IZZ * (CF(i)+CR(j))) + (m * (a^2 * CF(i) + b^2 * CR(j)));
        D3 = ((a+b)^2 * CF(i) * CR(j) / u) + (m * u * (b * CR(j) - a * CF(i)));
        denom = [D1 D2 D3];
        
        %%% Yaw velocity numerator
        N1 = a * m * u * CF(i);
        N2 = (a+b) * CF(i) * CR(j);
        yawn = [N1 N2];
        yawan = [N1 N2 0];
        
        %%% Sideslip angle numerator
        N3 = IZZ * CF(i);
        N4 = (CF(i) * CR(j) * (b^2 + a * b) / u) - a * m * u * CF(i);
        betan = [N3 N4];
        dbetan = [N3 N4 0];
        
        %%% Lateral acceleration numerator
        N5 = u * IZZ * CF(i);
        N6 = CF(i) * CR(j) * (b^2 + a * b);
        N7 = (a+b) * CF(i) * CR(j) * u;
        ayn = [N5 N6 N7];
        
        %%% transfer functions
        yawvtxy = tf(yawn, denom); %%yaw velocity to steer
        betatxy = tf(betan, denom); %% sideslip by steer
        sstxy = tf(ayn, denom); %% lateral acceleration by steer
        betagtxy = tf(betan, ayn); %% sideslip by lateral acceleration
        yawatxy = tf(yawan, denom); %%yaw acceleration to steer
        dbetatxy = tf(dbetan, denom); %%sideslip velocity by steer
        
        yaw_bw=bandwidth(yawvtxy); 
        beta_bw=bandwidth(betatxy);
        ay_bw=bandwidth(sstxy);
        
        R_BW = yaw_bw/(2*pi); %in Hertz
        TAU_R = 2/yaw_bw ;  %in seconds
        
        B_BW = beta_bw/(2*pi); %in Hertz
        TAU_B = 2/beta_bw ;  %in seconds
        
        AY_BW = ay_bw/(2*pi); %in Hertz
        TAU_AY(i,j) = 2/ay_bw ;  %in seconds
        
        [wn,z]=damp(yawvtxy);
        WN = wn(1) / (2*pi); %first natural frequency in Hertz
        ZETA = z(1); %damping ratio
        
        r = lsim(yawvtxy,steer / SR ,t); %% yaw response wrt wheel angle
        yawv_p2ss(i,j)= ((max(r)/r(end))-1)*100; %yaw velocity peak to steady state ratio
    end
end


%% Carpet plot time
figure
hold on
for i = 1:1:l1
    plot(TAU_AY(i,:), yawv_p2ss(i,:),'b')
    curr_k = ['K = ',num2str(K(i))];
    text(TAU_AY(i,end),yawv_p2ss(i,end),curr_k,'HorizontalAlignment','left');
end
for i = 1:1:l2
    plot(TAU_AY(:,i), yawv_p2ss(:,i),'g')
    curr_dr = ['DR = ',num2str(DR(i))];
    text(TAU_AY(1,i),yawv_p2ss(1,i),curr_dr,'HorizontalAlignment','left','VerticalAlignment','top');
end
xlabel('Lateral acceleration response time(seconds)')
ylabel('Yaw velocity peak to steady state ratio (%)')