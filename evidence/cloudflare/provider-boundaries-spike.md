# SPEC-065 provider boundaries spike

- Date: 2026-08-29
- Result: Pass
- Time box: 90 minutes

## Question

Can provider `5.24.0` support broad Cloudflare architecture and cross-cloud
facts without changing core, Rootform Language, Architecture IR, or renderer?

## Evidence

```text
provider: cloudflare/cloudflare 5.24.0
tag: v5.24.0
commit: 4f360d592a7d968c684a9b212c26808534b7c0d3
tree: 748f3e04b8d70285b718f4c8eaa4e7204cc5a60e
published: 2026-08-24T18:09:25Z
Terraform: 1.12.2
schema bytes: 2,940,546
schema SHA-256: eab917fd09647d565380e0a5e38181948c6d210526084e7447995c221506d36b
darwin/arm64 binary SHA-256: c9ee36793ccdb6dfd978dcaac273ef0f4e78e7370d7b9eb9498d3a34e4954686
source tarball SHA-256: d47f5a91d9fd8d38329549c54812707c1178717555ce9e050c9007aa877f7e56
managed resources: 259
data sources: 449
ephemeral resources/functions/resource identities: 0/0/0
credentials/provider configuration used: no/no
```

Official provider docs and source expose closed resource/data-source
inventories. Cloudflare architecture docs establish pools as endpoint groups,
Tunnel as an outbound logical link to private resources, Workers bindings as
resource access, R2 notifications as Queue messages, Access as protection in
front of applications, and Cloudflare WAN multi-cloud connectivity through
native AWS/Azure/GCP VPN gateways.

Rootform Language already models fixed attribute and index paths, but the
source resolver initially proved a narrower implementation boundary: it walked
Terraform nested blocks but stopped when provider v5 syntax expressed the same
shape as list/object attributes. A minimal Worker-to-R2 fixture produced
`TRAVERSAL_UNRESOLVED` at `bindings[0].bucket_name`. Normalized expressions
retain references but intentionally omit object keys, so guessing from child
order would be unsafe.

The accepted solution is provider-neutral: retained same-read HCL selects a
fixed list index and statically known object key, then returns only redacted
reference evidence to the existing resolver. Dynamic collections, unknown or
duplicate keys, out-of-range indices, and closed/no-syntax sessions fail
closed. No raw value, HCL AST, or source text crosses the parser boundary.
Nested binding/origin lists remain explicitly bounded by authored indices; the
dialect emits no fact past that bound. Literal CIDRs/hostnames still prove no
cloud target. Data sources remain exhaustive read-only inventory.

No new core identity is necessary. `edge-route`, `origin-pool`, Tunnel, Access,
and Cloudflare developer-platform differences remain local. Existing core
concepts cover DNS zone, load balancer, serverless function, object storage,
managed database, queue, workflow, secret, identity, group, VPN connection,
and VPN gateway. Kubernetes `LoadBalancer` Service can reuse existing
`core.load-balancer` without changing core.

Cloudflare trademark terms permit word-mark references but require written
permission for logos. No such permission is evidenced. Rootform therefore
ships no Cloudflare logo and uses neutral fallback.

## Official sources

- <https://github.com/cloudflare/terraform-provider-cloudflare/releases/tag/v5.24.0>
- <https://developers.cloudflare.com/api/terraform/>
- <https://developers.cloudflare.com/reference-architecture/architectures/>
- <https://developers.cloudflare.com/load-balancing/pools/>
- <https://developers.cloudflare.com/workers/platform/infrastructure-as-code/>
- <https://developers.cloudflare.com/r2/buckets/event-notifications/>
- <https://developers.cloudflare.com/cloudflare-one/networks/connectors/cloudflare-tunnel/>
- <https://developers.cloudflare.com/cloudflare-one/networks/connectivity-options/>
- <https://developers.cloudflare.com/cloudflare-one/access-controls/applications/choose-application-type/>
- <https://www.cloudflare.com/trademark/>

## Verdict

Proceed with exact `= 5.24.0`, exhaustive decisions, targeted semantics,
provider-neutral fixed-path reference selection, bounded nested paths, no new
core/Language/IR contract, and neutral icon fallback. Revisit compatibility on
later provider evidence, not every minor.
