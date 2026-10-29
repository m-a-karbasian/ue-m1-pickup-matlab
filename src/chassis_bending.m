function results = chassis_bending(params)
%CHASSIS_BENDING Concept-stage UE-M1 calculator derived from Faze1.m.
%   chassis_bending() prompts for values (Enter accepts each default).
%   R = chassis_bending(struct()) runs documented example defaults without prompts.
%   R = chassis_bending(struct('field', value)) overrides selected inputs.
%   Results include inputs and calculated quantities in original variable units.
interactive = nargin == 0;
if interactive, params = struct(); end
validateattributes(params, {'struct'}, {'scalar'});
allowed = {'Rf', 'X_cg', 'Sy', 'FS', 'E', 'nu', 'h', 'b', 't'};
unknown = setdiff(fieldnames(params), allowed);
if ~isempty(unknown)
    error('uem1:UnknownParameter', 'Unknown parameter: %s', unknown{1});
end
% =========================================================================
% B0 Platform - Interactive Conceptual Design & Static Validation
% Module: Chassis Frame Bending & Torsional Prep
% =========================================================================


fprintf('====================================================\n');
fprintf('   B0 PLATFORM - INTERACTIVE PARAMETER INPUT\n');
fprintf('   Press [ENTER] to use the default B0 values.\n');
fprintf('====================================================\n\n');

%% 1. Hardpoints & Input Parameters (Interactive)

% Front Axle Load
Rf = read_parameter(params, 'Rf', 'Front axle static load at GVW (N) [Default: 9137]: ', 9137, interactive);

% CG Distance
X_cg = read_parameter(params, 'X_cg', 'CG distance from front axle at GVW (m) [Default: 1.7077]: ', 1.7077, interactive);

% Yield Strength
Sy = read_parameter(params, 'Sy', 'Yield strength of St52 Steel (Pa) [Default: 350e6]: ', 350e6, interactive);

% Factor of Safety
FS = read_parameter(params, 'FS', 'Factor of Safety [Default: 2.0]: ', 2.0, interactive);

% Young's Modulus
E = read_parameter(params, 'E', 'Young''s Modulus for Steel (Pa) [Default: 200e9]: ', 200e9, interactive);

% Poisson's Ratio (Calibrated value = 0.25)
nu = read_parameter(params, 'nu', 'Poisson''s ratio [Default: 0.25]: ', 0.25, interactive);

%% 1.1 Proposed C-Section Properties (Interactive)
fprintf('\n--- C-Section Geometry ---\n');

h = read_parameter(params, 'h', 'Total height (h) in mm [Default: 150]: ', 150, interactive);

b = read_parameter(params, 'b', 'Flange width (b) in mm [Default: 60]: ', 60, interactive);

t = read_parameter(params, 't', 'Web/Flange thickness (t) in mm [Default: 4]: ', 4, interactive);

fprintf('\n[+] Processing computations...\n\n');

require_condition(h > 2*t && b > t, 'C-section requires h > 2*t and b > t.');

%% 2. Maximum Bending Moment Calculation
% Modeling the chassis as a simply supported beam with load at CG
M_max = Rf * X_cg;      % Total maximum bending moment (N.m)
M_rail = M_max / 2;     % Bending moment per longitudinal rail (N.m)

%% 3. Required Section Modulus (Z_req)
Sigma_allow = Sy / FS;              % Allowable stress (Pa)
Z_req_m3 = M_rail / Sigma_allow;    % Required section modulus (m^3)
Z_req_cm3 = Z_req_m3 * 1e6;         % Convert to cm^3 for standard tables

%% 4. Section Properties Calculation
% Area Moment of Inertia (I_x) calculation for C-Channel
I_x_mm4 = (b * h^3 - (b - t) * (h - 2*t)^3) / 12;
I_x_cm4 = I_x_mm4 / 10^4;           % Convert to cm^4

% Section Modulus (Z_x) calculation
Z_x_cm3 = I_x_mm4 / (h / 2) / 1000; % Convert directly to cm^3

%% 5. Shear Modulus (G) Calibration for Torsional Cross-Members
% Preparing G for the lateral dynamics analysis
G = E / (2 * (1 + nu));             % Shear modulus (Pa)
G_GPa = G / 1e9;                    % Convert to GPa

%% 6. Validation Check & Console Output
fprintf('====================================================\n');
fprintf('     B0 PLATFORM - SIMPLIFIED BEAM SECTION CHECK\n');
fprintf('====================================================\n\n');

fprintf('[+] Bending Moment Analysis:\n');
fprintf('    Total Max Moment (M_max):      %.2f N.m\n', M_max);
fprintf('    Moment per Rail (M_rail):      %.2f N.m\n\n', M_rail);

fprintf('[+] Material & Safety:\n');
fprintf('    Allowable Stress (St52, FS=%.1f): %.2f MPa\n', FS, Sigma_allow/1e6);
fprintf('    Required Section Modulus:      %.2f cm^3\n\n', Z_req_cm3);

fprintf('[+] C-Section Validation (%dx%dx%d mm):\n', h, b, t);
fprintf('    Calculated Inertia (I_x):      %.2f cm^4\n', I_x_cm4);
fprintf('    Actual Section Modulus (Z_x):  %.2f cm^3\n', Z_x_cm3);

fprintf('\n>>> STRUCTURAL DECISION: ');
if Z_x_cm3 >= Z_req_cm3
    fprintf('PASSED (Z_x >= Z_req) <<<\n');
    fprintf('    The section meets the simplified elastic bending criterion only.\n');
else
    fprintf('FAILED (Z_x < Z_req) <<<\n');
    fprintf('    WARNING: Section redesign required to prevent yielding.\n');
end

fprintf('\n[+] Torsional Prep:\n');
fprintf('    Calculated Shear Modulus (G):  %.2f GPa\n', G_GPa);
fprintf('====================================================\n');
results = struct();
results.Rf = Rf;
results.X_cg = X_cg;
results.Sy = Sy;
results.FS = FS;
results.E = E;
results.nu = nu;
results.h = h;
results.b = b;
results.t = t;
results.M_max = M_max;
results.M_rail = M_rail;
results.Sigma_allow = Sigma_allow;
results.Z_req_m3 = Z_req_m3;
results.Z_req_cm3 = Z_req_cm3;
results.I_x_mm4 = I_x_mm4;
results.I_x_cm4 = I_x_cm4;
results.Z_x_cm3 = Z_x_cm3;
results.G = G;
results.G_GPa = G_GPa;
end
