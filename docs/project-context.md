# Project Context

This document reconstructs the origin and purpose of **RealRoots** from the evidence available in the repository. Each statement is labeled as one of:

- **Confirmed**: directly supported by files, code, or git history.
- **Inferred**: a reasonable deduction from the repository, but not proven.
- **Unknown**: the repository does not provide enough information to decide.

## Summary

| Field | Value |
|---|---|
| Project name | RealRoots |
| Author | Baruch Lopez (**Confirmed**: `LICENSE`, git history) |
| Date | Uploaded 2021-02-20 (**Confirmed**: commit timestamps). When development actually happened is **Unknown**. |
| Language | GNU Octave (**Confirmed**) |
| Domain | Numerical analysis: approximating the roots of nonlinear equations (**Confirmed**) |
| Classification | **Project origin: Unknown.** Most likely *Coursework / Assignment* (**Inferred**) |
| Human language | Spanish comments and identifiers (**Confirmed**) |

## Sources Examined

The repository contained only:

| File | Type |
|---|---|
| `LICENSE` | MIT license, "Copyright (c) 2021 Baruch Lopez" |
| `MetodoBiseccion.m` | Octave function |
| `MetodoReglaFalsa.m` | Octave function |
| `MetodoNewtonRapson.m` | Octave function, with extra script code after `endfunction` |
| `MetodoEuler.m` | Octave function |
| `ObtenerRaices.m` | Octave driver script (template) |
| `PuntoFijoUnivariable.m` | Octave script (fixed-point exercise) |

The repository has **no** PDF, Word, PowerPoint, image, dataset, notebook, configuration, or output files, and no README. All context below comes from the source code, its comments, file names, and git metadata.

## Evidence Analysis

### What the project does (Confirmed)

- It implements the **bisection**, **false position**, **Newton–Raphson**, and **Euler (third-order)** methods as reusable Octave functions.
- It includes a **fixed-point iteration** exercise for the specific equation `f(x) = 3x³ − tan(x) + x²`.
- Every method computes the **absolute error** and **relative error** against a user-supplied "real value" of the root (`x0`). The comments describe `x0` as *"valor real de la raíz que se busca para ver la aproximación"* ("the real value of the root being sought, to see the approximation").
- The driver script groups the methods under the headings *"MÉTODOS DE RAÍCES CERRADOS"* (bracketing methods) and *"MÉTODOS DE RAÍCES ABIERTOS"* (open methods). This is the standard classification used in numerical-methods textbooks.

### Why it was likely built (Inferred)

Several signals point to academic coursework, probably a *Métodos Numéricos* (Numerical Methods) course:

1. The chosen methods (bisection, false position, Newton–Raphson, fixed point) follow the typical order of the "roots of equations" unit in an introductory numerical-methods course.
2. The output tables compare each iterate against a known exact root and report absolute and relative error. This is typical of exercises that ask students to *show the convergence* of a method, rather than of a tool built to solve real problems.
3. `PuntoFijoUnivariable.m` reads like a worked exercise. It isolates `x` three different ways (`g1`, `g2`, `g3`), differentiates each one, and plots `|g'(x)|` against 1 to check the convergence criterion. The comment says *"VER CUÁL CONVERGE MÁS RÁPIDO"* ("see which one converges faster").
4. `ObtenerRaices.m` is a template with empty function placeholders. That fits a tool meant to be reused across several homework problems.
5. The upload date (February 2021) and the Spanish-language code fit a Spanish-speaking university context.

None of these signals is conclusive. The code could equally be personal study or exam preparation.

### Unknown

- The university, course, instructor, or specific assignment.
- Whether the scripts were submitted as a deliverable.
- Which function the driver script was last used with. It hard-codes the real root `x0 = -0.438842366`, interval `[-2, 2]`, and starting point `-3`, but the function bodies are empty.
- The Octave version used in 2021.

## Contradictions and Inconsistencies

These are recorded here rather than resolved:

| Location | Observation |
|---|---|
| `MetodoNewtonRapson.m` (code after `endfunction`) | Declares `real = .5` as the root of `4x³ + 15x² + 8x − 4`, but `f(0.5) = 4.25`. The real roots of that polynomial are about `−2.9603`, `−1.0975`, and `0.3078` (checked numerically). |
| Same block | Defines `f` and `fdy` as numeric vectors, while the function expects function handles. |
| `MetodoEuler.m` comment | Says *"fdy es la segunda derivada de f"* ("fdy is the second derivative of f"), but the parameter it describes is `fdy2`. |
| `PuntoFijoUnivariable.m` | Defines `dg1` (the derivative of an isolation `g1`), but `g1` itself is never defined. |
| Repository name vs. content | "RealRoots" matches the content: every method looks for real roots. No contradiction. |

## Scope

- **In scope (original):** single-variable real functions, derivative-free bracketing methods, derivative-based open methods, one fixed-point exercise, and console tables plus plots.
- **Out of scope (original):** systems of equations, complex roots, polynomial-specific methods, automated tests, input validation, and file input/output.

## Historical Note

This repository was later reorganized and documented to improve readability and preserve the historical context of the original project. The original source code remains unchanged.
