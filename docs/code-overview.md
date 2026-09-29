# Code Overview

This document walks through each file in [`src/`](../src) as it was originally written. The code has **not** been modified. Where behavior was checked by running it, the check is labeled **Verified**. Those checks used GNU Octave 8.4.0 on a scratch copy of the files, during the 2026 reorganization.

## How the Files Relate

```
ObtenerRaices.m  (driver script / template)
   ├── MetodoBiseccion(f, a, b, tol, x0)          bracketing
   ├── MetodoReglaFalsa(f, a, b, tol, x0)         bracketing
   ├── MetodoNewtonRapson(f, fdy, p, tol, x0)     open
   └── MetodoEuler(f, fdy, fdy2, p, tol, x0)      open

PuntoFijoUnivariable.m  (standalone script, calls none of the above)
```

Octave resolves a function by its file name, so the four `Metodo*.m` files must stay in the same folder as `ObtenerRaices.m`, or on the Octave path. Keeping them together in `src/` preserves this.

There is no deeper architecture. The project is a set of independent functions plus two scripts.

## Shared Conventions

These conventions appear in all four `Metodo*` functions:

- **Function handles.** `f`, `fdy`, and `fdy2` are anonymous functions, for example `@(x)(x.^2-2)`.
- **Dual-purpose `tol`.** If `tol >= 1`, the function runs `tol` iterations in a `for` loop. If `tol < 1`, it loops `while errAbs > tol`. The two branches duplicate the same body.
- **Sentinel.** `errAbs` starts at `3*10^10`, so the `while` loop always runs at least once.
- **Accumulator.** Each iteration appends a row to `salida`. The matrix is displayed at the end by the bare statement `salida` (no semicolon).
- **Unassigned return value.** Each function declares an output (`d` or `p`) but never assigns it. **Verified:** calling `MetodoBiseccion(...)` as a statement works, but `r = MetodoBiseccion(...)` fails with `error: 'd' undefined`.
- **Octave-only syntax.** The code uses `endfunction`, `endfor`, `endif`, `endwhile`, and `#` comments.

---

## `MetodoBiseccion.m`: Bisection

```
function d = MetodoBiseccion(f,a,b,tol,x0)
```

| Parameter | Meaning (from original comments) |
|---|---|
| `f` | function |
| `a` | left end of the interval |
| `b` | right end of the interval |
| `tol` | iteration count (`>= 1`) or absolute-error tolerance (`< 1`) |
| `x0` | real value of the root. If unknown, use `sqrt(2)` and ignore the error columns. |

**Per iteration:** `m = (a+b)/2`. The sign test `f(a)*f(m) < 0` decides which endpoint to replace. The row `[a, m, b, f(a), f(m), errAbs, errRel]` is recorded **after** the endpoint has been updated.

**Verified.** Running `f = x² − 2` on `[1, 2]` with `tol = 1e-4` and `x0 = sqrt(2)` stops after 12 iterations with `m ≈ 1.4143` and `errAbs ≈ 9.3e-5`.

## `MetodoReglaFalsa.m`: False Position

```
function d = MetodoReglaFalsa(f,a,b,tol,x0)
```

It has the same parameters, structure, and output columns as bisection. The only difference is the estimate:

```
m = a - ((f(a)*(b-a)) / (f(b)-f(a)))
```

**Verified.** With `f = x² − 2`, `[1, 2]`, and 4 iterations, `m` goes `1.3333 → 1.4000 → 1.4118 → 1.4138`, while `b` stays at `2`. This is the one-sided behavior typical of *regula falsi*.

## `MetodoNewtonRapson.m`: Newton–Raphson

```
function p = MetodoNewtonRapson(f,fdy,x,tol,x0)
```

| Parameter | Meaning |
|---|---|
| `f` | function |
| `fdy` | derivative of `f` |
| `x` | starting point |
| `tol` | iteration count or tolerance (see shared conventions) |
| `x0` | real value of the root |

**Per iteration:** `x = x - f(x)/fdy(x)`. The recorded row is `[x, errAbs, errRel]`, with `errRel = errAbs/x0` (no absolute value). The function calls `format long`, which changes the display format for the whole Octave session. The lines `f=f; fdy=fdy;` inside the loops have no effect.

