# Numerical Methods: Background

This document explains the mathematics behind each method implemented in [`src/`](../src). It describes the **standard** formulation of each method and how the original code applies it. It does not change or reinterpret the code.

The problem in every case is: given a continuous function `f : ℝ → ℝ`, find `x*` such that `f(x*) = 0`.

---

## 1. Bracketing (Closed) Methods

Bracketing methods start from an interval `[a, b]` where `f(a)` and `f(b)` have opposite signs. By the intermediate value theorem, a root lies inside. The interval shrinks at each iteration while keeping the sign change. These methods always converge, as long as the initial bracket is valid.

### 1.1 Bisection (`MetodoBiseccion.m`)

The next estimate is the midpoint of the interval:

```
m = (a + b) / 2
```

- If `f(a)·f(m) < 0`, the root is in `[a, m]`, so set `b = m`.
- Otherwise, set `a = m`.

**Convergence:** linear. The interval halves at every step, so after `n` iterations the error is at most `(b − a) / 2ⁿ`.

### 1.2 False Position / Regula Falsi (`MetodoReglaFalsa.m`)

Instead of the midpoint, the next estimate is the point where the straight line (secant) through `(a, f(a))` and `(b, f(b))` crosses the x-axis:

```
m = a − f(a)·(b − a) / (f(b) − f(a))
```

The interval is then updated with the same sign rule as bisection.

**Convergence:** usually faster than bisection, but it can become one-sided. One endpoint may stay fixed for many iterations. This is visible in the verified run for `x² − 2` on `[1, 2]`, where `b = 2` never moves (see [code-overview.md](code-overview.md)).

---

## 2. Open Methods

Open methods start from a single point and do not need a bracket. They usually converge faster, but they can diverge if the starting point is poor or the derivative is close to zero.

### 2.1 Newton–Raphson (`MetodoNewtonRapson.m`)

Linearize `f` around the current point and solve the linear approximation for zero:

```
x_{k+1} = x_k − f(x_k) / f'(x_k)
```

**Convergence:** quadratic near a simple root. The number of correct digits roughly doubles at each iteration. The verified run for `x² − 2` from `x = 1` shows the absolute error going `8.6e-2 → 2.5e-3 → 2.1e-6 → 1.6e-12`.

### 2.2 Euler's Third-Order Method (`MetodoEuler.m`)

Despite the shared name, this is **not** Euler's method for ordinary differential equations. It is a root-finding iteration that uses the second derivative. Instead of the tangent line, it fits a second-order Taylor expansion (a parabola) at `x_k` and takes the nearest root of that parabola.

With

```
u = f(x_k) / f'(x_k)
t = f(x_k)·f''(x_k) / f'(x_k)²
```

the update used in the code is

```
x_{k+1} = x_k − 2u / (1 + √(1 − 2t))
```

This is equivalent to `x_{k+1} = x_k − 2f / (f' + √(f'² − 2·f·f''))` when `f' > 0`.

**Convergence:** cubic near a simple root. Because the method solves the quadratic Taylor model exactly, it finds the root of a quadratic `f` in a **single** iteration. The verified run on `x² − 2` shows exactly that.

**Caveat:** if `1 − 2t < 0`, the square root becomes complex. Octave then silently continues with complex numbers.

### 2.3 Fixed-Point Iteration (`PuntoFijoUnivariable.m`)

Rewrite `f(x) = 0` as `x = g(x)`, then iterate:

```
x_{k+1} = g(x_k)
```

**Convergence criterion:** the iteration converges locally when `|g'(x)| < 1` near the fixed point. The smaller `|g'|` is, the faster it converges.

The script applies this to

```
f(x) = 3x³ − tan(x) + x²
```

and considers three isolations of `x`:

| Isolation | Expression | Derivative in the code | Plot color |
|---|---|---|---|
| `g1` (not defined in code) | `x = √(tan(x) − 3x³)` | `dg1` | blue (`%b`) |
| `g2` | `x = ∛((tan(x) − x²) / 3)` | `dg2` | red (`%r`) |
| `g3` | `x = arctan(3x³ + x²)` | `dg3` | magenta (`%m`) |

The script plots `|g1'|`, `g2'`, `g3'`, and the line `y = 1` over `[−0.25, 0.5]` to decide visually which isolation converges fastest. It then iterates with `g2` starting at `x0 = 0.25`.

---

## 3. Error Measures Used Throughout

All scripts compare the current estimate `x_k` with a user-supplied real root `x0`:

```
absolute error  E_abs = |x0 − x_k|
relative error  E_rel = E_abs / |x0|          (bisection, false position)
                E_rel = E_abs / x0            (Newton–Raphson, Euler: no absolute value)
                E_abs / |x1|                  (fixed point: relative to the new iterate)
```

The formulas differ between scripts. This is documented in [possible-improvements.md](possible-improvements.md) and was not changed.

## 4. Summary Comparison

| Method | Needs | Guaranteed convergence | Order |
|---|---|---|---|
| Bisection | `f`, bracket `[a, b]` | Yes (valid bracket) | 1 (linear) |
| False position | `f`, bracket `[a, b]` | Yes (valid bracket) | Superlinear in practice, can stall one-sided |
| Newton–Raphson | `f`, `f'`, start point | No | 2 (quadratic) |
| Euler (third order) | `f`, `f'`, `f''`, start point | No | 3 (cubic) |
| Fixed point | `g`, start point | Only if `|g'| < 1` near the root | 1 (linear) in general |
