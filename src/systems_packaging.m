function results = systems_packaging(params)
%SYSTEMS_PACKAGING Concept-stage UE-M1 calculator derived from B0_Pkg_Calc_4.m.
%   systems_packaging() prompts for values (Enter accepts each default).
%   R = systems_packaging(struct()) runs documented example defaults without prompts.
%   R = systems_packaging(struct('field', value)) overrides selected inputs.
%   Results include inputs and calculated quantities in original variable units.
interactive = nargin == 0;
if interactive, params = struct(); end
validateattributes(params, {'struct'}, {'scalar'});
allowed = {'W_total', 'H_total', 'C_fill', 'L_bay', 'L_engine', 'C_firewall', 'WB', 'TW', 'Max_Steer_deg', 'L_cab', 'W_cab', 'H_cab', 'Solid_Ratio'};
unknown = setdiff(fieldnames(params), allowed);
if ~isempty(unknown)
    error('uem1:UnknownParameter', 'Unknown parameter: %s', unknown{1});
end
% =========================================================================
% TOOL NAME: B0 Platform Systems Engineering Data Hand-off Calculator
% PURPOSE: Automated calculation of Frontal Area, Cooling Space, Turning Radius & HVAC Volume
% VERSION: 1.0 (Development Phase)
% AUTHOR: ???? ????? ????? (Pickup Design Team)
% =========================================================================



disp('=================================================================');
disp('       B0 Platform Systems Engineering Data Hand-off Tool');
disp('=================================================================');

%% Inputs
W_total = read_parameter(params, 'W_total', 'Enter Total Vehicle Width (m) [e.g., 1.78]: ', 1.78, interactive);
H_total = read_parameter(params, 'H_total', 'Enter Total Vehicle Height (m) [e.g., 1.60]: ', 1.60, interactive);
C_fill = read_parameter(params, 'C_fill', 'Enter Aerodynamic Form Factor [e.g., 0.81]: ', 0.81, interactive);

L_bay = read_parameter(params, 'L_bay', 'Enter Available Engine Bay Length (mm) [e.g., 1450]: ', 1450, interactive);
L_engine = read_parameter(params, 'L_engine', 'Enter Engine Block Length (mm) [e.g., 650]: ', 650, interactive);
C_firewall = read_parameter(params, 'C_firewall', 'Enter Required Firewall Clearance (mm) [e.g., 150]: ', 150, interactive);

WB = read_parameter(params, 'WB', 'Enter Wheelbase (m) [e.g., 2.905]: ', 2.905, interactive);
TW = read_parameter(params, 'TW', 'Enter Track Width (m) [e.g., 1.500]: ', 1.500, interactive);
Max_Steer_deg = read_parameter(params, 'Max_Steer_deg', 'Enter Max Inner Wheel Angle (deg) [e.g., 38]: ', 38, interactive);

L_cab = read_parameter(params, 'L_cab', 'Enter Cabin Floor Length (m) [e.g., 1.85]: ', 1.85, interactive);
W_cab = read_parameter(params, 'W_cab', 'Enter Cabin Floor Width (m) [e.g., 1.49]: ', 1.49, interactive);
H_cab = read_parameter(params, 'H_cab', 'Enter Cabin Average Internal Height (m) [e.g., 1.10]: ', 1.10, interactive);
Solid_Ratio = read_parameter(params, 'Solid_Ratio', 'Enter Solid Objects Ratio in Cabin (0 to 1) [e.g., 0.25]: ', 0.25, interactive);



%% Calculations
% 1. Frontal Area
A_frontal = W_total * H_total * C_fill;

% 2. Engine Bay Clearances
C_front_cooling = L_bay - (L_engine + C_firewall);

% 3. Steering Kinematics
Steer_rad = deg2rad(Max_Steer_deg);
% Ideal Ackermann geometry: outer front wheel path radius.
R_rear_center = WB / tan(Steer_rad) + TW / 2;
R_turn = sqrt(WB^2 + (R_rear_center + TW / 2)^2);

% 4. HVAC Air Volume
V_geometric = L_cab * W_cab * H_cab;
V_breathable = V_geometric * (1 - Solid_Ratio);

%% Output Report
disp(' ');
disp('=================================================================');
disp('                 FINAL INTER-TEAM HAND-OFF DATA                  ');
disp('=================================================================');

fprintf('>> [1] TO POWERTRAIN TEAM (AERODYNAMICS):\n');
fprintf('   - Calculated Frontal Area (Af): %.3f m^2\n\n', A_frontal);

fprintf('>> [2] TO COOLING & THERMAL TEAM:\n');
fprintf('   - Remaining Front Space for Intercooler/Radiator: %.1f mm\n\n', C_front_cooling);

fprintf('>> [3] TO STEERING TEAM:\n');
fprintf('   - Outer Front Wheel Path Radius: %.2f m\n', R_turn);
fprintf('     (Based on max inner angle of %.1f deg)\n\n', Max_Steer_deg);

fprintf('>> [4] TO HVAC (CLIMATE CONTROL) TEAM:\n');
fprintf('   - Cabin Geometric Volume: %.3f m^3\n', V_geometric);
fprintf('   - Estimated Cabin Air Volume: %.3f m^3\n', V_breathable);
disp('=================================================================');
results = struct();
results.W_total = W_total;
results.H_total = H_total;
results.C_fill = C_fill;
results.L_bay = L_bay;
results.L_engine = L_engine;
results.C_firewall = C_firewall;
results.WB = WB;
results.TW = TW;
results.Max_Steer_deg = Max_Steer_deg;
results.L_cab = L_cab;
results.W_cab = W_cab;
results.H_cab = H_cab;
results.Solid_Ratio = Solid_Ratio;
results.A_frontal = A_frontal;
results.C_front_cooling = C_front_cooling;
results.Steer_rad = Steer_rad;
results.R_rear_center = R_rear_center;
results.R_turn = R_turn;
results.V_geometric = V_geometric;
results.V_breathable = V_breathable;
end
