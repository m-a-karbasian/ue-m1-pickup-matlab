# Input reference

Field names are case-sensitive. Omitted fields use these historical example defaults. Units and angle references are given by the prompt. See ENGINEERING_REVIEW.md for limitations.

## `aero_packaging`

| Input field | Default | Meaning and units |
| --- | ---: | --- |
| `A_front` | 2.307 | Frontal area (m^2) |
| `Cd` | 0.40 | Estimated Drag Coefficient |
| `V_kmh` | 120 | Cruise speed (km/h) |
| `rho` | 1.225 | Air density at sea level (kg/m^3) |
| `Delta_inner_deg` | 38 | Max inner steering angle (degrees) |
| `Tire_width_mm` | 215 | Tire section width (mm) |
| `Turning_radius` | 5.47 | Turning radius (m) |
| `Skin_mass` | 57.8 | BIW Skin mass (kg) |
| `Cabin_volume` | 2.274 | HVAC cabin volume (m^3) |
| `Headroom` | 278.3 | Ergonomic headroom (mm) |

## `body_ergonomics`

| Input field | Default | Meaning and units |
| --- | ---: | --- |
| `H_windshield_v` | 770 | Windshield Vertical Height (mm) |
| `Angle_windshield` | 32 | Windshield Angle from Horizontal (deg) |
| `H_total` | 1600 | Total Vehicle Height (mm) |
| `H_hpt` | 540 | H-Point Height from Ground (mm) |
| `Angle_torso` | 22 | Seat Torso Angle from Vertical (deg) |
| `L_torso` | 800 | 95th Percentile Torso Length (mm) |
| `T_roof` | 40 | Roof Structural Thickness (mm) |
| `A_floor` | 5.8 | Total Floor Area (m^2) |
| `A_roof` | 2.0 | Roof Area (m^2) |
| `A_bulkhead` | 0.35 | Bulkhead Area (m^2) |
| `A_hood` | 1.05 | Hood Area (m^2) |
| `Thickness_mm` | 0.8 | Sheet Metal Thickness (mm) |
| `L_bed` | 1.5 | Cargo Bed Length (m) |
| `W_bed` | 1.38 | Cargo Bed Width (m) |
| `H_rail` | 0.8 | Bed Rail Height from Ground (m) |
| `H_bed_floor` | 0.3 | Bed Floor Height from Ground (m) |

## `chassis_bending`

| Input field | Default | Meaning and units |
| --- | ---: | --- |
| `Rf` | 9137 | Front axle static load at GVW (N) |
| `X_cg` | 1.7077 | CG distance from front axle at GVW (m) |
| `Sy` | 350e6 | Yield strength of St52 Steel (Pa) |
| `FS` | 2.0 | Factor of Safety |
| `E` | 200e9 | Young's Modulus for Steel (Pa) |
| `nu` | 0.25 | Poisson's ratio |
| `h` | 150 | Total height (h) in mm |
| `b` | 60 | Flange width (b) in mm |
| `t` | 4 | Web/Flange thickness (t) in mm |

## `mass_distribution`

| Input field | Default | Meaning and units |
| --- | ---: | --- |
| `WB` | 2905 | Wheelbase (mm) |
| `TW` | 1500 | Track Width (mm) |
| `M_curb` | 1300 | Curb Weight (kg) |
| `X_curb` | 1118.4 | Unloaded CG Distance from Front Axle (mm) |
| `M_cargo` | 800 | Cargo Weight (kg) |
| `GVW_old` | 2100 | Old GVW for Calibration (kg) |
| `X_old_cg` | 1746.4 | Old Loaded CG Distance from Front Axle (mm) |
| `M_pax` | 160 | Passengers Weight (kg) |
| `X_pax` | 1200 | Passengers H-Point from Front Axle (mm) |
| `Y_cargo` | 536.75 | Worst-case Lateral Cargo Offset (mm) |

## `packaging_geometry`

| Input field | Default | Meaning and units |
| --- | ---: | --- |
| `WB` | 2905 | Wheelbase (mm) |
| `L_f0` | 810 | Initial Front Overhang (mm) |
| `L_r0` | 780 | Initial Rear Overhang (mm) |
| `L_target` | 4530 | Target Overall Length (mm) |
| `W_total` | 1780 | Total Vehicle Width (mm) |
| `TW` | 1500 | Track Width (mm) |
| `W_tire` | 215 | Tire Width (mm) |
| `AR` | 65 | Aspect Ratio (%) |
| `D_rim_inch` | 16 | Rim Diameter (inch) |
| `R_dyn` | 320 | Dynamic Radius (mm) |
| `Clearance_unloaded` | 222 | Static Ground Clearance (mm) |
| `M_curb` | 1300 | Curb Weight (kg) |
| `M_cargo` | 800 | Net Cargo Weight (kg) |
| `M_pax` | 160 | Passengers Weight (kg) |

## `powertrain_braking`

| Input field | Default | Meaning and units |
| --- | ---: | --- |
| `GVW` | 2260 | Gross Vehicle Weight (kg) |
| `Incline_deg` | 9.5 | Road Incline (degrees) |
| `T_engine` | 240 | Maximum Engine Torque (Nm) |
| `Gear_Ratio` | 2.54525 | 1st Gear Ratio |
| `Final_Drive` | 4.357 | Final Drive Ratio |
| `R_dyn` | 0.32 | Tire Dynamic Radius (m) |
| `Efficiency` | 0.9 | Drivetrain Efficiency (0 to 1) |
| `Decel_g` | 0.6 | Target Emergency Deceleration (in g) |

## `suspension_brake_allocation`

| Input field | Default | Meaning and units |
| --- | ---: | --- |
| `W_rear_empty` | 4908 | Rear axle static load (Curb) |
| `W_rear_full` | 13033 | Rear axle static load (GVW) |
| `Track_width` | 1.5 | Rear track width (m) |
| `Delta_Fz_static` | 2808 | Static lateral transfer (N) |
| `Delta_Fz_dyn_lat` | 6500 | Dynamic lateral transfer (N) |
| `Total_Brake_Force` | 16961 | Total required braking force (N) |
| `Fz_front_dyn` | 13097 | Dynamic load front axle (N) |
| `Fz_rear_dyn` | 8770 | Dynamic load rear axle (N) |
| `R_dyn` | 0.32 | Dynamic rolling radius (m) |

## `systems_packaging`

| Input field | Default | Meaning and units |
| --- | ---: | --- |
| `W_total` | 1.78 | Total Vehicle Width (m) |
| `H_total` | 1.60 | Total Vehicle Height (m) |
| `C_fill` | 0.81 | Aerodynamic Form Factor |
| `L_bay` | 1450 | Available Engine Bay Length (mm) |
| `L_engine` | 650 | Engine Block Length (mm) |
| `C_firewall` | 150 | Required Firewall Clearance (mm) |
| `WB` | 2.905 | Wheelbase (m) |
| `TW` | 1.500 | Track Width (m) |
| `Max_Steer_deg` | 38 | Max Inner Wheel Angle (deg) |
| `L_cab` | 1.85 | Cabin Floor Length (m) |
| `W_cab` | 1.49 | Cabin Floor Width (m) |
| `H_cab` | 1.10 | Cabin Average Internal Height (m) |
| `Solid_Ratio` | 0.25 | Solid Objects Ratio in Cabin (0 to 1) |
