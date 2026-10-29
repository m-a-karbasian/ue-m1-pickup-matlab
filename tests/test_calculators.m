function tests = test_calculators
tests = functiontests(localfunctions);
end

function setupOnce(testCase)
root = fileparts(fileparts(mfilename('fullpath')));
testCase.TestData.oldPath = path;
addpath(root, fullfile(root, 'src'));
end

function teardownOnce(testCase)
path(testCase.TestData.oldPath);
end

function testAllExamplesFinite(testCase)
evalc('r = run_examples();');
modules = fieldnames(r);
verifyNumElements(testCase, modules, 8);
for k = 1:numel(modules)
    values = struct2cell(r.(modules{k}));
    verifyTrue(testCase, all(cellfun(@(x) isnumeric(x) && isscalar(x) && isfinite(x), values)));
end
end

function testMassAndForceBalance(testCase)
evalc('p = packaging_geometry(struct()); d = mass_distribution(struct());');
verifyEqual(testCase, p.GVW, 2260);
verifyEqual(testCase, p.L_f_new+p.WB+p.L_r_new, p.L_target, 'AbsTol', 1e-10);
verifyEqual(testCase, d.R_f+d.R_r, d.GVW_new*9.81, 'AbsTol', 1e-9);
verifyEqual(testCase, d.X_cargo, 2766.9, 'AbsTol', 1e-9);
end

function testAckermannRadius(testCase)
evalc("r = systems_packaging(struct('WB',3,'TW',1.6,'Max_Steer_deg',45));");
verifyEqual(testCase, r.R_turn, sqrt(3^2+4.6^2), 'AbsTol', 1e-12);
end

function testDragScaling(testCase)
evalc("a = aero_packaging(struct('V_kmh',60)); b = aero_packaging(struct('V_kmh',120));");
verifyEqual(testCase, b.F_drag/a.F_drag, 4, 'AbsTol', 1e-12);
verifyEqual(testCase, b.P_aero_W/a.P_aero_W, 8, 'AbsTol', 1e-12);
end

function testBrakeBalance(testCase)
evalc('r = suspension_brake_allocation(struct());');
verifyEqual(testCase, r.F_brake_front_axle+r.F_brake_rear_axle, r.Total_Brake_Force, 'AbsTol',1e-9);
end

function testInvalidAndUnknownInputs(testCase)
verifyError(testCase,@() systems_packaging(struct('WB',0)), 'uem1:InvalidInput');
verifyError(testCase,@() systems_packaging(struct('Max_Steer_deg',90)), 'uem1:InvalidInput');
verifyError(testCase,@() chassis_bending(struct('h',8,'t',4)), 'uem1:InvalidInput');
verifyError(testCase,@() chassis_bending(struct('nu',0.5)), 'uem1:InvalidInput');
verifyError(testCase,@() mass_distribution(struct('M_cargo',0)), 'uem1:InvalidInput');
verifyError(testCase,@() mass_distribution(struct('GVW_old',2200)), 'uem1:InvalidInput');
verifyError(testCase,@() body_ergonomics(struct('H_rail',0.2)), 'uem1:InvalidInput');
verifyError(testCase,@() packaging_geometry(struct('L_target',2000)), 'uem1:InvalidInput');
verifyError(testCase,@() aero_packaging(struct('Typo',3)), 'uem1:UnknownParameter');
end
