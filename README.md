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

## Relations and queries in v0.1

The [generated core vocabulary](evidence/core/semantic-catalog.json) lists
concepts, context dimensions, and shared relations. Definitions describe the
available vocabulary; facts describe concrete architecture endpoints. Declared
vocabulary does not establish exhaustive provider coverage.

A labelled relation inside a rule always introduces `DIALECT/name`, even when
an imported Dialect has the same label. Google's Cloud Run rule, for example,
emits `google/routes-to`:

```hcl
relation "routes-to" {
  to  = concept.serverless-vpc-access-connector
  via = source.template[0].vpc_access[0].connector
}
```

Only `private-reachability` is intentionally shared in the official corpus.
Its owner, `core`, declares it at top level:

```hcl
relation "private-reachability" {
  description = "Private network reachability between an architecture component and a network boundary."
}
```

Google and Azure require `core = "0.1.0"` directly. Their rules emit it through
an unlabelled block with an explicit reference. Google's Cloud SQL example:

```hcl
relation {
  as  = relation.core.private-reachability
  to  = concept.core.virtual-network
  via = source.settings[0].ip_configuration[0].private_network
}
```

Azure uses the same predicate with `concept.core.subnet` and
`source.delegated_subnet_id`. Predicate identity is `core/private-reachability`;
producer rule, emission, endpoint concepts, version, and digest remain separate.
Several rules may emit the same local predicate with different endpoint
concepts. `rootform show relation google/routes-to --format json` exposes
producers and endpoint pairs; sharing a predicate does not equate those pairs.

Policy queries use typed references. This repository contains no distributed
Policy Packs. A separate Policy Pack using these examples declares direct
dependencies and top-level Policies:

```hcl
policy_pack "network-checks" {
  version = "0.1.0"

  requires {
    core   = "0.1.0"
    google = "0.1.0"
  }
}

policy "cloud-run-connector" {
  target  = concept.google.cloud-run-service
  assert  = exists(relations(relation.google.routes-to, concept.google.serverless-vpc-access-connector))
  message = "Cloud Run must route through a VPC connector."
}

policy "database-private-network" {
  target = concept.core.managed-database
  assert = (
    exists(relations(relation.core.private-reachability, concept.core.virtual-network)) ||
    exists(relations(relation.core.private-reachability, concept.core.subnet))
  )
  message = "Managed databases must have private network reachability."
}
```

`exists` proves presence from a confirmed fact. Empty queries prove absence
only when supported and complete; unresolved evidence stays indeterminate
under negation. Use `length` for exact cardinalities. Context queries select an
outgoing dimension and target concept; contribution queries select incoming
contributors within the represented domain and their active rules. Neither
claims exhaustive Terraform coverage. A selected Policy with no target is
`not_evaluated`, never compliant.

Rules retain one `match` block. Its `kind` defaults to `resource`; explicit
`kind = "data"` remains necessary for data sources. A fact's nested `match`
compares target attributes and is a different operation. Concept kinds, `to`,
`via`, and imports remain explicit. One `dialect` declaration identifies a
Dialect; this corpus conventionally stores it in `dialect.rf`.

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

After installing the complete official inventory into an isolated
`ROOTFORM_HOME`, regenerate the public vocabulary with that same executable:

```bash
bun scripts/catalog.ts > evidence/core/semantic-catalog.json
```

`scripts/catalog.ts` calls Rootform `list` and `show`; it does not parse `.rf`
or maintain another authored catalog. The output records the executable version
and SHA-256. [Fixture generation evidence](evidence/core/scenarios.json) records
the command and executable used for the current golden corpus.

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
