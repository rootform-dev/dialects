# Rootform Dialects

[![License](https://img.shields.io/badge/license-MPL--2.0-blue.svg)](LICENSE)

Official Rootform Language dialect source packs and their public verification
evidence, supplied and embedded by the Rootform release set.

## Model

- Provider directories at the repository root hold the canonical `.rf` sources
  and their `presentation.json` manifests. They are public source packs.
- Official dialects are embedded in the Rootform binary and identified by the
  release-set manifest. They are upgraded with Rootform releases; there is no
  official Dialect OCI package, index, install, or publish channel.
- The RF Vocabulary is built into the binary under the reserved owner
  `rf` (for example `rf.concept.managed-database`, `rf.context.network`).
  It is not a Dialect, and there is no `core` Dialect anywhere in this model.
- Symbol identities are owner-first: `rf.concept.…`, `google.rule.…`,
  `google.context.…`, `google.relation.…`, with two-segment local
  references inside the owning unit. Policies use only qualified references.
- Every official dialect keeps its own version and digests; versions and
  digests of all supplied units are recorded by the release-set manifest.

## Contents

- provider directories: canonical `.rf` sources and `presentation.json`
  manifests;
- `fixtures/`: synthetic Terraform inputs and their expected architecture
  documents;
- `evidence/`: public provider baselines, compatibility envelopes, coverage,
  terminology, scenarios, and source provenance; every local reference is
  repository-relative and must resolve within `evidence/` or `fixtures/`;
- `dialects.json`: exact official source inventory, used as release input;
- `rootform.lock`: project selection lock. It never pins supplied dialects,
  their versions, or observed non-coverage; an empty lock is valid;
- `toolchain.json`: exact Rootform version used by compatibility verification,
  pinned separately from any project lock.

Official inventory:

```text
auth0            aws              azure            cloudflare
confluent        consul           databricks       datadog
google           grafana          hcp              kestra
kubernetes       mongodb-atlas    newrelic         okta
secrets          snowflake        vault
```

## Repository checks

`bun run check` validates repository structure, formatting, typing, and tests
without downloading a Rootform binary and without any OCI or network access.

## Compatibility verification

Verification uses one exact, checksum-verified Rootform executable supplied by
the environment:

```bash
ROOTFORM_BIN=/absolute/path/to/rootform bun run verify
```

The flow requires the exact toolchain version declared by `toolchain.json`,
then validates and tests the official source inventory directly:

```bash
rootform fmt --check .
rootform validate dialects .
rootform test ./fixtures
```

Regenerate committed Architecture IR expectations with that same executable:

```bash
ROOTFORM_BIN=/absolute/path/to/rootform bun run update:goldens
```

The generator accepts delivered partial IR when a fixture intentionally records
emission diagnostics, but refuses an undeliverable build or malformed document.

It runs the fixture suite twice and requires identical output, then checks a
clean patch and scans secrets. It performs no installation, no packaging, no
publication, and produces no distribution artifacts. The official distribution
surface is the Rootform release set itself.

## Licensing

Original Rootform dialect files, fixtures, and repository tooling use
[MPL-2.0](LICENSE). Provider names and product names remain trademarks of their
owners. No provider icon asset is included here; manifests contain declarative
technology identities only. See [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md).
