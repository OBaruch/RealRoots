# AGENTS.md

Working rules for anyone, human or AI-assisted, who contributes to this repository.

## What This Repository Is

A **historical archive** of an original GNU Octave project (numerical root-finding methods, 2021). See [README.md](README.md) and [docs/sdlc/intent.md](docs/sdlc/intent.md).

## Hard Rules

1. **Never modify files in `src/`.** Do not edit, reformat, rename, re-encode, or change their line endings (they use CRLF). The code is intentionally preserved with its original defects.
2. **Never delete original material** (`src/*.m`, `LICENSE`).
3. **Do not invent context.** Label every claim about the project's origin or behavior as *Confirmed*, *Inferred*, or *Unknown*.
4. **Document defects; don't fix them.** Add findings to [docs/possible-improvements.md](docs/possible-improvements.md).
5. **Do not add infrastructure** (CI, Docker, package managers, linters, test frameworks) unless the owner explicitly asks for it.

## Workflow for Changes

Follow the spec-driven flow before changing anything:

1. Update [docs/sdlc/intent.md](docs/sdlc/intent.md) with *why* the change is needed.
2. Update [docs/sdlc/spec.md](docs/sdlc/spec.md) with *what* changes, and its acceptance criteria.
3. Update [docs/sdlc/plan.md](docs/sdlc/plan.md) with *how* the change will be made and verified.
4. Make the change on a feature branch and open a pull request.

Any new or modernized code goes in a **separate** folder (for example, `modern/`). `src/` stays frozen.

## Verifying Preservation

```bash
git diff -M --name-status main HEAD | grep src/   # only R100 renames, or nothing
```

## Running the Code

GNU Octave only. See [README.md → Running the Project](README.md#running-the-project).

## Documentation Language

English. Original code comments stay in Spanish.
