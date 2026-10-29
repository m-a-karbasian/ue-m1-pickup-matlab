function results = run_examples()
%RUN_EXAMPLES Run eight independent examples with original project defaults.
root = fileparts(mfilename('fullpath'));
oldPath = path;
restorePath = onCleanup(@() path(oldPath));
addpath(fullfile(root, 'src'));
modules = {'packaging_geometry', 'mass_distribution', 'powertrain_braking', ...
    'systems_packaging', 'body_ergonomics', 'chassis_bending', ...
    'suspension_brake_allocation', 'aero_packaging'};
results = struct();
for k = 1:numel(modules)
    results.(modules{k}) = feval(modules{k}, struct());
end
end
