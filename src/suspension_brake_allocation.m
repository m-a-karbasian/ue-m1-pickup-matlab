function results = suspension_brake_allocation(params)
%SUSPENSION_BRAKE_ALLOCATION Concept-stage UE-M1 calculator derived from Faze2.m.
%   suspension_brake_allocation() prompts for values (Enter accepts each default).
%   R = suspension_brake_allocation(struct()) runs documented example defaults without prompts.
%   R = suspension_brake_allocation(struct('field', value)) overrides selected inputs.
%   Results include inputs and calculated quantities in original variable units.
interactive = nargin == 0;
if interactive, params = struct(); end
validateattributes(params, {'struct'}, {'scalar'});
allowed = {'W_rear_empty', 'W_rear_full', 'Track_width', 'Delta_Fz_static', 'Delta_Fz_dyn_lat', 'Total_Brake_Force', 'Fz_front_dyn', 'Fz_rear_dyn', 'R_dyn'};
unknown = setdiff(fieldnames(params), allowed);
if ~isempty(unknown)
    error('uem1:UnknownParameter', 'Unknown parameter: %s', unknown{1});
end
% =========================================================================
% B0 Platform - Interactive Dynamic Validation & Calibration
% File Name: B0_Dynamic_Validation.m
% =========================================================================


fprintf('====================================================\n');
fprintf('   B0 PLATFORM - DYNAMIC INTERACTIVE INPUT\n');
fprintf('   (Press [ENTER] to keep the default project values)\n');
fprintf('====================================================\n\n');

%% 1. Interactive Hardpoints & Input Parameters

% Static Loads
W_rear_empty = read_parameter(params, 'W_rear_empty', 'Rear axle static load (Curb) [Default: 4908 N]: ', 4908, interactive);

W_rear_full = read_parameter(params, 'W_rear_full', 'Rear axle static load (GVW) [Default: 13033 N]: ', 13033, interactive);

% Lateral Dynamics
Track_width = read_parameter(params, 'Track_width', 'Rear track width (m) [Default: 1.5]: ', 1.5, interactive);

Delta_Fz_static = read_parameter(params, 'Delta_Fz_static', 'Static lateral transfer (N) [Default: 2808]: ', 2808, interactive);

Delta_Fz_dyn_lat = read_parameter(params, 'Delta_Fz_dyn_lat', 'Dynamic lateral transfer (N) [Default: 6500]: ', 6500, interactive);

% Braking Dynamics
Total_Brake_Force = read_parameter(params, 'Total_Brake_Force', 'Total required braking force (N) [Default: 16961]: ', 16961, interactive);

Fz_front_dyn = read_parameter(params, 'Fz_front_dyn', 'Dynamic load front axle (N) [Default: 13097]: ', 13097, interactive);

Fz_rear_dyn = read_parameter(params, 'Fz_rear_dyn', 'Dynamic load rear axle (N) [Default: 8770]: ', 8770, interactive);

R_dyn = read_parameter(params, 'R_dyn', 'Dynamic rolling radius (m) [Default: 0.32]: ', 0.32, interactive);

require_condition(W_rear_full >= W_rear_empty, 'Loaded rear axle load must not be below curb load.');

%% 2. Calculations (As before)
F_wheel_empty = W_rear_empty / 2;             
F_wheel_full = W_rear_full / 2;               
F_helper_leaf = F_wheel_full - F_wheel_empty; 

Roll_Moment = Delta_Fz_dyn_lat * Track_width; 

Total_Dyn_Load = Fz_front_dyn + Fz_rear_dyn;
Ratio_Front = Fz_front_dyn / Total_Dyn_Load;
Ratio_Rear = Fz_rear_dyn / Total_Dyn_Load;

F_brake_front_axle = Total_Brake_Force * Ratio_Front;
F_brake_rear_axle = Total_Brake_Force * Ratio_Rear;

T_brake_front_wheel = (F_brake_front_axle / 2) * R_dyn;
T_brake_rear_wheel = (F_brake_rear_axle / 2) * R_dyn;

%% 3. Output Generation
fprintf('\n[+] 1. Rear Leaf Spring Calibration (Two-Stage):\n');
fprintf('    Primary Stage Load (per wheel):     %.1f N\n', F_wheel_empty);
fprintf('    Secondary Helper Load (per wheel):  %.1f N\n', F_helper_leaf);
fprintf('    Max Total Load (per wheel):         %.1f N\n\n', F_wheel_full);

fprintf('[+] 2. Lateral Dynamics (user-supplied load transfer):\n');
fprintf('    Critical Roll Moment:               %.1f N.m\n', Roll_Moment);
fprintf('    Roll moment estimate only; anti-roll bar sizing is not evaluated.\n\n');

fprintf('[+] 3. Braking Force Allocation (user-supplied axle loads):\n');
fprintf('    Load-proportional Front Braking Ratio:        %.2f %%\n', Ratio_Front * 100);
fprintf('    Load-proportional Rear Braking Ratio:         %.2f %%\n', Ratio_Rear * 100);
fprintf('    Front Braking Torque (per wheel):   %.1f N.m\n', T_brake_front_wheel);
fprintf('    Rear Braking Torque (per wheel):    %.1f N.m\n', T_brake_rear_wheel);
fprintf('====================================================\n');
results = struct();
results.W_rear_empty = W_rear_empty;
results.W_rear_full = W_rear_full;
results.Track_width = Track_width;
results.Delta_Fz_static = Delta_Fz_static;
results.Delta_Fz_dyn_lat = Delta_Fz_dyn_lat;
results.Total_Brake_Force = Total_Brake_Force;
results.Fz_front_dyn = Fz_front_dyn;
results.Fz_rear_dyn = Fz_rear_dyn;
results.R_dyn = R_dyn;
results.F_wheel_empty = F_wheel_empty;
results.F_wheel_full = F_wheel_full;
results.F_helper_leaf = F_helper_leaf;
results.Roll_Moment = Roll_Moment;
results.Total_Dyn_Load = Total_Dyn_Load;
results.Ratio_Front = Ratio_Front;
results.Ratio_Rear = Ratio_Rear;
results.F_brake_front_axle = F_brake_front_axle;
results.F_brake_rear_axle = F_brake_rear_axle;
results.T_brake_front_wheel = T_brake_front_wheel;
results.T_brake_rear_wheel = T_brake_rear_wheel;
end
