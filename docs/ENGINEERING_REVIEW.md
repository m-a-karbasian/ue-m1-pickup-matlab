# Engineering review

## Changes to calculations and behaviour

- `systems_packaging`: replaced `WB/sin(inner_angle) + TW/2` with ideal Ackermann geometry for the **outer front wheel path**. Rear axle centre radius is `WB/tan(inner_angle) + TW/2`; outer front radius is `sqrt(WB^2 + (WB/tan(inner_angle) + TW)^2)`. This is a wheel-centre path radius; body overhang and tire width are excluded. It is not a wall-to-wall turning radius.
- Eight workspace-clearing scripts became functions accepting partial input structs and returning computed quantities. Direct calls without arguments remain interactive. Input is read as text to avoid expression evaluation. Caller variables, figures, and the command window are preserved.
- Added scalar/finite/range checks, unknown-field detection, valid channel geometry, inverse-CG mass consistency, and valid cargo-bed heights. Input errors stop the calculation; there is no silent clamping.
- Removed unsupported assertions of production validation, clash-free steering, mandatory anti-roll bar installation, and engine reserve power. A beam section check is labelled as such rather than FEA. Brake ratios are described as load-proportional, not an optimization.
- Clarified angle references, nominal tire radius, cabin air volume, geometric cargo envelope, and the force margin label. Original variable names are retained to ease comparison.

## Model limitations retained and documented

1. **Packaging:** overhang changes are divided equally; this is a design assumption. Nominal unloaded tire radius minus rolling radius is only a clearance-loss proxy. Rolling radius is not generally a loaded static radius, and suspension sag is omitted. Negative calculated clearances indicate an infeasible concept and are returned for inspection.
2. **Mass distribution:** inverse cargo CG assumes the old mass equals curb plus cargo, with no passengers. Longitudinal CG is measured rearwards from the front axle. `Y_cargo` is signed from the centreline. `Delta_R_lateral` is the increment/decrement relative to half of total weight on each side; the right-minus-left difference is twice that value. No axle-specific roll stiffness is used.
3. **Powertrain/brakes:** grade resistance is uphill; braking demand uses the same slope magnitude for downhill deceleration. Rolling resistance, air drag in the tractive margin, tire adhesion, power/speed limits, brake thermal capacity, and brake hardware are omitted.
4. **Systems:** frontal area uses a fill factor; cabin volume is a box approximation less a solid-volume fraction. Cooling space is a longitudinal remainder, not a thermal or CAD fit check. Turning geometry assumes ideal low-speed Ackermann steering with equal front/rear track.
5. **Body/ergonomics:** windshield angle is from horizontal; torso angle is from vertical. The supplied torso length is only a headroom proxy, not a full anthropometric occupant model. Steel skin mass excludes structural members, joining, openings and reinforcements. Cargo volumes are rectangular geometric envelopes, not payload or aerodynamic capacity.
6. **Chassis:** one equivalent point load at CG on a simply supported beam, split equally between two rails. No wheelbase/load-distribution consistency is verified here because only reaction and lever arm are supplied. Section modulus checks elastic bending only; shear, deflection, fatigue, buckling, joints, impact and torsion are not assessed. Material properties are user assumptions, not verified grade certificates.
7. **Suspension:** helper-load increment is not spring stiffness or travel sizing. `Delta_Fz_dyn_lat` is assumed to be load shifted from one side to the other, so roll moment is transfer times track. The static and dynamic transfer inputs are not added automatically because their scenario relationship is unspecified. Front/rear brake allocation uses supplied normal-load fractions and assumes equal adhesion. Original `Delta_Fz_static` is retained as an input/report quantity, not used to infer anti-roll sizing.
8. **Aero/steering:** aerodynamic power excludes rolling resistance and drivetrain loss. The inherited `tire_width*sin(steering_angle)` expression is retained as a clearly labelled width-only proxy; tire diameter, pivot position, scrub radius, wheel offset, suspension travel and swept envelope are needed for a real clash check. Turning radius, skin mass, cabin volume, and headroom in this module are supplied values, not recomputed validations.

## Inconsistent historical defaults

Defaults intentionally remain independent for traceability. The mass calculator totals 2260 kg, while the dynamic axle loads in `suspension_brake_allocation` sum to 21867 N (about 2229.1 kg). Brake demand there is supplied as 16961 N and is not recomputed from slope. `aero_packaging` retains the supplied 5.47 m turning radius; this differs from the newly corrected ideal outer-front-wheel radius. Shared configuration and inter-module synchronization have not been invented.

The repository is suitable for documenting and exploring the course calculations. Engineering decisions need further analysis and project-specific evidence.
