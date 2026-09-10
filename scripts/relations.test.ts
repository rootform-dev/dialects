import { expect, test } from "bun:test";
import { readFileSync } from "node:fs";
import { join } from "node:path";

const root = join(import.meta.dir, "..");

type Architecture = {
  semantics: {
    emissions: { id: string; rule: string; predicate?: string }[];
  };
  architecture: {
    entities: { id: string; concept: string }[];
    scopes: { id: string; concept: string }[];
    contexts: {
      from: string;
      to: string;
      dimension: string;
      provenance: { emission: string; rule: string; via: string }[];
    }[];
    relations: {
      from: string;
      to: string;
      predicate: string;
      provenance: { emission: string; rule: string; via: string }[];
    }[];
    omissions: { representation: string; emission: string; reason: string }[];
  };
  diagnostics: { declaration?: string; emission?: string; code: string }[];
};

function fixture(name: string): Architecture {
  return JSON.parse(
    readFileSync(join(root, "fixtures/slice", name, "architecture.golden"), "utf8"),
  ) as Architecture;
}

test("Kubernetes clusters are runtime scopes across managed and hybrid providers", () => {
  const cases = [
    ["azure-aks", "scope:azurerm_kubernetes_cluster.workloads"],
    ["gke", "scope:google_container_cluster.cluster"],
    ["eks", "scope:aws_eks_cluster.workloads"],
    ["azure-ownership-sweep", "scope:azurerm_arc_kubernetes_cluster.owned"],
  ] as const;

  for (const [name, id] of cases) {
    const document = fixture(name);
    expect(document.architecture.scopes).toContainEqual(
      expect.objectContaining({ id, concept: "core/kubernetes-cluster" }),
    );
    expect(document.architecture.entities.some((entity) => entity.id === id)).toBe(false);
  }
});

test("shared reachability preserves its owner and distinct Google/Azure producers", () => {
  const catalog = JSON.parse(
    readFileSync(join(root, "evidence/core/semantic-catalog.json"), "utf8"),
  );
  expect(catalog.relations).toHaveLength(1);
  expect(catalog.relations[0]).toMatchObject({ id: "core/private-reachability", shared: true });
  expect(catalog.relations[0].producers).toEqual([
    expect.objectContaining({
      rule: "azure/postgresql-flexible-server",
      from: "core/managed-database",
      to: "core/subnet",
    }),
    expect.objectContaining({
      rule: "google/cloud-sql-instance",
      from: "core/managed-database",
      to: "core/virtual-network",
    }),
  ]);
  for (const name of ["cloud-sql", "azure-database"]) {
    const relations = fixture(name).architecture.relations;
    expect(relations.some((fact) => fact.predicate === "core/private-reachability")).toBe(true);
  }
});

test("local Google route fact retains emission and resolution provenance", () => {
  const document = fixture("google-cloud-run");
  const fact = document.architecture.relations.find(
    (entry) => entry.predicate === "google/routes-to",
  );
  expect(fact).toBeDefined();
  expect(fact?.from).toBe("entity:google_cloud_run_v2_service.connector");
  expect(fact?.provenance).toContainEqual(
    expect.objectContaining({ rule: "google/cloud-run-service", via: expect.any(String) }),
  );
  expect(document.semantics.emissions).toContainEqual(
    expect.objectContaining({ id: fact?.provenance[0]?.emission, predicate: "google/routes-to" }),
  );
});

test("empty optional route and unresolved route have different closure evidence", () => {
  const document = fixture("google-cloud-run");
  const emission = document.semantics.emissions.find(
    (entry) => entry.rule === "google/cloud-run-service" && entry.predicate === "google/routes-to",
  );
  expect(emission).toBeDefined();
  expect(document.architecture.omissions).toContainEqual(
    expect.objectContaining({
      representation: "entity:google_cloud_run_v2_service.api",
      emission: emission?.id,
      reason: "source_absent",
    }),
  );
  expect(document.diagnostics).toContainEqual(
    expect.objectContaining({
      declaration: "source:google_cloud_run_v2_service.unknown",
      emission: emission?.id,
      code: "TRAVERSAL_UNRESOLVED",
    }),
  );
  expect(
    document.architecture.omissions.some(
      (entry) =>
        entry.representation === "entity:google_cloud_run_v2_service.unknown" &&
        entry.emission === emission?.id,
    ),
  ).toBe(false);
});

