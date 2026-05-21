# Complex Reflection Analysis

Overview
- This project computes and visualizes the normal-incidence reflection (in dB) from a stack of planar layers using complex permittivity and permeability. The Lua program numerically evaluates the input impedance of a multilayer structure using transmission-line formulas and plots reflection magnitude versus frequency (1–25 GHz) for 1..3 layered stacks.

Files
- main.lua — the Lua/raylib program (contains complex arithmetic, physical model, and plotting).
- bg.fs (not required) — optional shader (not used here).
- README.md — this document.

Physical background (concise)
- Electromagnetic waves in linear, homogeneous, isotropic media are described by Maxwell's equations. For plane-wave propagation in a nonmagnetic, lossy dielectric with complex permittivity ε = ε' - jε'' and complex permeability μ = μ' - jμ'', the wave number and intrinsic impedance are complex:
  - Angular frequency ω = 2πf.
  - Complex propagation constant γ = jω√(με) for lossless sign conventions; more generally γ = jω√(με), where square root yields a complex value producing attenuation and phase shift.
  - Intrinsic impedance η = √(μ/ε). For free space η0 = √(μ0/ε0) ≈ 377 Ω.
- A plane wave normally incident on a layered medium can be modeled by cascading transmission-line sections. Each layer of thickness h, complex ε and μ has a characteristic impedance Zc = η = √(μ/ε) and a phase/attenuation term exp(±γh). For normal incidence the input impedance seen looking into a layer terminated by impedance Zin_next is:
  Zin = Zc * (Zin_next + Zc tanh(γ h)) / (Zc + Zin_next tanh(γ h))
  (this is the form used in the code, using hyperbolic tangent for the complex propagation product γh).
- Reflection coefficient at the interface to free space (Z0) is:
  Γ = (Zin - Z0) / (Zin + Z0)
  Reflection level in decibels: 20·log10(|Γ|).

Complex permittivity and permeability
- Lossy materials are represented by complex-valued ε and μ. The imaginary parts model absorption (dielectric loss, magnetic loss).
- In the code example layers use approximate values (example only):
  - Layer 1: ε = 10 - j0.001, μ = 3 - j0.0011, h = 3 mm
  - Layer 2: ε = 2 - j1.0, μ = 1, h = 0.5 mm
  - Layer 3: ε = 2 - j0.3, μ = 1, h = 0.5 mm
- These are illustrative; realistic material data must come from measurements or published material databases.

Numerical model implemented
- Frequency sweep: 1 GHz to 25 GHz (200 sample points).
- For each frequency and for layer counts 1..3:
  - Compute ω.
  - Compute layer characteristic impedance Zc = √(μ/ε) (complex).
  - Compute γh = j·(ω/c0)·h·√(με). This places the imaginary unit in a factor so tanh(γh) models propagation/attenuation.
  - Use recursive formula to fold layers from the last toward the first, starting from free-space impedance Z0.
  - Compute reflection Γ and return 20·log10(|Γ|).

Code notes and mapping to formulas
- complex.sqrt: implements principal square root for complex numbers.
- complex.tanh: computes hyperbolic tangent of a complex argument from real sinh/cosh and sin/cos identities.
- get_reflection_db:
  - Z0 = sqrt(μ0/ε0), c0 = 1/sqrt(ε0μ0)
  - For each layer L:
    - zc = sqrt(L.mu / L.eps)    (η = √(μ/ε))
    - sqrt_me = sqrt(L.mu * L.eps)
    - imag_factor = j * (ω * h / c0)
    - gam_h = imag_factor * sqrt_me  (equivalent to j·(ω/c)·h·√(με))
    - th = tanh(gam_h)
    - Update zin with the transmission-line section formula.
  - Γ = (zin - Z0)/(zin + Z0), return 20·log10(|Γ|).

Assumptions, approximations, and caveats
- Normal incidence only (no oblique angles, no polarization splitting).
- Homogeneous, isotropic planar layers (no roughness, no anisotropy).
- Local material models (frequency dependence of ε, μ not included except as hard-coded complex constants).
- The code assumes small stack (up to 3 layers). For many layers the recursion still works.
- The sign conventions in exponentials and γ depend on how square root branch cuts are chosen; the principal branch is used here.
- Units: SI (meters, seconds, radians, Hz). Frequencies passed in GHz are converted to Hz.

How to run
- Requires Lua and raylib binding providing rl.* drawing functions (InitWindow, DrawRectangle, DrawText, Begin/EndDrawing).
- Save code as main.lua and run with your LuaJIT runtime that loads raylib binding.
- The program opens a window and plots reflection magnitude (dB) for 1..3 layers.

References (suggested reading)
- Pozar, D. M., "Microwave Engineering" — transmission-line and wave propagation fundamentals.
- Balanis, C. A., "Advanced Engineering Electromagnetics".
- Jackson, J. D., "Classical Electrodynamics" — rigorous Maxwell theory.

Appendix — mapping code to math (compact)
- ω = 2πf
- Z0 = √(μ0/ε0)
- Zc = √(μ/ε)
- γh = j (ω/c0) h √(με)
- Zin = Zc·(Zin_next + Zc·tanh(γh)) / (Zc + Zin_next·tanh(γh))
- Γ = (Zin - Z0) / (Zin + Z0)
- Reflection[dB] = 20 log10 |Γ|