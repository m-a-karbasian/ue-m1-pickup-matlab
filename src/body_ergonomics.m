function results = body_ergonomics(params)
%BODY_ERGONOMICS Concept-stage UE-M1 calculator derived from B0_Pkg_Calc_5.m.
%   body_ergonomics() prompts for values (Enter accepts each default).
%   R = body_ergonomics(struct()) runs documented example defaults without prompts.
%   R = body_ergonomics(struct('field', value)) overrides selected inputs.
%   Results include inputs and calculated quantities in original variable units.
interactive = nargin == 0;
if interactive, params = struct(); end
validateattributes(params, {'struct'}, {'scalar'});
allowed = {'H_windshield_v', 'Angle_windshield', 'H_total', 'H_hpt', 'Angle_torso', 'L_torso', 'T_roof', 'A_floor', 'A_roof', 'A_bulkhead', 'A_hood', 'Thickness_mm', 'L_bed', 'W_bed', 'H_rail', 'H_bed_floor'};
unknown = setdiff(fieldnames(params), allowed);
if ~isempty(unknown)
    error('uem1:UnknownParameter', 'Unknown parameter: %s', unknown{1});
end
% =========================================================================
% TOOL NAME: B0 Platform BIW, Ergonomics & Geometric Packaging Calculator
% PURPOSE: Automated calculation of Windshield, Headroom, BIW Mass & Cargo Vol
% VERSION: 1.0 (Development Phase)
% AUTHOR: گروه طراحی پیکاپ (Pickup Design Team)
% =========================================================================



disp('=================================================================');
disp('       B0 Platform BIW, Ergonomics & Geometric Packaging Tool');
disp('=================================================================');

%% Inputs
% 1. Visibility (Windshield)
H_windshield_v = read_parameter(params, 'H_windshield_v', 'Enter Windshield Vertical Height (mm) [e.g., 770]: ', 770, interactive);
Angle_windshield = read_parameter(params, 'Angle_windshield', 'Enter Windshield Angle from Horizontal (deg) [e.g., 32]: ', 32, interactive);

% 2. Ergonomics (Headroom)
H_total = read_parameter(params, 'H_total', 'Enter Total Vehicle Height (mm) [e.g., 1600]: ', 1600, interactive);
H_hpt = read_parameter(params, 'H_hpt', 'Enter H-Point Height from Ground (mm) [e.g., 540]: ', 540, interactive);
Angle_torso = read_parameter(params, 'Angle_torso', 'Enter Seat Torso Angle from Vertical (deg) [e.g., 22]: ', 22, interactive);
L_torso = read_parameter(params, 'L_torso', 'Enter 95th Percentile Torso Length (mm) [e.g., 800]: ', 800, interactive);
T_roof = read_parameter(params, 'T_roof', 'Enter Roof Structural Thickness (mm) [e.g., 40]: ', 40, interactive);

% 3. BIW Panel Mass
A_floor = read_parameter(params, 'A_floor', 'Enter Total Floor Area (m^2) [e.g., 5.8]: ', 5.8, interactive);
A_roof = read_parameter(params, 'A_roof', 'Enter Roof Area (m^2) [e.g., 2.0]: ', 2.0, interactive);
A_bulkhead = read_parameter(params, 'A_bulkhead', 'Enter Bulkhead Area (m^2) [e.g., 0.35]: ', 0.35, interactive);
A_hood = read_parameter(params, 'A_hood', 'Enter Hood Area (m^2) [e.g., 1.05]: ', 1.05, interactive);
Thickness_mm = read_parameter(params, 'Thickness_mm', 'Enter Sheet Metal Thickness (mm) [e.g., 0.8]: ', 0.8, interactive);

