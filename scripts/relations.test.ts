import { expect, test } from "bun:test";
import { existsSync, readdirSync, readFileSync } from "node:fs";
import { join } from "node:path";

const root = join(import.meta.dir, "..");

// Target Architecture IR v0.1 (target spec §8): architecture.representations is
// the single uniform representation collection, symbol identities are owner-first
// (owner.kind.name, e.g. rf.concept.managed-database, google.rule.cloud-sql-instance),
// and facts carry resolution-backed provenance. Slice goldens are regenerated
// against the target IR, so every behavior test below runs and must pass.

type Provenance = {
  emission: string;
  rule: string;
  resolution: string;
};

type Representation = {
  id: string;
  declaration?: string;
  rule?: string;
  concept?: string;
  implementation?: { declaration?: string };
};

type Fact = {
  from: string;
  to: string;
  dimension?: string;
  predicate?: string;
  provenance?: Provenance[];
};

type Emission = {
  id: string;
  rule: string;
  kind: string;
  to?: string;
  via?: string;
};

type ArchitectDocument = {
  semantics: {
    emissions?: Emission[];
    owners?: Array<{ owner: string; nature: string }>;
  };
  architecture: {
    representations: Representation[];
    contexts?: Fact[];
    relations?: Fact[];
    omissions?: Array<{ representation: string; emission: string; reason?: string }>;
  };
  resolutions?: Array<{ id: string }>;
  diagnostics?: Array<{ declaration?: string; emission?: string; code?: string }>;
};

const SLICES = [
  ["azure-aks", "azurerm_kubernetes_cluster", "workloads"],
  ["azure-database", "azurerm_postgresql_flexible_server", "records"],
  ["azure-network", "azurerm_virtual_network_peering", "platform"],
  ["azure-ownership-sweep", "azurerm_arc_kubernetes_cluster", "owned"],
  ["cloud-sql", "google_sql_database_instance", "db"],
  ["eks", "aws_eks_cluster", "workloads"],
  ["gke", "google_container_cluster", "cluster"],
  ["google-cloud-run", "google_cloud_run_v2_service", "connector"],
] as const;

function fixture(name: string): ArchitectDocument {
  return JSON.parse(
    readFileSync(join(root, "fixtures/slice", name, "architecture.golden"), "utf8"),
  ) as ArchitectDocument;
}

function sourceId(kind: string, type: string, name: string): string {
  return `source:1:root:${kind}:${type}.${name}`;
}

function representation(doc: ArchitectDocument, kind: string, type: string, name: string) {
  const id = sourceId(kind, type, name);
  return doc.architecture.representations.find(
    (entry) => entry.declaration === id || entry.implementation?.declaration === id,
  );
}

test("slice behavior goldens are present", () => {
  for (const [name] of SLICES) {
    expect(existsSync(join(root, "fixtures/slice", name, "architecture.golden"))).toBeTrue();
  }
});

test("kubernetes clusters get one uniform rf.concept.kubernetes-cluster representation", () => {
  for (const [name, type, resource] of SLICES) {
    if (!type.includes("kubernetes_cluster")) continue;
    const doc = fixture(name);
    const entry = representation(doc, "resource", type, resource);
    expect(entry).toBeDefined();
    expect(entry?.concept).toBe("rf.concept.kubernetes-cluster");
    expect(entry?.rule).toMatch(/^[a-z0-9-]+.rule./u);
    expect("scopes" in doc.architecture).toBe(false);
    expect("entities" in doc.architecture).toBe(false);
  }
});

test("cloud-sql keeps its managed-database classification and a resolution-backed network context", () => {
  const doc = fixture("cloud-sql");
  const instance = representation(doc, "resource", "google_sql_database_instance", "db");
  const network = representation(doc, "resource", "google_compute_network", "vpc");
  expect(instance).toBeDefined();
  expect(instance?.concept).toBe("rf.concept.managed-database");
  expect(instance?.rule).toBe("google.rule.cloud-sql-instance");
  expect(network?.concept).toBe("rf.concept.virtual-network");

  const fact = doc.architecture.contexts?.find(
    (entry) => entry.from === instance?.id && entry.to === network?.id,
  );
  expect(fact).toBeDefined();
  expect(fact?.dimension).toBe("rf.context.network");
  expect(fact?.provenance?.[0]).toMatchObject({
    rule: "google.rule.cloud-sql-instance",
  });
  expect(doc.resolutions?.some((entry) => entry.id === fact?.provenance?.[0]?.resolution)).toBe(
    true,
  );

  const serialized = JSON.stringify(doc);
  expect(serialized).not.toContain("core/");
  expect(serialized).not.toContain("entity:");
  expect(serialized).not.toContain("scope:");
  expect(serialized).not.toContain("private-reachability");
});

