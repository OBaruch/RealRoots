# Intent

> This document is part of a spec-driven workflow: **intent → spec → plan**.
> It explains *why* things exist. [spec.md](spec.md) defines *what* exists, and [plan.md](plan.md) records *how* the repository was reorganized.
> All three documents were written retroactively, from the original code, in 2026.

## 1. Original Project Intent (Reconstructed)

### Problem

Nonlinear equations such as `3x³ − tan(x) + x² = 0` usually cannot be solved in closed form. Their real roots have to be approximated with iterative numerical methods, and each method trades off robustness, speed, and the information it needs (an interval, the derivatives, or a reformulation `x = g(x)`).

### Intent

Build a small, reusable set of GNU Octave routines that:

1. approximate a real root of a user-supplied function `f(x)`, using both **bracketing** methods (bisection, false position) and **open** methods (Newton–Raphson, Euler's third-order method, fixed-point iteration);
2. show the **iteration-by-iteration** progress of each method as a table;
3. **measure convergence** by comparing every iterate against the known real root, using absolute and relative error;
4. can be run on a new exercise just by editing a driver template (`ObtenerRaices.m`).

### Context

**Project origin: Unknown.** It is most likely *coursework for a Numerical Methods course* (**Inferred**). The evidence is in [../project-context.md](../project-context.md).

### Success, as the original code defines it

The "success" signal built into the code is a table in which the absolute error shrinks toward zero. The iteration stops either after a fixed number of steps or once the error falls below a tolerance.

### Non-goals (Observed)

The original project does not attempt any of the following:

- a general-purpose solver for unknown roots (every method needs the real root `x0` to compute errors);
- systems of equations, complex roots, or polynomial-specific solvers;
- input validation, error handling, automated tests, or packaging;
- MATLAB compatibility.

## 2. Reorganization Intent (2026)

### Problem

In its original state, the repository was six loose `.m` files and a license in the root directory. It had no README, no explanation of what each script does, and no context. A reader had to open every file to understand the project.

### Intent

Turn the repository into a clear, navigable, portfolio-ready **historical** record of the original work:

- **Preserve** the original implementation byte for byte. Modernize the repository, not the project.
- **Explain** what the project is, where it probably came from, how each method works, and how to run it.
- **Separate** original material (`src/`, `LICENSE`) from documentation added later (`README.md`, `AGENTS.md`, `docs/`).
- **Be honest**: label every claim as Confirmed, Inferred, or Unknown, and document defects instead of fixing them.
- **Stay small**: no build system, CI, containers, or frameworks that the original project never had.

### Guiding principle

> Preserve the technical history of the project. Do not try to rewrite it.