% 4. Cargo Capacities
L_bed = read_parameter(params, 'L_bed', 'Enter Cargo Bed Length (m) [e.g., 1.5]: ', 1.5, interactive);
W_bed = read_parameter(params, 'W_bed', 'Enter Cargo Bed Width (m) [e.g., 1.38]: ', 1.38, interactive);
H_rail = read_parameter(params, 'H_rail', 'Enter Bed Rail Height from Ground (m) [e.g., 0.8]: ', 0.8, interactive);
H_bed_floor = read_parameter(params, 'H_bed_floor', 'Enter Bed Floor Height from Ground (m) [e.g., 0.3]: ', 0.3, interactive);

require_condition(H_rail > H_bed_floor && H_total/1000 >= H_rail, 'Bed rail must be above floor and at or below roof.');

%% Calculations
% 1. Windshield Slant Length
Angle_rad_ws = deg2rad(Angle_windshield);
L_glass = H_windshield_v / sin(Angle_rad_ws);

% 2. Ergonomic Headroom
Angle_rad_torso = deg2rad(Angle_torso);
H_seated_vertical = L_torso * cos(Angle_rad_torso);
Clearance_headroom = H_total - H_hpt - H_seated_vertical - T_roof;

% 3. BIW Mass (Skin Only)
Total_Area = A_floor + A_roof + A_bulkhead + A_hood;
Thickness_m = Thickness_mm / 1000;
Density_steel = 7850; % kg/m^3
Mass_panels = Total_Area * Thickness_m * Density_steel;

% 4. Cargo Volume
Depth_bed = H_rail - H_bed_floor;
Vol_enclosed = L_bed * W_bed * Depth_bed;
H_roof_m = H_total / 1000;
Vol_max_aero = L_bed * W_bed * (H_roof_m - H_bed_floor);

%% Output Report
disp(' ');
disp('=================================================================');
disp('             FINAL BIW & ERGONOMICS HAND-OFF REPORT              ');
disp('=================================================================');

fprintf('>> [1] TO ELECTRICAL/WIPER TEAM:\n');
fprintf('   - Actual Windshield Slant Length: %.1f mm\n\n', L_glass);

fprintf('>> [2] TO INTERIOR/SEATING TEAM:\n');
fprintf('   - Raw Headroom Clearance (Metal to Head): %.1f mm\n', Clearance_headroom);
fprintf('     (Available for Headliner, Lights, and Seat Tracks)\n\n');

fprintf('>> [3] TO MANUFACTURING/STRUCTURES TEAM:\n');
fprintf('   - Total Main Panel Surface Area: %.2f m^2\n', Total_Area);
fprintf('   - Estimated Raw Panel Mass (Skin): %.1f kg\n\n', Mass_panels);

fprintf('>> [4] TO MARKETING/ACCESSORIES TEAM:\n');
fprintf('   - Cargo Volume Below Bed Rails: %.3f m^3\n', Vol_enclosed);
fprintf('   - Geometric Cargo Envelope (Up to Roof): %.3f m^3\n', Vol_max_aero);
disp('=================================================================');
results = struct();
results.H_windshield_v = H_windshield_v;
results.Angle_windshield = Angle_windshield;
results.H_total = H_total;
results.H_hpt = H_hpt;
results.Angle_torso = Angle_torso;
results.L_torso = L_torso;
results.T_roof = T_roof;
results.A_floor = A_floor;
results.A_roof = A_roof;
results.A_bulkhead = A_bulkhead;
results.A_hood = A_hood;
results.Thickness_mm = Thickness_mm;
results.L_bed = L_bed;
results.W_bed = W_bed;
results.H_rail = H_rail;
results.H_bed_floor = H_bed_floor;
results.Angle_rad_ws = Angle_rad_ws;
results.L_glass = L_glass;
results.Angle_rad_torso = Angle_rad_torso;
results.H_seated_vertical = H_seated_vertical;
results.Clearance_headroom = Clearance_headroom;
results.Total_Area = Total_Area;
results.Thickness_m = Thickness_m;
results.Density_steel = Density_steel;
results.Mass_panels = Mass_panels;
results.Depth_bed = Depth_bed;
results.Vol_enclosed = Vol_enclosed;
results.H_roof_m = H_roof_m;
results.Vol_max_aero = Vol_max_aero;
end
