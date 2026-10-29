function results = packaging_geometry(params)
%PACKAGING_GEOMETRY Concept-stage UE-M1 calculator derived from B0_Pkg_Calc_1.m.
%   packaging_geometry() prompts for values (Enter accepts each default).
%   R = packaging_geometry(struct()) runs documented example defaults without prompts.
%   R = packaging_geometry(struct('field', value)) overrides selected inputs.
%   Results include inputs and calculated quantities in original variable units.
interactive = nargin == 0;
if interactive, params = struct(); end
validateattributes(params, {'struct'}, {'scalar'});
allowed = {'WB', 'L_f0', 'L_r0', 'L_target', 'W_total', 'TW', 'W_tire', 'AR', 'D_rim_inch', 'R_dyn', 'Clearance_unloaded', 'M_curb', 'M_cargo', 'M_pax'};
unknown = setdiff(fieldnames(params), allowed);
if ~isempty(unknown)
    error('uem1:UnknownParameter', 'Unknown parameter: %s', unknown{1});
end
% =========================================================================
% TOOL NAME: B0 Platform Packaging & Geometrical Integrity Analyzer
% PURPOSE: Automated calculation of Hardpoints, Tire Deflection, and GVW
% VERSION: 1.0 (Development Phase)
% AUTHOR: ???? ????? ????? (Pickup Design Team)
% =========================================================================



disp('=================================================================');
disp('          B0 Platform Packaging & Geometrical Integrity Analyzer');
disp('=================================================================');
%% Inputs
WB = read_parameter(params, 'WB', 'Enter Wheelbase (mm) [e.g., 2905]: ', 2905, interactive);
L_f0 = read_parameter(params, 'L_f0', 'Enter Initial Front Overhang (mm) [e.g., 810]: ', 810, interactive);
L_r0 = read_parameter(params, 'L_r0', 'Enter Initial Rear Overhang (mm) [e.g., 780]: ', 780, interactive);
L_target = read_parameter(params, 'L_target', 'Enter Target Overall Length (mm) [e.g., 4530]: ', 4530, interactive);

W_total = read_parameter(params, 'W_total', 'Enter Total Vehicle Width (mm) [e.g., 1780]: ', 1780, interactive);
TW = read_parameter(params, 'TW', 'Enter Track Width (mm) [e.g., 1500]: ', 1500, interactive);

W_tire = read_parameter(params, 'W_tire', 'Enter Tire Width (mm) [e.g., 215]: ', 215, interactive);
AR = read_parameter(params, 'AR', 'Enter Aspect Ratio (%) [e.g., 65]: ', 65, interactive);
D_rim_inch = read_parameter(params, 'D_rim_inch', 'Enter Rim Diameter (inch) [e.g., 16]: ', 16, interactive);
R_dyn = read_parameter(params, 'R_dyn', 'Enter Dynamic Radius (mm) [e.g., 320]: ', 320, interactive);
Clearance_unloaded = read_parameter(params, 'Clearance_unloaded', 'Enter Static Ground Clearance (mm) [e.g., 222]: ', 222, interactive);

M_curb = read_parameter(params, 'M_curb', 'Enter Curb Weight (kg) [e.g., 1300]: ', 1300, interactive);
M_cargo = read_parameter(params, 'M_cargo', 'Enter Net Cargo Weight (kg) [e.g., 800]: ', 800, interactive);
M_pax = read_parameter(params, 'M_pax', 'Enter Passengers Weight (kg) [e.g., 160]: ', 160, interactive);

require_condition(L_target > WB && L_f0 + (L_target-WB-L_f0-L_r0)/2 >= 0 && L_r0 + (L_target-WB-L_f0-L_r0)/2 >= 0, 'Target length produces invalid overhangs.');

%% Calculations
% 1. Longitudinal
L_initial = WB + L_f0 + L_r0;
Delta_L = L_target - L_initial;
Delta_L_each = Delta_L / 2;
L_f_new = L_f0 + Delta_L_each;
L_r_new = L_r0 + Delta_L_each;

% 2. Transverse
W_tires_out = TW + W_tire; 
C_fender = (W_total - W_tires_out) / 2; 

% 3. Tire & Clearance
D_rim_mm = D_rim_inch * 25.4; 
H_sidewall = W_tire * (AR / 100); 
D_tire = D_rim_mm + (2 * H_sidewall); 
R_static = D_tire / 2; 
Delta_tire = R_static - R_dyn; 
Clearance_loaded = Clearance_unloaded - Delta_tire; 

% 4. Mass & Forces
GVW = M_curb + M_cargo + M_pax; 
g = 9.81; 
W_total_Force = GVW * g; 

%% Output Report
disp(' ');
disp('=================================================================');
disp('                      FINAL PACKAGING REPORT                     ');
disp('=================================================================');

fprintf('>> [1] LONGITUDINAL PACKAGING:\n');
fprintf('   - Initial Calculated Length: %.1f mm\n', L_initial);
fprintf('   - Total Length Adjustment: %.1f mm\n', Delta_L);
fprintf('   - Final Front Overhang (L_f): %.1f mm\n', L_f_new);
fprintf('   - Final Rear Overhang (L_r): %.1f mm\n\n', L_r_new);

fprintf('>> [2] TRANSVERSE PACKAGING:\n');
fprintf('   - Total Tires Outer Width: %.1f mm\n', W_tires_out);
fprintf('   - Fender Clearance (Each Side): %.2f mm\n\n', C_fender);

fprintf('>> [3] TIRE GEOMETRY & CLEARANCE:\n');
fprintf('   - Nominal Unloaded Tire Radius: %.2f mm\n', R_static);
fprintf('   - Tire Deflection (Loaded): %.2f mm\n', Delta_tire);
fprintf('   - Final Ground Clearance (Loaded): %.2f mm\n\n', Clearance_loaded);

fprintf('>> [4] WEIGHT & FORCES:\n');
fprintf('   - Gross Vehicle Weight (GVW): %d kg\n', GVW);
fprintf('   - Total Normal Force: %.1f N\n', W_total_Force);
disp('=================================================================');
results = struct();
results.WB = WB;
results.L_f0 = L_f0;
results.L_r0 = L_r0;
results.L_target = L_target;
results.W_total = W_total;
results.TW = TW;
results.W_tire = W_tire;
results.AR = AR;
results.D_rim_inch = D_rim_inch;
results.R_dyn = R_dyn;
results.Clearance_unloaded = Clearance_unloaded;
results.M_curb = M_curb;
results.M_cargo = M_cargo;
results.M_pax = M_pax;
results.L_initial = L_initial;
results.Delta_L = Delta_L;
results.Delta_L_each = Delta_L_each;
results.L_f_new = L_f_new;
results.L_r_new = L_r_new;
results.W_tires_out = W_tires_out;
results.C_fender = C_fender;
results.D_rim_mm = D_rim_mm;
results.H_sidewall = H_sidewall;
results.D_tire = D_tire;
results.R_static = R_static;
results.Delta_tire = Delta_tire;
results.Clearance_loaded = Clearance_loaded;
results.GVW = GVW;
results.g = g;
results.W_total_Force = W_total_Force;
end
