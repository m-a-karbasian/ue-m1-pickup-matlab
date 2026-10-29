function results = powertrain_braking(params)
%POWERTRAIN_BRAKING Concept-stage UE-M1 calculator derived from B0_Pkg_Calc_3.m.
%   powertrain_braking() prompts for values (Enter accepts each default).
%   R = powertrain_braking(struct()) runs documented example defaults without prompts.
%   R = powertrain_braking(struct('field', value)) overrides selected inputs.
%   Results include inputs and calculated quantities in original variable units.
interactive = nargin == 0;
if interactive, params = struct(); end
validateattributes(params, {'struct'}, {'scalar'});
allowed = {'GVW', 'Incline_deg', 'T_engine', 'Gear_Ratio', 'Final_Drive', 'R_dyn', 'Efficiency', 'Decel_g'};
unknown = setdiff(fieldnames(params), allowed);
if ~isempty(unknown)
    error('uem1:UnknownParameter', 'Unknown parameter: %s', unknown{1});
end
% =========================================================================
% TOOL NAME: B0 Platform Powertrain & Braking Data Hand-off Calculator
% PURPOSE: Automated calculation of Tractive Effort, Margin, and Total Brake Force
% VERSION: 1.0 (Development Phase)
% AUTHOR: ???? ????? ????? (Pickup Design Team)
% =========================================================================



disp('=================================================================');
disp('       B0 Platform Powertrain & Braking Data Hand-off Tool');
disp('=================================================================');

%% Inputs
GVW = read_parameter(params, 'GVW', 'Enter Gross Vehicle Weight (kg) [e.g., 2260]: ', 2260, interactive);
Incline_deg = read_parameter(params, 'Incline_deg', 'Enter Road Incline (degrees) [e.g., 9.5]: ', 9.5, interactive);

T_engine = read_parameter(params, 'T_engine', 'Enter Maximum Engine Torque (Nm) [e.g., 240]: ', 240, interactive);
Gear_Ratio = read_parameter(params, 'Gear_Ratio', 'Enter 1st Gear Ratio [e.g., 2.54525]: ', 2.54525, interactive); 
Final_Drive = read_parameter(params, 'Final_Drive', 'Enter Final Drive Ratio [e.g., 4.357]: ', 4.357, interactive);
R_dyn = read_parameter(params, 'R_dyn', 'Enter Tire Dynamic Radius (m) [e.g., 0.32]: ', 0.32, interactive);
Efficiency = read_parameter(params, 'Efficiency', 'Enter Drivetrain Efficiency (0 to 1) [e.g., 0.9]: ', 0.9, interactive);

Decel_g = read_parameter(params, 'Decel_g', 'Enter Target Emergency Deceleration (in g) [e.g., 0.6]: ', 0.6, interactive);



%% Calculations
g = 9.81;
W_total = GVW * g;
Incline_rad = deg2rad(Incline_deg);

% 1. Powertrain Handoff (Tractive Effort & Grade Resistance)
Grade_Resistance = W_total * sin(Incline_rad);
Tractive_Effort = (T_engine * Gear_Ratio * Final_Drive * Efficiency) / R_dyn;
Tractive_Margin = Tractive_Effort - Grade_Resistance;

% 2. Braking System Handoff (Total Critical Braking Force)
Brake_Force_Req = W_total * (Decel_g + sin(Incline_rad));

%% Output Report
disp(' ');
disp('=================================================================');
disp('                 FINAL ENGINEERING HAND-OFF REPORT               ');
disp('=================================================================');

fprintf('>> [1] POWERTRAIN TEAM HAND-OFF:\n');
fprintf('   - Gravity Resistance at %.1f degrees: %.1f N\n', Incline_deg, Grade_Resistance);
fprintf('   - Generated Tractive Effort at Wheels: %.1f N\n', Tractive_Effort);
fprintf('   - Tractive Force Minus Grade Resistance: %.1f N\n\n', Tractive_Margin);

fprintf('>> [2] BRAKING TEAM HAND-OFF:\n');
% Adding "TOTAL" to ensure it's not confused with Front Axle only
fprintf('   - TOTAL Critical Emergency Braking Force Req: %.1f N\n', Brake_Force_Req);
fprintf('     (Based on %.1fg deceleration on %.1f deg decline)\n', Decel_g, Incline_deg);
disp('=================================================================');
results = struct();
results.GVW = GVW;
results.Incline_deg = Incline_deg;
results.T_engine = T_engine;
results.Gear_Ratio = Gear_Ratio;
results.Final_Drive = Final_Drive;
results.R_dyn = R_dyn;
results.Efficiency = Efficiency;
results.Decel_g = Decel_g;
results.g = g;
results.W_total = W_total;
results.Incline_rad = Incline_rad;
results.Grade_Resistance = Grade_Resistance;
results.Tractive_Effort = Tractive_Effort;
results.Tractive_Margin = Tractive_Margin;
results.Brake_Force_Req = Brake_Force_Req;
end
