clear all
close all
clc

%% Inputs for the simulation and unit conversion:
global m kdash wb mf mr a b IZZ u TAU_AY steering_sens yawv_p2ss
m = 1133+668;%% mass of the vehicle, in kgs
kdash = -0.06; %%k' = k/(a*b) - 1
wb = 2.807; % wheelbase in metres
mf = 1133; %%mass on front axle, kg
mr = m - mf;
a = wb * mr / m;%%distance from CG to front axle in m
b = wb * mf / m;%%distance from CG to rear axle in m
%DF = 3; %%front corenering compliance in deg/g
IZZ = (kdash+1) * m * a * b;%% yaw moment of inertia of the vehicle, in kg m^2
%CF =  57.3 * mf * 9.81 / DF;%% Front tire cornering stiffness, input in N/deg, gets converted to N/rad
u = 100 / 3.6 ;%% vehicle forward velocity in m/s
%SR = 5;%%degrees of steer wheel angle per degree of wheel angle. Assumed constant
%%%Goal now is to determine DF, SR given lat acceleration resp time.
TAU_AY = 0.35;
steering_sens = 1.2;
yawv_p2ss = 1.2;

choice = menu('Synthesis tool','DFDRSYD', 'DFDRSYN');
switch choice
    case 1
        DR = 3;
        CR =  57.3 * mr * 9.81 / DR;%% Same as above, for rear tires
        params = [DR CR];
        %%%solve by using symbolic variables.
        % syms SR CF DF omega_sqr
        %
        % CF =  57.3 * mf * 9.81 / DF;
        %
        % DE1 = m * u * IZZ;
        % DE2 = (IZZ * (CF+CR)) + (m * (a^2 * CF + b^2 * CR));
        % DE3 = ((a+b)^2 * CF * CR / u) + (m * u * (b * CR - a * CF));
        %
        % %%%We knnow:
        % steering_senss = 100*u^2 / (SR*(wb+u^2*((DF-DR)/9.807/57.3)));
        % N5 = u * IZZ * CF;
        % N6 = CF * CR * (b^2 + a * b);
        % N7 = (a+b) * CF * CR * u;
        %
        % N1 = a * m * u * CF;
        % N2 = (a+b) * CF * CR;
        % R1 = N1 / N2;
        %
        % A2 = N5/N7;
        % A1 = N6/N7;
        % D2 = DE1 / DE3;
        % D1 = DE2 / DE3;
        %
        % bb = -4*D2^2;
        % aa = 2*R1^2*D2^2-4*D2^2*R1^2;
        % cc = 2*R1^2-2*(D1^2-2*D2^2);
        %
        % omega_p = sqrt((-bb - sqrt(bb^2 - 4*aa*cc))/2*aa);
        % X1 = 1;
        % X2 = R1 * omega_p;
        % X3 = -D2 * omega_p^2 + 1;
        % X4 = D1 * omega_p;
        % yawv_p2ss2 = sqrt((X1^2 + X2^2)/(X3^2 + X4^2));
        
        % omega_sqr = (-(2*A1^2-4*A2^2-D1^2+2*D2^2)-sqrt((2*A1^2-4*A2^2-D1^2+2*D2^2)^2-4*(2*A2^2-D2^2)))/ 2*(2*A2^2-D2^2);
        %
        % eqns = [omega_sqr== 4/TAU_AY^2, yawv_p2ss2 <= yawv_p2ss]
        % vars = [DF]
        % S = solve(eqns,vars)
        % vpa(S)
        
        % s = subs(steering_senss, DF , 7.61)
        % eqns = [s == steering_sens]
        % vars=[SR]
        % S = solve(eqns,vars)
        % vpa(S)/57.3/9.807 %%ms-2 per 100 radians SWA input then.
        
        %%% that didn't work so well
        %%% try bisection search
        %%% initialize understeer range to search over
        K_list = [0.01, 3, 6];
        DF_list = DR + K_list;
        error = 0;
        
        epsilon = DF_list(end) - DF_list(1);
        while epsilon > 0.005
            CF_list =  57.3 * mf * 9.81 ./ DF_list;
            tau = eval_tau(CF_list, params);
            if tau(1) < TAU_AY
                error = 1;
                disp("Infeasible search, TAU_AY too large")
            elseif tau(end) > TAU_AY
                error = 1;
                disp("Infeasible search, TAU_AY too small")
            else
                if tau(1) > TAU_AY && tau(2) < TAU_AY
                    DF_list(3) = DF_list(2);
                    DF_list(2) = (DF_list(3) + DF_list(1))/2;
                elseif tau(2) > TAU_AY && tau(3) < TAU_AY
                    DF_list(1) = DF_list(2);
                    DF_list(2) = (DF_list(3) + DF_list(1))/2;
                else %%tau(2) = TAU_AY
                    print("DF is = ", DF_list(2))
                    break
                end
            end
            epsilon = DF_list(end) - DF_list(1);
        end
        disp(['DF is = ' num2str(DF_list(2))])
        if error ~= 1
            DF = DF_list(2);
            SR = 100*u^2 / (steering_sens*(wb+u^2*((DF-DR)/9.807/57.3)))/9.807/57.3;
            disp(['SR is = ' num2str(SR)])
        end
    case 2
        input = [3 2];
        output = fsolve(@dfdr_syn, input);
        DF = output(1)
        DR = output(2)
        SR = 100*u^2 / (steering_sens*(wb+u^2*((DF-DR)/9.807/57.3)))/9.807/57.3;
        disp(['SR is = ' num2str(SR)])
end

        
        
        
        
        
        
        
        