test("delegated subnet injection is network placement, not a relation", () => {
  const doc = fixture("azure-database");
  const server = representation(doc, "resource", "azurerm_postgresql_flexible_server", "records");
  const subnet = representation(doc, "resource", "azurerm_subnet", "database");
  expect(server).toBeDefined();
  expect(subnet).toBeDefined();
  expect(
    doc.architecture.contexts?.some(
      (entry) =>
        entry.from === server?.id &&
        entry.to === subnet?.id &&
        entry.dimension === "rf.context.network",
    ),
  ).toBe(true);
  expect(
    doc.architecture.relations?.some(
      (entry) => entry.from === server?.id && entry.to === subnet?.id,
    ),
  ).toBe(false);
  expect(JSON.stringify(doc)).not.toContain("private-reachability");
});

test("a local relation retains its emission and resolution provenance", () => {
  const doc = fixture("google-cloud-run");
  const fact = doc.architecture.relations?.find(
    (entry) => entry.predicate === "google.relation.routes-to",
  );
  expect(fact).toBeDefined();
  expect(fact?.from).toBe(
    representation(doc, "resource", "google_cloud_run_v2_service", "connector")?.id,
  );
  const provenance = fact?.provenance?.[0];
  expect(provenance?.rule).toBe("google.rule.cloud-run-service");
  expect(doc.resolutions?.some((entry) => entry.id === provenance?.resolution)).toBe(true);
  expect(
    doc.semantics.emissions?.some(
      (entry) =>
        entry.id === provenance?.emission && entry.rule === "google.rule.cloud-run-service",
    ),
  ).toBe(true);
});

test("an empty optional route and an unresolved route have different closure evidence", () => {
  const doc = fixture("google-cloud-run");
  const emission = doc.semantics.emissions?.find(
    (entry) =>
      entry.rule === "google.rule.cloud-run-service" &&
      entry.kind === "relation" &&
      entry.via?.includes("connector"),
  );
  expect(emission).toBeDefined();
  expect(
    doc.architecture.omissions?.some(
      (entry) =>
        entry.representation ===
          representation(doc, "resource", "google_cloud_run_v2_service", "api")?.id &&
        entry.emission === emission?.id &&
        entry.reason === "source_absent",
    ),
  ).toBe(true);
  expect(
    doc.diagnostics?.some(
      (entry) =>
        entry.declaration === sourceId("resource", "google_cloud_run_v2_service", "unknown") &&
        entry.emission === emission?.id &&
        entry.code === "TRAVERSAL_UNRESOLVED",
    ),
  ).toBe(true);
  const unknown = representation(doc, "resource", "google_cloud_run_v2_service", "unknown");
  expect(unknown).toBeDefined();
  expect(unknown?.rule).toBe("google.rule.cloud-run-service");
  expect(
    doc.architecture.relations?.some(
      (entry) => entry.from === sourceId("resource", "google_cloud_run_v2_service", "unknown"),
    ),
  ).toBe(false);
});

test("network peerings keep containment distinct from remote connectivity", () => {
  const doc = fixture("azure-network");
  const peerings = [
    ["platform", "platform", "remote"],
    ["remote_to_platform", "remote", "platform"],
  ] as const;
  for (const [peeringResource, localResource, remoteResource] of peerings) {
    const peering = representation(
      doc,
      "resource",
      "azurerm_virtual_network_peering",
      peeringResource,
    );
    const local = representation(doc, "resource", "azurerm_virtual_network", localResource);
    const remote = representation(doc, "resource", "azurerm_virtual_network", remoteResource);
    expect(peering).toBeDefined();
    expect(local).toBeDefined();
    expect(remote).toBeDefined();
    expect(
      doc.architecture.contexts?.some(
        (entry) =>
          entry.from === peering?.id &&
          entry.to === local?.id &&
          entry.dimension === "rf.context.network",
      ),
    ).toBe(true);
    expect(
      doc.architecture.relations?.some(
        (entry) =>
          entry.from === peering?.id &&
          entry.to === remote?.id &&
          entry.predicate === "azure.relation.peers-with",
      ),
    ).toBe(true);
  }
  for (const unresolved of ["literal", "unknown"]) {
    const id = sourceId("resource", "azurerm_virtual_network_peering", unresolved);
    expect(doc.architecture.contexts?.some((entry) => entry.from === id)).toBe(false);
    expect(doc.architecture.relations?.some((entry) => entry.from === id)).toBe(false);
  }
});

test("every fact is closed over representations and proofs", () => {
  for (const directory of readdirSync(join(root, "fixtures/slice"), { withFileTypes: true })) {
    if (!directory.isDirectory()) continue;
    const doc = fixture(directory.name);
    if (!Array.isArray(doc.architecture?.representations)) continue;
    const representationIds = new Set(doc.architecture.representations.map((entry) => entry.id));
    const emissionIds = new Set(doc.semantics.emissions?.map((entry) => entry.id) ?? []);
    const resolutionIds = new Set(doc.resolutions?.map((entry) => entry.id) ?? []);
    for (const fact of [
      ...(doc.architecture.contexts ?? []),
      ...(doc.architecture.relations ?? []),
    ]) {
      expect(representationIds.has(fact.from)).toBe(true);
      expect(representationIds.has(fact.to)).toBe(true);
      for (const provenance of fact.provenance ?? []) {
        expect(emissionIds.has(provenance.emission)).toBe(true);
        expect(resolutionIds.has(provenance.resolution)).toBe(true);
      }
    }
  }
});
