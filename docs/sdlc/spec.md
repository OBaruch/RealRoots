# Specification (As-Built)

> This document is part of a spec-driven workflow: [intent](intent.md) → **spec** → [plan](plan.md).
> It is a **retroactive specification**. It describes the original implementation exactly as it behaves, including its defects. It is not a specification for new code.
> Behavior marked **Verified** was checked with GNU Octave 8.4.0 on a scratch copy of the original files.

## 1. System Overview

| Item | Value |
|---|---|
| Runtime | GNU Octave (Octave-specific syntax; not MATLAB-compatible) |
| Components | 4 functions, 2 scripts, all in `src/` |
| External dependencies | None, apart from the Octave `symbolic` package referenced by `syms` in `ObtenerRaices.m` |
| Input/output | Arguments and hard-coded values in; console tables and plots out. No file input/output. |

## 2. Common Contract for the Root-Finding Functions

These rules apply to `MetodoBiseccion`, `MetodoReglaFalsa`, `MetodoNewtonRapson`, and `MetodoEuler`.

| ID | Requirement |
|---|---|
| C-1 | `f` (and `fdy`, `fdy2` where applicable) SHALL be function handles callable as `f(x)`. |
| C-2 | If `tol >= 1`, the function SHALL run exactly `tol` iterations. |
| C-3 | If `tol < 1`, the function SHALL iterate while `abs(x0 − estimate) > tol`. `errAbs` starts at `3*10^10`, so at least one iteration always runs. |
| C-4 | After each iteration, the function SHALL append one row to the matrix `salida`, and display `salida` once when the loop ends. |
| C-5 | `x0` is the known real root, used only to compute the errors. If the root is unknown, the original comments say to use `sqrt(2)` with `tol > 1` and ignore the error columns. |
| C-6 (as built) | The declared output variable is never assigned. Calling the function as a statement succeeds. Assigning its result raises an "undefined" error. **Verified.** |

## 3. Component Specifications

### 3.1 `MetodoBiseccion(f, a, b, tol, x0)`

- Estimate: `m = (a + b) / 2`.
- Update: if `f(a)·f(m) < 0`, then `b = m`, else `a = m`.
- Row: `[a, m, b, f(a), f(m), errAbs, errRel]`, recorded after the update.
- `errAbs = |x0 − m|`, `errRel = errAbs / |x0|`.
- **Verified:** `x² − 2`, `[1, 2]`, `tol = 1e-4` → 12 rows, final `errAbs ≈ 9.3e-5`.

### 3.2 `MetodoReglaFalsa(f, a, b, tol, x0)`

- Estimate: `m = a − f(a)·(b − a) / (f(b) − f(a))`.
- Update, row format, and errors: identical to 3.1.
- **Verified:** `x² − 2`, `[1, 2]`, 4 iterations → `m = 1.3333, 1.4000, 1.4118, 1.4138`. `b` stays at `2`.

### 3.3 `MetodoNewtonRapson(f, fdy, x, tol, x0)`

- Update: `x = x − f(x) / fdy(x)`.
- Row: `[x, errAbs, errRel]`, with `errAbs = |x − x0|` and `errRel = errAbs / x0` (signed).
- Side effect: sets `format long` for the session.
- The script code after `endfunction` is NOT executed when the function is called. **Verified.**
- **Verified:** `x² − 2` from `1`, 4 iterations → `errAbs = 8.6e-2, 2.5e-3, 2.1e-6, 1.6e-12`.

### 3.4 `MetodoEuler(f, fdy, fdy2, x, tol, x0)`

- `u = f(x)/fdy(x)`, `t = f(x)·fdy2(x)/fdy(x)²`.
- Update: `x = x − 2u / (1 + √(1 − 2t))`.
- Row, errors, and side effects: identical to 3.3.
- **Verified:** `x² − 2` from `1` → exact root after the first iteration.

### 3.5 `ObtenerRaices.m` (driver template)

- Declares `f`, `fdy`, `fdy2` as placeholders, plus `a = -2`, `b = 2`, `p = -3`, `tol = 1e-10`, `x0 = -0.438842366`.
- Calls 3.1 and 3.2 with `(f, a, b, tol, x0)`, and 3.3 and 3.4 with `(f, fdy[, fdy2], p, tol, x0)`.
- **As built:** the empty handles `@(x)()` cause a parse error. The user has to fill them in before running. **Verified.**

### 3.6 `PuntoFijoUnivariable.m` (fixed-point exercise)

- Target: `f(x) = 3x³ − tan(x) + x²`.
- Defines isolations `g2`, `g3` and derivatives `dg1`, `dg2`, `dg3`, and plots them against `y = 1`.
- Iterates `x1 = g2(x0)` 10 times from `x0 = 0.25`. Row: `[x1, |x0 − x1|, |x0 − x1| / |x1|]`.
- **As built:** `x0` is never updated, so all 10 rows are identical (`0.4006 0.1506 0.3759`). **Verified.**

## 4. Repository Specification (Reorganization Acceptance Criteria)

| ID | Criterion | Status |
|---|---|---|
| R-1 | Every original `.m` file keeps an identical git blob hash after the move. | Met |
| R-2 | `LICENSE` is unchanged. | Met |
| R-3 | Original code lives in `src/`. Added documentation lives in `README.md`, `AGENTS.md`, and `docs/`. | Met |
| R-4 | The README covers overview, context, problem, objective, structure, original-implementation note, technologies, how it works, inputs/outputs, running, documentation links, and a historical note. | Met |
| R-5 | Every contextual claim is labeled Confirmed, Inferred, or Unknown. Nothing is invented. | Met |
| R-6 | Observed defects are documented in `docs/possible-improvements.md` and not fixed. | Met |
| R-7 | No infrastructure (CI, Docker, package managers, linters) is added. | Met |
| R-8 | Original CRLF line endings are protected from normalization (`.gitattributes`). | Met |
