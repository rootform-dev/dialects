# Rootform Dialects

[![License](https://img.shields.io/badge/license-MPL--2.0-blue.svg)](LICENSE)

Official Rootform Language dialects and their public verification evidence.

## Contents

- provider directories at repository root: canonical `.rf` sources and
  `presentation.json` manifests;
- `fixtures/`: synthetic Terraform inputs and expected architecture documents;
- `evidence/`: public provider baselines, compatibility envelopes, coverage,
  terminology, scenarios, and source provenance;
- `dialects.json`: exact official inventory;
- `rootform.lock`: canonical content and presentation digests for that inventory;
- `toolchain.json`: exact Rootform product version covered by compatibility
  verification.

Current dialects:

```text
auth0            aws              azure            cloudflare
confluent        consul           core             databricks
datadog          google           grafana          hcp
kestra           kubernetes       mongodb-atlas    newrelic
okta             secrets          snowflake        vault
```

## Authoring workflow

```bash
rootform fmt --check .
rootform validate dialects .

export ROOTFORM_HOME="$(mktemp -d)"
rootform install dialects .
rootform test ./fixtures
```

`bun run check` validates this repository without downloading Rootform.
Rootform distribution CI supplies an already verified assembled executable to
`bun run verify`, which checks the exact version declared by `toolchain.json`,
uses isolated cache state, and proves repeated-output determinism. Set
`ROOTFORM_BIN` to that executable when running locally.

## Private distribution build

Build deterministic official dialect packages and generated provider index
with one exact verified Rootform executable:

```bash
ROOTFORM_BIN=/absolute/path/to/rootform \
  bun run package:dialects -- --to artifacts/oci \
  --rootform-version 0.1.0-pr.81.1
```

Output is a local OCI image layout under ignored `artifacts/`. Command performs
no registry push. `bun run verify` builds layout twice and requires byte-identical
outputs before compatibility tests pass.

## Licensing

Original Rootform dialect files, fixtures, and repository tooling use
[MPL-2.0](LICENSE). Provider names and product names remain trademarks of their
owners. No provider icon asset is included here; manifests contain declarative
technology identities only. See [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md).
