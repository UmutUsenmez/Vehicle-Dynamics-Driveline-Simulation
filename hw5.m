% =========================================================================
% HW5: Driveline Model Initialization
% =========================================================================
clear; clc;

%%  1. LOADING ENGINE MAP DATA

load('engine_T-omega_Genta_veh1__data.mat');        % It pulls the .mat file from the folder into Workspace.
% We divide the Data001 matrix (34x2) that comes out of it into two parts: speed and torque:
engine_speed = Data001(:, 1);  % Column 1: Engine Speed ​​(rpm)
engine_torque = Data001(:, 2); % Column 2: Engine Torque (Nm)

%% 2. VEHICLE PHYSICAL PARAMETERS

m = 830;                % Vehicle mass (kg)
Rw = 0.257;             % Effective wheel radius (m)
ax = 1;                 % Longitudinal acceleration (m/s²)

%% 3. INERTIA VALUES (kg*m^2)

Ie = 0.085;             % Motor inertia (Je)
It = 0.05;              % Transmission inertia (Jt)
Id = 0.135;             % Shaft inertia (Jd)
Iw_each = 0.4;          % The inertia of a single wheel
Iw = Iw_each * 4;       % Total wheel inertia (there are 4 wheels)

%% 4. TRANSMISSION PORT VALUES

eta = 0.91;             % Efficiency (eta_t)
Nf = 1 / 0.2884;        % Differential (Final Drive) Ratio (tau_f)
% Gear Ratios (tau I, tau II, tau III, tau IV)
gear_1 = 65 / 14;       % 1. Gear
gear_2 = 63 / 23;       % 2. Gear
gear_3 = 34 / 21;       % 3. Gear
gear_4 = 21 / 22;       % 4. Gear
Nt = gear_1;            % Active gear ratio (Nt)

%% 5. SIMULINK AUTOMATION AND PLOTTING 

% Array storing the 4 gear ratios
gear_ratios = [gear_1, gear_2, gear_3, gear_4];
gear_names = {'First Gear', 'Second Gear', 'Third Gear', 'Fourth Gear'};
% Graphic settings
figure('Name', 'Tractive Force vs Engine Speed', 'Color', 'w');
% Loop to run the simulation for all 4 gears
for i = 1:4
    % Step 1: Assign the current gear ratio to the workspace variable 'Nt'
    Nt = gear_ratios(i); 
    % Step 2: Run the Simulink model for exactly 5 seconds to avoid looping
    out = sim('hw5_simulink', 'StopTime', '5', 'FixedStep', '0.001');              
    % Step 3: Extract the data from the 'To Workspace' blocks
    if isobject(out.RPM_out)
        RPM = out.RPM_out.Data; 
        Fx = out.Fx_out.Data;
    else
        RPM = out.RPM_out; 
        Fx = out.Fx_out;
    end
    RPM = RPM(1:end-1);
    Fx = Fx(1:end-1);
    % Step 4: Create a 2x2 subplot for each gear 
    subplot(2, 2, i);
    plot(RPM, Fx, 'LineWidth', 1.5, 'Color', '#0072BD');
    % Plot settings
    title(gear_names{i});
    xlabel('Engine speed [rpm]');
    ylabel('Traction, F_x [N]');
    xlim([2000 4000]); % Focus on the 2000-4000 RPM range
    grid on;
end