test("Azure VNet peering keeps local containment distinct from remote connectivity", () => {
  const document = fixture("azure-network");
  const peerings = [
    {
      from: "entity:azurerm_virtual_network_peering.platform",
      local: "scope:azurerm_virtual_network.platform",
      remote: "scope:azurerm_virtual_network.remote",
    },
    {
      from: "entity:azurerm_virtual_network_peering.remote_to_platform",
      local: "scope:azurerm_virtual_network.remote",
      remote: "scope:azurerm_virtual_network.platform",
    },
  ];

  for (const peering of peerings) {
    expect(document.architecture.contexts).toContainEqual(
      expect.objectContaining({
        from: peering.from,
        to: peering.local,
        dimension: "core/network",
      }),
    );
    expect(document.architecture.relations).toContainEqual(
      expect.objectContaining({
        from: peering.from,
        to: peering.remote,
        predicate: "azure/peers-with",
        provenance: [
          expect.objectContaining({
            rule: "azure/virtual-network-peering",
            via: expect.stringContaining("remote_virtual_network_id"),
          }),
        ],
      }),
    );
  }

  for (const unresolved of ["literal", "unknown"]) {
    const from = `entity:azurerm_virtual_network_peering.${unresolved}`;
    expect(
      document.architecture.contexts.some(
        (fact) => fact.from === from && fact.dimension === "core/network",
      ),
    ).toBe(false);
    expect(document.architecture.relations.some((fact) => fact.from === from)).toBe(false);
  }
});

test("Azure Application Gateway uses an owned WAF policy", () => {
  const document = fixture("azure-load-balancing");
  expect(document.architecture.contexts).toContainEqual(
    expect.objectContaining({
      from: "entity:azurerm_web_application_firewall_policy.edge",
      to: "scope:azurerm_resource_group.edge",
      dimension: "core/ownership",
      provenance: [
        expect.objectContaining({
          rule: "azure/web-application-firewall-policy",
          via: expect.stringContaining("resource_group_name"),
        }),
      ],
    }),
  );
  expect(document.architecture.relations).toContainEqual(
    expect.objectContaining({
      from: "entity:azurerm_application_gateway.web",
      to: "entity:azurerm_web_application_firewall_policy.edge",
      predicate: "azure/uses-waf-policy",
      provenance: [
        expect.objectContaining({
          rule: "azure/application-gateway",
          via: expect.stringContaining("firewall_policy_id"),
        }),
      ],
    }),
  );
});

test("Azure Service Bus preserves namespace, topic, and subscription ownership", () => {
  const document = fixture("azure-service-bus");
  const topic = "scope:azurerm_servicebus_topic.events";
  const subscription = "entity:azurerm_servicebus_subscription.worker";

  expect(document.architecture.scopes).toContainEqual(
    expect.objectContaining({ id: topic, concept: "azure/service-bus-topic" }),
  );
  expect(document.architecture.contexts).toContainEqual(
    expect.objectContaining({
      from: topic,
      to: "scope:azurerm_servicebus_namespace.platform",
      dimension: "core/ownership",
    }),
  );
  expect(document.architecture.contexts).toContainEqual(
    expect.objectContaining({ from: subscription, to: topic, dimension: "core/ownership" }),
  );
  expect(document.architecture.relations).toContainEqual(
    expect.objectContaining({
      from: subscription,
      to: topic,
      predicate: "azure/subscribes-to",
    }),
  );
  expect(
    document.architecture.contexts.some(
      (fact) =>
        fact.from === subscription && fact.to === "scope:azurerm_servicebus_namespace.platform",
    ),
  ).toBe(false);

  for (const unresolved of ["literal", "unknown"]) {
    const from = `entity:azurerm_servicebus_subscription.${unresolved}`;
    expect(document.architecture.contexts.some((fact) => fact.from === from)).toBe(false);
    expect(document.architecture.relations.some((fact) => fact.from === from)).toBe(false);
  }
});

test("Azure Event Grid system subscriptions belong to their exact topic", () => {
  const document = fixture("azure-event-grid");
  const topic = "scope:azurerm_eventgrid_system_topic.storage";

  expect(document.architecture.scopes).toContainEqual(
    expect.objectContaining({ id: topic, concept: "azure/event-grid-topic" }),
  );
  for (const name of ["eventhub", "queue", "topic", "function", "storage"]) {
    const from = `entity:azurerm_eventgrid_system_topic_event_subscription.${name}`;
    expect(document.architecture.contexts).toContainEqual(
      expect.objectContaining({ from, to: topic, dimension: "core/ownership" }),
    );
    expect(document.architecture.relations).toContainEqual(
      expect.objectContaining({ from, to: topic, predicate: "azure/subscribes-to" }),
    );
    expect(
      document.architecture.contexts.some(
        (fact) => fact.from === from && fact.to === "scope:azurerm_resource_group.platform",
      ),
    ).toBe(false);
  }

  for (const unresolved of ["literal", "unknown"]) {
    const from = `entity:azurerm_eventgrid_system_topic_event_subscription.${unresolved}`;
    expect(document.architecture.contexts.some((fact) => fact.from === from)).toBe(false);
    expect(
      document.architecture.relations.some(
        (fact) => fact.from === from && fact.predicate === "azure/subscribes-to",
      ),
    ).toBe(false);
  }
});
