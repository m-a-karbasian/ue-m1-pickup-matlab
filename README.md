# UE-M1 Pickup: MATLAB Concept Calculators

Eight MATLAB calculators from a university pickup design project, covering vehicle packaging, mass distribution, simplified chassis bending, braking, and aerodynamic estimates. The original source refers to the vehicle architecture as **B0**; this repository uses **UE-M1** as the project name.

These are concept-stage analytical estimates. They do not constitute FEA, crash analysis, steering clearance validation, vehicle homologation, or production approval.

## Quick start

Open MATLAB in this repository folder and run:

```matlab
results = run_examples();  % eight independent, noninteractive default cases
```

Run an individual calculator with editable inputs:

```matlab
addpath('src');
r = powertrain_braking(struct('GVW', 2260, 'Incline_deg', 9.5));
disp(r.Brake_Force_Req);  % total vehicle braking force, N

r = packaging_geometry();  % interactive; Enter accepts a default
```

Passing `struct()` selects all defaults; a partial struct overrides only named inputs. Unknown fields, nonfinite values, vectors, and invalid input ranges are rejected. Interactive prompts accept numeric text, not MATLAB expressions. Results contain the input values and intermediate/output quantities using the variable names in each source file. Functions print a console report and return a struct; no data files are required.

## Modules

| Function in `src/` | Main calculations | Original source |
| --- | --- | --- |
| `packaging_geometry` | Overhang adjustment, tire geometry, clearance proxy, gross mass | `B0_Pkg_Calc_1.m` |
| `mass_distribution` | Inverse cargo CG, loaded CG, axle reactions, lateral static imbalance | `B0_Pkg_Calc_2.m` |
| `powertrain_braking` | Wheel tractive force, grade resistance, downhill braking demand | `B0_Pkg_Calc_3.m` |
| `systems_packaging` | Frontal area, cooling space, ideal Ackermann wheel path, cabin air volume | `B0_Pkg_Calc_4.m` |
| `body_ergonomics` | Windshield length, headroom proxy, sheet-panel mass, cargo envelope | `B0_Pkg_Calc_5.m` |
| `chassis_bending` | Two-rail simply supported beam approximation, C-section modulus, shear modulus | `Faze1.m` |
| `suspension_brake_allocation` | Rear wheel loads, helper-load increment, roll moment, brake allocation | `Faze2.m` |
| `aero_packaging` | Drag force/power, width-only steering proxy, supplied packaging values | `Faze3.m` |

No optional toolboxes are used by the calculators. Automated checks use MATLAB's unit test framework. Validation was performed in MATLAB R2025b; older releases and GNU Octave have not been checked.

## Units and assumptions

Input prompts carry units. Packaging/body geometry uses mm except area/volume inputs, while dynamics and systems calculations generally use m. Mass is kg, force N, stress Pa, torque N m, angles degrees. Do not pass millimetres to an input labelled metres. Quantities historically called `GVW` in the source are **gross mass in kg**; weight force is mass times `g = 9.81 m/s^2`.

See the [complete input reference](docs/INPUTS.md) for field names, default values, and units for all eight modules.

The defaults are independent historical examples, not a shared vehicle configuration. In particular, `Faze2`'s brake and axle-load inputs and `Faze3`'s supplied turning radius do not automatically update from the body calculators. See [engineering review](docs/ENGINEERING_REVIEW.md) before reusing results.

## Tests

From the repository root:

```matlab
testResults = runtests('tests');
assertSuccess(testResults);
```

Tests cover all eight default cases, force/mass balance, corrected steering geometry, speed scaling of drag and power, brake allocation, and invalid/inconsistent inputs. See [validation record](docs/VALIDATION.md) for the actual run result.

## Source and publication

Original author attribution: **Pickup Design Team** (preserved in source comments where present). The supplied directory contained two byte-identical copies of each MATLAB file; one copy per calculator is represented here. [Source manifest](docs/source_manifest.json) records original relative paths and SHA-256 hashes.

This package contains MATLAB code and supporting documentation. Course slides, report PDFs, handwritten calculations, and historical screenshots are excluded. Old screenshots would not reflect the revised output and may contain personal information.

No open-source license has been selected on behalf of the team. Before public publication, confirm contributor attribution and the right to publish the team code, then add a license if the contributors want to grant reuse rights. See [publication checklist](docs/PUBLISHING.md).

