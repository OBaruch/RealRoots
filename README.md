# RealRoots

Numerical methods for approximating the **real roots** of single-variable nonlinear equations `f(x) = 0`, written in **GNU Octave**.

> This repository preserves the original implementation of the project. The source code has intentionally not been refactored or modernized in order to retain the historical context and original development approach.

---

## Project Overview

RealRoots is a small collection of Octave scripts that apply classic root-finding algorithms to a user-defined function. Each script prints a table showing how the approximation evolves at each iteration, along with its **absolute and relative error** compared against a known "real" value of the root.

The following methods are implemented:

| Method | Family | File |
|---|---|---|
| Bisection | Bracketing (closed) | [`src/MetodoBiseccion.m`](src/MetodoBiseccion.m) |
| False Position (*Regula Falsi*) | Bracketing (closed) | [`src/MetodoReglaFalsa.m`](src/MetodoReglaFalsa.m) |
| Newton–Raphson | Open | [`src/MetodoNewtonRapson.m`](src/MetodoNewtonRapson.m) |
| Euler's third-order method | Open | [`src/MetodoEuler.m`](src/MetodoEuler.m) |
| Fixed-Point Iteration (worked exercise) | Open | [`src/PuntoFijoUnivariable.m`](src/PuntoFijoUnivariable.m) |

A driver script ([`src/ObtenerRaices.m`](src/ObtenerRaices.m)) runs the two bracketing methods and the two derivative-based open methods on the same problem.

## Project Context

**Project origin: Unknown.** The evidence suggests academic coursework, but this cannot be confirmed.

| Item | Status | Evidence |
|---|---|---|
| Author: Baruch Lopez | Confirmed | `LICENSE` copyright line; git history |
| Uploaded to GitHub on 2021-02-20 | Confirmed | Commit dates |
| Language: GNU Octave | Confirmed | `endfunction`, `endfor`, `endif`, `endwhile`, and `#` comments only work in Octave |
| Comments and identifiers in Spanish | Confirmed | Source code |
| Likely written for a *Numerical Methods* course | Inferred | The set of methods, the absolute/relative error tables, the "real value" parameter, and a worked fixed-point exercise all follow a typical numerical-analysis syllabus |
| University, course, or assignment statement | Unknown | The repository has no PDFs, reports, or assignment documents |

See [`docs/project-context.md`](docs/project-context.md) for the full analysis.

## Problem Statement

Many nonlinear equations, such as `3x³ − tan(x) + x² = 0`, have no closed-form solution. Their roots have to be approximated with iterative numerical methods. The project implements several of these methods so that their iteration-by-iteration behavior and convergence can be observed and compared.

## Objective

*Inferred from the code:* implement bracketing and open root-finding methods, then compare how fast each one converges to a known root by tabulating the absolute and relative error at every iteration.

## Repository Structure

```
RealRoots/
├── README.md                 # This file
├── AGENTS.md                 # Working rules for contributors and AI agents
├── LICENSE                   # Original MIT license (2021)
├── .gitattributes            # Protects the original CRLF line endings of src/*.m
├── .gitignore
├── src/                      # Original Octave source code (unchanged)
│   ├── MetodoBiseccion.m
│   ├── MetodoReglaFalsa.m
│   ├── MetodoNewtonRapson.m
│   ├── MetodoEuler.m
│   ├── ObtenerRaices.m
│   └── PuntoFijoUnivariable.m
└── docs/
    ├── project-context.md        # Origin, scope, evidence (Confirmed / Inferred / Unknown)
    ├── numerical-methods.md      # Mathematical background of each method
    ├── code-overview.md          # File-by-file walkthrough and observed behavior
    ├── possible-improvements.md  # Improvements documented but NOT applied
    └── sdlc/
        ├── intent.md             # Why the project and this reorganization exist
        ├── spec.md               # As-built specification of the original implementation
        └── plan.md               # Reorganization plan and verification record
```

## Original Implementation

