# Validation record

Date: 2026-10-29

Environment: Windows, MATLAB R2025b.

Command executed from the repository root:

```matlab
r = runtests('tests');
assertSuccess(r);
```

Result: **6 test functions passed, 0 failed** in the MATLAB test output, with no assertion failure reported. All eight independent default examples were executed as part of the suite. The launcher did not return an exit status through the host session after the completed test output; a clean process exit is therefore not claimed.

Coverage:

- Every returned default quantity is a finite numeric scalar.
- Gross mass is 2260 kg; packaging length and static axle-force balances close.
- Inverse cargo CG matches the original reference calculation (2766.9 mm).
- Corrected outer-front-wheel Ackermann path matches an independently specified 45-degree example.
- Doubling speed multiplies drag force by four and aerodynamic power by eight.
- Front/rear braking forces sum to supplied total demand.
- Zero wheelbase, singular steering angle, invalid section dimensions, invalid Poisson ratio, zero cargo mass for inverse calibration, inconsistent calibration mass, invalid bed geometry, invalid target length, and unknown input fields are rejected.

The source manifest was checked against all 16 original MATLAB files (8 unique sources and their identical nested copies); every original SHA-256 remained unchanged.

The unit tests verify implementation behaviour and algebraic invariants. They do not validate the vehicle against physical experiments or regulatory requirements. Interactive console entry was reviewed in code; the automated suite exercises the parameter-struct interface.
