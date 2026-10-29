function results = mass_distribution(params)
%MASS_DISTRIBUTION Concept-stage UE-M1 calculator derived from B0_Pkg_Calc_2.m.
%   mass_distribution() prompts for values (Enter accepts each default).
%   R = mass_distribution(struct()) runs documented example defaults without prompts.
%   R = mass_distribution(struct('field', value)) overrides selected inputs.
%   Results include inputs and calculated quantities in original variable units.
interactive = nargin == 0;
if interactive, params = struct(); end
validateattributes(params, {'struct'}, {'scalar'});
allowed = {'WB', 'TW', 'M_curb', 'X_curb', 'M_cargo', 'GVW_old', 'X_old_cg', 'M_pax', 'X_pax', 'Y_cargo'};
unknown = setdiff(fieldnames(params), allowed);
if ~isempty(unknown)
    error('uem1:UnknownParameter', 'Unknown parameter: %s', unknown{1});
end
% =========================================================================
% TOOL NAME: B0 Platform Mass Distribution & Dynamics Analyzer
% PURPOSE: Automated calculation of CG shifts, Axle Loads, and Lateral Transfer
% VERSION: 1.0 (Development Phase)
% AUTHOR: گروه طراحی پیکاپ (Pickup Design Team)
% =========================================================================



disp('=================================================================');
disp('         B0 Platform Mass Distribution & Dynamics Analyzer');
disp('=================================================================');

%% Inputs
WB = read_parameter(params, 'WB', 'Enter Wheelbase (mm) [e.g., 2905]: ', 2905, interactive);
TW = read_parameter(params, 'TW', 'Enter Track Width (mm) [e.g., 1500]: ', 1500, interactive);

M_curb = read_parameter(params, 'M_curb', 'Enter Curb Weight (kg) [e.g., 1300]: ', 1300, interactive);
X_curb = read_parameter(params, 'X_curb', 'Enter Unloaded CG Distance from Front Axle (mm) [e.g., 1118.4]: ', 1118.4, interactive);

M_cargo = read_parameter(params, 'M_cargo', 'Enter Cargo Weight (kg) [e.g., 800]: ', 800, interactive);
GVW_old = read_parameter(params, 'GVW_old', 'Enter Old GVW for Calibration (kg) [e.g., 2100]: ', 2100, interactive);
X_old_cg = read_parameter(params, 'X_old_cg', 'Enter Old Loaded CG Distance from Front Axle (mm) [e.g., 1746.4]: ', 1746.4, interactive);

M_pax = read_parameter(params, 'M_pax', 'Enter Passengers Weight (kg) [e.g., 160]: ', 160, interactive);
X_pax = read_parameter(params, 'X_pax', 'Enter Passengers H-Point from Front Axle (mm) [e.g., 1200]: ', 1200, interactive);

Y_cargo = read_parameter(params, 'Y_cargo', 'Enter Worst-case Lateral Cargo Offset (mm) [e.g., 536.75]: ', 536.75, interactive);

require_condition(M_cargo > 0, 'Cargo mass must be positive for inverse CG calibration.');
require_condition(abs(GVW_old-M_curb-M_cargo) < 1e-6, 'Old GVW must equal curb plus cargo mass; calibration excludes passengers.');

%% Calculations
% 1. Cargo CG Location (Reverse Engineering)
X_cargo = ((GVW_old * X_old_cg) - (M_curb * X_curb)) / M_cargo;

% 2. New Longitudinal CG Location
GVW_new = M_curb + M_pax + M_cargo;
X_cg_new = ((M_curb * X_curb) + (M_pax * X_pax) + (M_cargo * X_cargo)) / GVW_new;
Delta_X_cg = X_cg_new - X_curb;

% 3. Static Axle Loads
g = 9.81;
W_total = GVW_new * g;
R_r = W_total * (X_cg_new / WB);
R_f = W_total * ((WB - X_cg_new) / WB);

% 4. Lateral CG Shift & Asymmetric Load Transfer
Y_cg_new = (M_cargo * Y_cargo) / GVW_new;
Delta_R_lateral = W_total * (Y_cg_new / TW);

%% Output Report
disp(' ');
disp('=================================================================');
disp('                    FINAL DYNAMICS REPORT                        ');
disp('=================================================================');

fprintf('>> [1] CARGO POSITIONING:\n');
fprintf('   - Cargo Center of Gravity from Front Axle: %.1f mm\n\n', X_cargo);

fprintf('>> [2] LONGITUDINAL CG SHIFT:\n');
fprintf('   - New Loaded CG from Front Axle: %.2f mm\n', X_cg_new);
fprintf('   - Longitudinal CG Shift: %.2f mm\n\n', Delta_X_cg);

fprintf('>> [3] STATIC AXLE LOADS (NEW GVW = %d kg):\n', GVW_new);
fprintf('   - Front Axle Load (Rf): %.1f N\n', R_f);
fprintf('   - Rear Axle Load (Rr): %.1f N\n\n', R_r);

fprintf('>> [4] LATERAL SHIFT (WORST-CASE SCENARIO):\n');
fprintf('   - Lateral CG Deviation from Centerline: %.1f mm\n', Y_cg_new);
fprintf('   - Extra Static Load on One Side Suspension: %.1f N\n', Delta_R_lateral);
disp('=================================================================');
results = struct();
results.WB = WB;
results.TW = TW;
results.M_curb = M_curb;
results.X_curb = X_curb;
results.M_cargo = M_cargo;
results.GVW_old = GVW_old;
results.X_old_cg = X_old_cg;
results.M_pax = M_pax;
results.X_pax = X_pax;
results.Y_cargo = Y_cargo;
results.X_cargo = X_cargo;
results.GVW_new = GVW_new;
results.X_cg_new = X_cg_new;
results.Delta_X_cg = Delta_X_cg;
results.g = g;
results.W_total = W_total;
results.R_r = R_r;
results.R_f = R_f;
results.Y_cg_new = Y_cg_new;
results.Delta_R_lateral = Delta_R_lateral;
end
