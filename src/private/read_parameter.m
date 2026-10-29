function value = read_parameter(params, name, prompt, default, interactive)
%READ_PARAMETER Read a finite scalar without evaluating console expressions.
if isfield(params, name)
    value = params.(name);
elseif interactive
    raw = input(sprintf('%s [Enter = %g] ', prompt, default), 's');
    if isempty(strtrim(raw)), value = default; else, value = str2double(raw); end
else
    value = default;
end
validateattributes(value, {'numeric'}, {'real','scalar','finite'}, mfilename, name);
value = double(value);
if strcmp(name, 'nu')
    require_condition(value > -1 && value < 0.5, 'Poisson ratio must be in (-1, 0.5).');
elseif strcmp(name, 'Y_cargo')
    % Signed offset from the vehicle centreline.
elseif any(strcmp(name, {'Solid_Ratio'}))
    require_condition(value >= 0 && value < 1, 'Solid ratio must be in [0, 1).');
elseif any(strcmp(name, {'Efficiency', 'C_fill'}))
    require_condition(value > 0 && value <= 1, 'Efficiency/form factor must be in (0, 1].');
elseif strcmp(name, 'AR')
    require_condition(value > 0 && value <= 100, 'Aspect ratio must be in (0, 100].');
elseif any(strcmp(name, {'Max_Steer_deg','Delta_inner_deg','Angle_windshield'}))
    require_condition(value > 0 && value < 90, 'Angle must be in (0, 90) degrees.');
elseif any(strcmp(name, {'Angle_torso','Incline_deg'}))
    require_condition(value >= 0 && value < 90, 'Angle must be in [0, 90) degrees.');
elseif any(strcmp(name, {'M_cargo','M_pax','L_f0','L_r0','C_firewall','A_bulkhead', ...
        'A_hood','T_roof','Decel_g','Delta_Fz_static','Delta_Fz_dyn_lat','V_kmh', ...
        'Cd','Headroom','H_bed_floor'}))
    require_condition(value >= 0, sprintf('%s must be nonnegative.', name));
else
    require_condition(value > 0, sprintf('%s must be positive.', name));
end
end
