# Rootform Dialects engineering contract

## Mission

This repository is the single source of truth for official Rootform dialects.
Dialect meaning, fixtures, expected results, and presentation identities must
remain deterministic, explainable, provider-scoped, and usable offline.

## Boundaries

- Rootform engine source never enters this repository.
- Prompts, transcripts, private specifications, work logs, credentials,
  customer data, Terraform state, raw plans, and personal paths never enter Git.
- Every official dialect lives only under its named repository-root directory.
- `presentation.json` carries identities only. It never carries SVG, HTML,
  URLs, styling, or behavior.
- Fixtures are synthetic. Never commit real infrastructure or account data.
- Provider evidence records public facts and provenance, not private research
  journals.

## Toolchain

- Bun is the only JavaScript package manager.
- Direct dependencies and GitHub Actions use exact immutable pins.
- Rootform CLI version defaults to `toolchain.json`. During dev integration,
  verification may use a deterministic binary built from a clean exact Engine
  commit; record its commit and digest with results. Release/freeze uses the
  verified assembled Rootform candidate and exact candidate version through
  `--rootform-version`.
- Dev artifacts are transient and make no release claim. Immutable Engine and
  Rootform handoffs, final pins, and complete qualification belong to
  release/freeze.
- Dialects CI validates repository structure and history without downloading a
  Rootform binary or holding a Rootform repository credential.
- No network access occurs after dependencies, tools, and CLI inputs are
  supplied.

## Changes

- Keep edits inside affected dialect, fixtures, evidence, and tests.
- A provider-version or semantic change requires current primary-source
  evidence and updated expected results.
- Never duplicate engine semantics in repository scripts. Rootform CLI owns
  parsing, validation, compilation, and fixture comparison.
- Do not hand-edit generated expected results without recording command and
  exact CLI version used.
- Use Conventional Commits and branch from `dev`.

## Validation

Run repository checks while editing:

```bash
bun run check
```

Run the complete compatibility gate with the exact assembled binary declared
by `toolchain.json`:

```bash
ROOTFORM_BIN=/absolute/path/to/rootform bun run verify
```

Completion requires structural checks, formatting, dialect validation, fixture
tests, determinism proof, secret scan, license checks, and a clean diff.
