# Rootform Dialects

[![License](https://img.shields.io/badge/license-MPL--2.0-blue.svg)](LICENSE)

Official Rootform Language dialects and their public verification evidence.

## Contents

- provider directories at repository root: canonical `.rf` sources and
  `presentation.json` manifests;
- `fixtures/`: synthetic Terraform inputs and expected architecture documents;
- `evidence/`: public provider baselines, compatibility envelopes, coverage,
  terminology, scenarios, and source provenance; every local reference is
  repository-relative and must resolve within `evidence/` or `fixtures/`;
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

## Distribution build

Build deterministic official dialect packages and generated provider index
with one exact verified Rootform executable:

```bash
ROOTFORM_BIN=/absolute/path/to/rootform \
  bun run package:dialects -- --to artifacts/oci \
  --rootform-version 0.1.0 \
  --revision 0123456789abcdef0123456789abcdef01234567
```

Output is a local OCI image layout under ignored `artifacts/`. Command performs
no registry push. `bun run verify` builds layout twice and requires byte-identical
outputs before compatibility tests pass. Wrapper records only explicit,
deterministic OCI provenance: repository source, exact supplied revision,
revision-bound README URL, and `MPL-2.0`. It never discovers Git state.

## Official publication

Manual `publish official dialects` workflow consumes one exact published
Rootform prerelease archive and checks both GitHub asset digest and published
checksums before compiling any dialect. It then:

1. validates every source, fixture, license, and deterministic OCI layout;
2. preflights every immutable `dialect-<name>-<version>` tag;
3. pushes all missing dialect artifacts;
4. pulls every artifact back by manifest digest and compares its complete OCI
   descriptor graph with local verified bytes;
5. regenerates byte-identical distribution layout only after all remote
   dialects passed verification;
6. pushes and verifies index under immutable
   `index-sha256-<manifest-digest>` tag;
7. moves mutable discovery tag `official-index-v1` to verified index digest as
   final registry operation.

Any artifact failure leaves discovery tag unchanged. Rerunning same publication
is idempotent; existing version tag with different digest fails before first
push. Official GHCR package must already be public. Workflow verifies it remains
public and never changes package visibility. Public dialects and official index
can therefore be pulled without credentials. `scripts/publish.ts
--test-repository` is bounded to loopback and exists only for
ephemeral-registry verification; it does not add Rootform CLI configuration or
private-registry authentication.

Generic `rootform publish dialects` now shares immutable-tag preflight,
canonical dialect order, digest repull, complete verification, and immutable
index publication. Official script remains because it additionally owns
Rootform release verification, GHCR visibility checks, regenerated
layout proof, and final mutable `official-index-v1` movement.

## Licensing

Original Rootform dialect files, fixtures, and repository tooling use
[MPL-2.0](LICENSE). Provider names and product names remain trademarks of their
owners. No provider icon asset is included here; manifests contain declarative
technology identities only. See [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md).
