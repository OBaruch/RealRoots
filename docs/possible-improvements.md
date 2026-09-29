# Possible Improvements

> **None of the items below have been applied.** The source code in [`src/`](../src) is kept exactly as originally written, to preserve its historical context. This list only records what a modern revision *could* address. It is kept separate from the original implementation on purpose.

## Correctness Issues Observed

| # | File | Issue | Effect |
|---|---|---|---|
| 1 | All `Metodo*.m` | Declared return value (`d` / `p`) is never assigned | `r = Metodo...(...)` raises `'d' undefined` / `'p' undefined`. Results can only be read from the console. |
| 2 | `ObtenerRaices.m` | Empty anonymous functions `@(x)()` | Parse error. The script cannot run until the placeholders are filled in. |
| 3 | `PuntoFijoUnivariable.m` | `x0 = x1` is commented out | The fixed-point iteration never advances. All 10 rows are identical. |
| 4 | `PuntoFijoUnivariable.m` | `dg1` refers to an isolation `g1` that is never defined | The `g1` curve is plotted but cannot be iterated. |
| 5 | `MetodoNewtonRapson.m` | Script code after `endfunction` uses numeric vectors instead of handles, and a wrong "real" root (`0.5`) | Never executed as a function. Misleading if read as an example. |
| 6 | `MetodoNewtonRapson.m`, `MetodoEuler.m` | `errRel = errAbs/x0` has no absolute value | Negative relative errors when the root is negative, as with the driver's `x0 = -0.438842366`. |
| 7 | Bracketing methods | No check that `f(a)·f(b) < 0` | An invalid bracket silently returns meaningless iterations. |
| 8 | Open methods | No guard for `f'(x) = 0`, divergence, or a maximum iteration count in `while` mode | Possible division by zero or an infinite loop. |
| 9 | `MetodoEuler.m` | `sqrt(1 - 2t)` can be complex | Iterates silently turn complex. |
| 10 | Bracketing methods | Sign test treats `f(m) == 0` like "root in the right half" | Harmless in practice, but an exact root is not detected early. |

## Design and Maintainability

- **Duplicated loop bodies.** Each function repeats the same body in a `for` branch and a `while` branch. A single loop with a combined stopping rule would remove the duplication.
- **Overloaded `tol`.** Using one parameter as both an iteration count and a tolerance is ambiguous. For example, a tolerance of exactly `1` is treated as one iteration. Separate `maxIter` and `tol` parameters would be clearer.
- **Required real root.** Every method needs the exact root `x0`, which is not available in real use. A stopping criterion based on `|x_{k+1} − x_k|` or `|f(x_k)|` would make the functions usable when the root is unknown.
- **Inconsistent error formulas** across scripts (see [numerical-methods.md](numerical-methods.md#3-error-measures-used-throughout)).
- **Side effects.** `format long` changes the global display format, and results are printed instead of returned.
- **No-op statements.** `f=f; fdy=fdy; fdy2=fdy2;` can be removed.
- **Unused variables.** `n = 1e3` in `PuntoFijoUnivariable.m`, and `syms x` in `ObtenerRaices.m`.
- **Plot overwrite.** The second `plot` in `PuntoFijoUnivariable.m` replaces the first. `figure` or `hold on` would keep both.

## Portability

- The Octave-specific syntax (`endfunction`, `endfor`, `endif`, `endwhile`, `#` comments) prevents running the code in MATLAB. Plain `end` and `%` comments would work in both.
- The files use CRLF line endings. They are preserved as-is through `.gitattributes`.

## Tooling (Only If the Project Were Revived)

- A small test script that checks each method against known roots, such as `x² − 2 → √2`.
- Function help blocks (Octave `help` text), in Spanish or English.
- An example script with a complete, runnable problem to replace the empty template.

These are suggestions only. Adding them would change the nature of the original project, which is why they were left out of this reorganization.
