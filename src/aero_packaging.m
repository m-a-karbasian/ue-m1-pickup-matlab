function results = aero_packaging(params)
%AERO_PACKAGING Concept-stage UE-M1 calculator derived from Faze3.m.
%   aero_packaging() prompts for values (Enter accepts each default).
%   R = aero_packaging(struct()) runs documented example defaults without prompts.
%   R = aero_packaging(struct('field', value)) overrides selected inputs.
%   Results include inputs and calculated quantities in original variable units.
interactive = nargin == 0;
if interactive, params = struct(); end
validateattributes(params, {'struct'}, {'scalar'});
allowed = {'A_front', 'Cd', 'V_kmh', 'rho', 'Delta_inner_deg', 'Tire_width_mm', 'Turning_radius', 'Skin_mass', 'Cabin_volume', 'Headroom'};
unknown = setdiff(fieldnames(params), allowed);
if ~isempty(unknown)
    error('uem1:UnknownParameter', 'Unknown parameter: %s', unknown{1});
end
% =========================================================================
% B0 Platform - Interactive Final Validation
% File Name: B0_Aero_Ergo_Validation.m
% Module: Aerodynamics, Steering Clash Check & BIW Mass
% =========================================================================


fprintf('====================================================\n');
fprintf('   B0 PLATFORM - AERO & ERGO INTERACTIVE INPUT\n');
fprintf('   (Press [ENTER] to keep the default project values)\n');
fprintf('====================================================\n\n');

%% 1. Interactive Input Parameters

fprintf('--- Aerodynamic Data ---\n');
A_front = read_parameter(params, 'A_front', 'Frontal area (m^2) [Default: 2.307]: ', 2.307, interactive);

Cd = read_parameter(params, 'Cd', 'Estimated Drag Coefficient [Default: 0.40]: ', 0.40, interactive);

V_kmh = read_parameter(params, 'V_kmh', 'Cruise speed (km/h) [Default: 120]: ', 120, interactive);

rho = read_parameter(params, 'rho', 'Air density at sea level (kg/m^3) [Default: 1.225]: ', 1.225, interactive);

fprintf('\n--- Steering & Kinematics Data ---\n');
Delta_inner_deg = read_parameter(params, 'Delta_inner_deg', 'Max inner steering angle (degrees) [Default: 38]: ', 38, interactive);

Tire_width_mm = read_parameter(params, 'Tire_width_mm', 'Tire section width (mm) [Default: 215]: ', 215, interactive);

Turning_radius = read_parameter(params, 'Turning_radius', 'Turning radius (m) [Default: 5.47]: ', 5.47, interactive);

fprintf('\n--- BIW & Packaging Data ---\n');
Skin_mass = read_parameter(params, 'Skin_mass', 'BIW Skin mass (kg) [Default: 57.8]: ', 57.8, interactive);

Cabin_volume = read_parameter(params, 'Cabin_volume', 'HVAC cabin volume (m^3) [Default: 2.274]: ', 2.274, interactive);

Headroom = read_parameter(params, 'Headroom', 'Ergonomic headroom (mm) [Default: 278.3]: ', 278.3, interactive);

fprintf('\n[+] Processing computations...\n\n');



%% 2. Aerodynamic Drag & Power Required
V_ms = V_kmh / 3.6;                                            % Convert to m/s
F_drag = 0.5 * rho * (V_ms^2) * Cd * A_front;                  % Aero drag force (N)
P_aero_W = F_drag * V_ms;                                      % Power to overcome drag (W)
P_aero_kW = P_aero_W / 1000;                                   % Power in kW
P_aero_HP = P_aero_kW * 1.341;                                 % Power in Horsepower

%% 3. Steering Clash Clearance Loss Calculation
% Lateral displacement of tire inner edge at max steering angle
Clearance_loss_mm = Tire_width_mm * sind(Delta_inner_deg);

%% 4. Console Output Generation
fprintf('====================================================\n');
fprintf('     B0 PLATFORM - AERO, STEERING & BIW VALIDATION\n');
fprintf('====================================================\n\n');

fprintf('[+] 1. Aerodynamic Analysis (@ %.1f km/h):\n', V_kmh);
fprintf('    Frontal Area:                   %.3f m^2\n', A_front);
fprintf('    Aero Drag Force:                %.1f N\n', F_drag);
fprintf('    Power Loss to Aero Drag:        %.1f kW (%.1f HP)\n', P_aero_kW, P_aero_HP);
fprintf('    Aero power only; engine reserve power is not evaluated.\n\n');

fprintf('[+] 2. Steering & Clash Check:\n');
fprintf('    Turning Radius:                 %.2f m\n', Turning_radius);
fprintf('    Max Steering Angle:             %d deg\n', Delta_inner_deg);
fprintf('    Width-only Steering Proxy:      %.1f mm\n', Clearance_loss_mm);
fprintf('    Width-only proxy; steering clash requires swept-volume geometry.\n\n');

fprintf('[+] 3. Packaging & Ergonomics:\n');
fprintf('    Skin BIW Mass (0.8mm thick):    %.1f kg\n', Skin_mass);
fprintf('    HVAC Cabin Volume:              %.3f m^3\n', Cabin_volume);
fprintf('    Headroom Clearance:             %.1f mm\n', Headroom);
fprintf('====================================================\n');
fprintf('      CONCEPT ESTIMATES ONLY - NOT PRODUCTION VALIDATION\n');
fprintf('====================================================\n');
results = struct();
results.A_front = A_front;
results.Cd = Cd;
results.V_kmh = V_kmh;
results.rho = rho;
results.Delta_inner_deg = Delta_inner_deg;
results.Tire_width_mm = Tire_width_mm;
results.Turning_radius = Turning_radius;
results.Skin_mass = Skin_mass;
results.Cabin_volume = Cabin_volume;
results.Headroom = Headroom;
results.V_ms = V_ms;
results.F_drag = F_drag;
results.P_aero_W = P_aero_W;
results.P_aero_kW = P_aero_kW;
results.P_aero_HP = P_aero_HP;
results.Clearance_loss_mm = Clearance_loss_mm;
end
