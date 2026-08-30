# Rootform Dialects engineering contract

## Mission

This repository is the single source of truth for official Rootform dialects.
Dialect meaning, fixtures, expected results, and presentation identities must
remain deterministic, explainable, provider-scoped, and usable offline.

## Boundaries

- Rootform engine source never enters this repository.
- Prompts, transcripts, private specifications, work logs, credentials,
  customer data, Terraform state, raw plans, and personal paths never enter Git.
- Every official dialect lives only under `dialects/<name>/` here.
- `presentation.json` carries identities only. It never carries SVG, HTML,
  URLs, styling, or behavior.
- Fixtures are synthetic. Never commit real infrastructure or account data.
- Provider evidence records public facts and provenance, not private research
  journals.

## Toolchain

- Bun is the only JavaScript package manager.
- Direct dependencies and GitHub Actions use exact immutable pins.
- Rootform CLI version comes from `toolchain.json`; CI downloads that exact
  release and verifies its checksum before use.
- No network access occurs after CLI installation.

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

Run focused CLI checks while editing, then:

```bash
bun run verify
```

Completion requires structural checks, formatting, dialect validation, fixture
tests, determinism proof, secret scan, license checks, and a clean diff.