All files in `src/` are the original files, byte for byte. That includes their logic, formatting, comments, Spanish identifiers, Windows (CRLF) line endings, and any mistakes. The only change is their location: they moved from the repository root into `src/`. Git records these moves as 100% renames.

Issues found while reviewing the code are documented in [`docs/possible-improvements.md`](docs/possible-improvements.md) and have deliberately **not** been fixed.

## Technologies

- **GNU Octave**: the only language and runtime used. The code relies on Octave-specific syntax and will not run unmodified in MATLAB.
- Octave built-ins used: anonymous functions (`@(x)`), `plot`, `hold`, `grid`, `linspace`, `format long`.
- `syms x` in `ObtenerRaices.m` refers to the Octave **symbolic** package. The symbolic variable is never actually used, because all functions are anonymous function handles.

## How It Works

Every method follows the same pattern:

1. It receives the function as an anonymous function handle, plus starting point(s), a tolerance `tol`, and the known real root `x0`.
2. The `tol` parameter has **two meanings**:
   - `tol >= 1`: run exactly `tol` iterations.
   - `tol < 1`: keep iterating while the absolute error `|x0 − xₖ|` is greater than `tol`.
3. After each iteration, it appends a row to a matrix called `salida` ("output"), which is displayed at the end.

| Script | Columns of the printed table |
|---|---|
| Bisection, False Position | `a`, `m`, `b`, `f(a)`, `f(m)`, absolute error, relative error |
| Newton–Raphson, Euler | `x`, absolute error, relative error |
| Fixed point (`sal`) | `x1`, absolute error, relative error |

If the real root is unknown, the original comments say to pass `sqrt(2)` as `x0`, ignore the error columns, and use an iteration count (`tol > 1`).

For the mathematics behind each method, see [`docs/numerical-methods.md`](docs/numerical-methods.md).

## Inputs and Outputs

- **Inputs:** anonymous function handles for `f(x)` and, where needed, `f'(x)` and `f''(x)`; the interval `[a, b]` or starting point; `tol`; the real root `x0`. All inputs are either passed as function arguments or written directly into the scripts.
- **Outputs:** tables printed to the Octave console. `PuntoFijoUnivariable.m` also draws plots. No files are read or written, and the repository contains no saved output.

## Running the Project

The original repository has no execution instructions. The steps below were checked with **GNU Octave 8.4.0** during the reorganization. The Octave version originally used is unknown.

```octave
cd src
f    = @(x)(x.^2 - 2);
fdy  = @(x)(2*x);
fdy2 = @(x)(2);

MetodoBiseccion(f, 1, 2, 1e-4, sqrt(2))      % bracketing, stop by tolerance
MetodoReglaFalsa(f, 1, 2, 4, sqrt(2))        % bracketing, 4 iterations
MetodoNewtonRapson(f, fdy, 1, 4, sqrt(2))    % open, 4 iterations
MetodoEuler(f, fdy, fdy2, 1, 3, sqrt(2))     % open, 3 iterations
```

Notes:

- Call the functions **without assigning the result** (for example, not `r = MetodoBiseccion(...)`). Their declared return values are never assigned in the original code, so assigning the result raises an error.
- `ObtenerRaices.m` is a template. Its function handles are empty placeholders (`@(x)()`), so it only runs after you fill them in.
- See [`docs/code-overview.md`](docs/code-overview.md) for details and verified outputs.

## Documentation

- [Project context](docs/project-context.md)
- [Numerical methods (theory)](docs/numerical-methods.md)
- [Code overview](docs/code-overview.md)
- [Possible improvements (not applied)](docs/possible-improvements.md)
- Spec-driven documentation: [intent](docs/sdlc/intent.md) · [spec](docs/sdlc/spec.md) · [plan](docs/sdlc/plan.md)

## Historical Note

This repository was later reorganized and documented to improve readability and preserve the historical context of the original project. The original source code remains unchanged.

## License

[MIT](LICENSE) © 2021 Baruch Lopez
