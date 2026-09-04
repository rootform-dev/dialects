# AWS provider-surfaces spike

- Date: 2026-08-29
- Result: Pass
- Time box: 90 minutes

## Question

Can exact `hashicorp/aws` `6.62.0` surfaces be inventoried exhaustively while
keeping durable architecture separate from operations, lookups, and queries?

## Verdict

Yes. Terraform `1.12.2` loaded signed provider `6.62.0` without AWS
configuration or credentials. Schema RPC and exact generated source provide a
closed baseline:

| Kind | Count | Architecture treatment |
| --- | ---: | --- |
| managed resource | 1,711 | candidate for rule or explicit decision |
| data source | 679 | read-only lookup; represent only with independent proof |
| ephemeral resource | 10 | non-durable; supporting or unrepresented |
| action | 12 | imperative side effect; never durable entity |
| list resource | 210 | `.tfquery.hcl` discovery/import surface; not source architecture |
| function | 4 | expression helper; no declaration node |
| resource identity | 501 | provider protocol metadata; no declaration node |

Actions are provider-defined side effects and do not modify resource state.
They may support an already represented owner only through exact accepted owner
resolution. List resources query remote infrastructure for bulk import; current
Rootform source ingestion does not read `.tfquery.hcl`, and query results are
not Terraform source of truth. They remain exhaustive inventory with
`intentionally-unrepresented/query-surface`, not received declaration
`unsupported`.

Compatibility remains exactly `= 6.62.0`: only this schema, source registration,
used paths, and meaning are proven. Exactness is temporary evidence, not a rule
requiring a new dialect for every provider minor.

## Evidence

```text
provider tag: v6.62.0
commit: 839fe4af13f9ed6e33a5a6f5938e3356e07951cc
tree: d0a313417785edd6eb729e92d212d941c98f2168
published: 2026-08-26T19:44:44Z
schema bytes: 19,383,928
schema SHA-256: 5555d4532a027c0ee14f40ef10ce8a230a4c31971f90a71b1aab5b068b4e2677
darwin/arm64 binary SHA-256: b4a6d7c13a2e3d98ea97d625ab469f8d637b6796b23d518350b268cdb486c17b
catalog products: 253
catalog response SHA-256: c8822f303d06e701d15752a87834b4672fdcd132cbe7af8866ae59c2ea2a43d1
```

Commands:

```text
terraform init -backend=false -input=false
terraform providers schema -json
git clone --depth 1 --branch v6.62.0 https://github.com/hashicorp/terraform-provider-aws.git
curl https://aws.amazon.com/api/dirs/items/search?...aws-products...
```

Official sources:

- <https://github.com/hashicorp/terraform-provider-aws/releases/tag/v6.62.0>
- <https://developer.hashicorp.com/terraform/language/block/action>
- <https://developer.hashicorp.com/terraform/plugin/framework/actions>
- <https://developer.hashicorp.com/terraform/language/files/tfquery>
- <https://developer.hashicorp.com/terraform/plugin/framework/list-resources>

## Limitations

Schema presence proves shape, not architecture meaning. Case-insensitive macOS
checkout reported testdata path collisions, but exact generated registration
files and Git tree identity remained readable. Compatibility beyond `6.62.0`
needs another path and meaning comparison.