**Code after `endfunction`.** The file ends with a script-style block. It builds the vectors `f = 4x³+15x²+8x−4` and `fdy` over `x = −4:0.1:4`, plots them, and calls the function with `punto=1`, `tol=10`, and `real=.5`. **Verified:** this block does **not** run when `MetodoNewtonRapson(...)` is called as a function. It looks like leftover test or exploration code. It also passes numeric vectors where function handles are expected, and `0.5` is not a root of that polynomial (see [project-context.md](project-context.md#contradictions-and-inconsistencies)).

**Verified.** With `f = x² − 2`, `f' = 2x`, start `1`, and 4 iterations:

| x | errAbs |
|---|---|
| 1.500000000000000 | 8.58e-02 |
| 1.416666666666667 | 2.45e-03 |
| 1.414215686274510 | 2.12e-06 |
| 1.414213562374690 | 1.59e-12 |

## `MetodoEuler.m`: Euler's Third-Order Method

```
function p = MetodoEuler(f,fdy,fdy2,x,tol,x0)
```

It has the same parameters as Newton–Raphson, plus `fdy2`, the second derivative. The original comment labels this parameter `fdy` by mistake.

**Per iteration:**

```
u = f(x)/fdy(x);
t = (f(x)*fdy2(x)) / (fdy(x).^2);
x = x - (2*u) / (1 + sqrt(1 - 2*t));
```

The recorded row is `[x, errAbs, errRel]`. The function also sets `format long` and contains the no-op lines `f=f; fdy=fdy; fdy2=fdy2;`.

**Verified.** With `f = x² − 2` from `x = 1`, the first iterate is already `1.414213562373095` with zero error. That is the expected behavior for a quadratic (see [numerical-methods.md](numerical-methods.md#22-eulers-third-order-method-metodoeulerm)). With `tol = 1e-10`, the loop stops after one row.

## `ObtenerRaices.m`: Driver Script (Template)

The script sets up one problem and runs four methods on it:

```octave
syms x;
f=@(x)();        % function   (empty placeholder)
fdy=@(x)();      % derivative (empty placeholder)
fdy2=@(x)();     % 2nd derivative (empty placeholder)
a=-2; b=2;       % bracket for the closed methods
p=-3             % starting point for the open methods
tol=1e-10;
x0=-0.438842366; % real root, used for the error columns
```

It then calls `MetodoBiseccion`, `MetodoReglaFalsa`, `MetodoNewtonRapson`, and `MetodoEuler`.

**Verified:** as committed, the file **does not run**. Octave 8.4 stops with `parse error: anonymous function bodies must be single expressions` at `f=@(x)();`. You have to fill in the placeholders first. `syms x` also needs the Octave symbolic package, and the symbolic variable is never used afterward. The function that belongs with `x0 = -0.438842366` is **Unknown**.

## `PuntoFijoUnivariable.m`: Fixed-Point Exercise

This is a standalone script for `f(x) = 3x³ − tan(x) + x²`:

1. Plots `f` on `[−1, 1]` together with the x-axis.
2. Defines two isolations `g2` and `g3`, and three derivatives `dg1`, `dg2`, `dg3`. `g1` is never defined.
3. Plots `|dg1|`, `dg2`, `dg3`, and `y = 1` on `[−0.25, 0.5]` to compare convergence rates. There is no `hold on`, so this plot replaces the first one.
4. Runs 10 iterations of `x1 = g2(x0)` from `x0 = 0.25`, storing `[x1, errAbs, errAbs/|x1|]` in `sal`.

**Verified** (with plotting stubbed out, since the test machine has no display). Every one of the 10 rows is identical: `0.4006  0.1506  0.3759`. The update `x0 = x1` is commented out (`%para while x0=x1;`), so the iteration never advances. The variable `n = 1e3` on line 2 is also never used.

---

## Octave Features Used

| Feature | Where |
|---|---|
| Anonymous functions `@(x)` | All files |
| `plot`, `hold on`, `grid on` | `MetodoNewtonRapson.m` (after `endfunction`), `PuntoFijoUnivariable.m` |
| `linspace` | `PuntoFijoUnivariable.m` |
| `format long` | `MetodoNewtonRapson.m`, `MetodoEuler.m` |
| `syms` (symbolic package) | `ObtenerRaices.m` |
| Octave-only keywords and `#` comments | All files |
