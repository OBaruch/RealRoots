# Plan

> This document is part of a spec-driven workflow: [intent](intent.md) → [spec](spec.md) → **plan**.
> It records how the repository was reorganized, and how preservation of the original code was verified.

## 1. Constraints

1. **Do not modify the source code.** No edits, reformatting, renames, or line-ending changes to any `.m` file.
2. Do not delete original material. Moving files is allowed.
3. Do not invent context. Every claim is labeled Confirmed, Inferred, or Unknown.
4. Do not add infrastructure the original project never had.
5. Write all documentation in English. The original code keeps its Spanish comments.

## 2. Phases

### Phase 1: Discovery ✅

- Inventoried every file: 6 `.m` files and `LICENSE`, with no documents, images, data, or outputs.
- Read every source file in full, including the comments and the dead code after `endfunction`.
- Reviewed the git history: two commits on 2021-02-20 by Baruch Lopez.
- Identified the language (GNU Octave) from its syntax, and confirmed CRLF line endings.

### Phase 2: Context Recovery ✅

- Cross-referenced the comments, method names, and the structure of the driver script.
- Classified the project as **Project origin: Unknown**, likely coursework (Inferred).
- Recorded inconsistencies (wrong "real" root, undefined `g1`, mislabeled parameter) instead of resolving them.

### Phase 3: Behavior Verification ✅

On a **scratch copy outside the repository**, with GNU Octave 8.4.0:

- Ran each `Metodo*` function on `f(x) = x² − 2` (root `√2`), in both iteration-count and tolerance modes.
- Confirmed that assigning a function's return value fails (the output variable is never assigned).
- Confirmed that `ObtenerRaices.m` fails to parse as committed.
- Ran `PuntoFijoUnivariable.m` with plotting stubbed out and confirmed the non-advancing iteration.

### Phase 4: Restructure ✅

| Before | After |
|---|---|
| `/*.m` (6 files) | `src/*.m`, moved with `git mv` (100% renames) |
| `LICENSE` | unchanged, stays in the root |
| (none) | `README.md`, `AGENTS.md`, `.gitignore`, `.gitattributes` |
| (none) | `docs/`: context, theory, code overview, improvements, and `sdlc/` |

Folders that were considered and **not** created, because nothing would go in them: `data/`, `assets/`, `examples/`, `notebooks/`, `archive/`, `docs/original/`.

### Phase 5: Documentation ✅

- `README.md`: portfolio-facing entry point.
- `docs/project-context.md`: evidence-based origin analysis.
- `docs/numerical-methods.md`: the mathematics of each method.
- `docs/code-overview.md`: file-by-file walkthrough with verified behavior.
- `docs/possible-improvements.md`: defects and modernization ideas, **not applied**.
- `docs/sdlc/{intent,spec,plan}.md`: spec-driven documentation.
- `AGENTS.md`: rules for any future human or AI-assisted work on the repository.

### Phase 6: Validation ✅

```bash
# Every original file must appear only as an exact rename (R100);
# everything else must be a newly added documentation or config file (A).
git diff -M --name-status main HEAD

# Object IDs of the original files are identical before and after the move
git ls-tree main -- '*.m'
git ls-tree HEAD src/
```

- Checked that all relative Markdown links resolve.

## 3. Out of Scope (Deliberately Not Done)

- Fixing any of the defects listed in [possible-improvements.md](../possible-improvements.md).
- Translating or rewording the original Spanish comments.
- Adding tests, CI, linters, formatters, Docker, or a package manifest.
- Converting the code to MATLAB-compatible syntax.

## 4. Possible Future Work (Optional, Separate from the Original)

If the project is ever revived, the new code should live **alongside** the original rather than replacing it (for example, in a `modern/` folder). It should come with its own intent, spec, and plan, and `src/` should stay frozen.
