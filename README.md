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
- `toolchain.json`: exact Rootform release used by CI.

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

`bun run verify` performs the same workflow with the exact binary declared by
`toolchain.json`, isolated cache state, and repeated-output determinism checks.
Set `ROOTFORM_BIN` to the already checksum-verified executable when running
locally.

## Licensing

Original Rootform dialect files, fixtures, and repository tooling use
[MPL-2.0](LICENSE). Provider names and product names remain trademarks of their
owners. No provider icon asset is included here; manifests contain declarative
technology identities only. See [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md).
