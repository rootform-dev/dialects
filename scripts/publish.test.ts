import { expect, test } from "bun:test";
import { createHash } from "node:crypto";
import { mkdirSync, mkdtempSync, writeFileSync } from "node:fs";
import { tmpdir } from "node:os";
import { join } from "node:path";
import {
  INDEX_TAG,
  inspectLayout,
  OFFICIAL_REPOSITORY,
  orasTransportFlags,
  type PublicationRegistry,
  parsePublishArguments,
  publishDistribution,
} from "./publish.ts";

type Descriptor = {
  annotations?: Record<string, string>;
  artifactType?: string;
  digest: string;
  mediaType: string;
  size: number;
};

const manifestType = "application/vnd.oci.image.manifest.v1+json";

function digest(body: Uint8Array): string {
  return `sha256:${createHash("sha256").update(body).digest("hex")}`;
}

function writeBlob(layout: string, body: Buffer): Descriptor {
  const value = digest(body);
  const path = join(layout, "blobs", "sha256", value.slice("sha256:".length));
  mkdirSync(join(layout, "blobs", "sha256"), { recursive: true });
  writeFileSync(path, body);
  return { digest: value, mediaType: "application/octet-stream", size: body.byteLength };
}

function artifact(
  layout: string,
  options: {
    artifactType: string;
    config: Buffer;
    configType: string;
    layer: Buffer;
    layerType: string;
  },
): Descriptor {
  const config = { ...writeBlob(layout, options.config), mediaType: options.configType };
  const layer = { ...writeBlob(layout, options.layer), mediaType: options.layerType };
  const body = Buffer.from(
    JSON.stringify({
      artifactType: options.artifactType,
      config,
      layers: [layer],
      mediaType: manifestType,
      schemaVersion: 2,
    }),
  );
  return {
    ...writeBlob(layout, body),
    artifactType: options.artifactType,
    mediaType: manifestType,
  };
}

function writeLayout(options: { indexDrift?: boolean; root: string; salt?: string }): string {
  const layout = options.root;
  mkdirSync(layout, { recursive: true });
  const roots: Descriptor[] = [];
  const dialects: Array<{ descriptor: Descriptor; name: string; version: string }> = [];
  for (const name of ["alpha", "beta"]) {
    const version = "0.1.0";
    const descriptor = artifact(layout, {
      artifactType: "application/vnd.rootform.dialect.v1",
      config: Buffer.from(JSON.stringify({ name, version })),
      configType: "application/vnd.rootform.dialect.manifest.v1+json",
      layer: Buffer.from(`${name}-${options.salt ?? "stable"}\n`),
      layerType: "application/vnd.rootform.dialect.layer.v1.tar+gzip",
    });
    roots.push({
      ...descriptor,
      annotations: { "org.opencontainers.image.ref.name": `dialect-${name}-${version}` },
    });
    dialects.push({ descriptor, name, version });
  }
  const indexLayer = Buffer.from(
    JSON.stringify({
      dialects: dialects.map(({ descriptor, name, version }, position) => ({
        artifact: {
          manifest_digest:
            options.indexDrift && position === 0 ? `sha256:${"f".repeat(64)}` : descriptor.digest,
          manifest_size: descriptor.size,
        },
        name,
        version,
      })),
      format_version: "1",
      repository: OFFICIAL_REPOSITORY,
    }),
  );
  const index = artifact(layout, {
    artifactType: "application/vnd.rootform.dialect-index.v1",
    config: Buffer.from('{"format_version":"1"}'),
    configType: "application/vnd.rootform.dialect-index.config.v1+json",
    layer: indexLayer,
    layerType: "application/vnd.rootform.dialect-index.v1+json",
  });
  roots.push({
    ...index,
    annotations: { "org.opencontainers.image.ref.name": INDEX_TAG },
  });
  writeFileSync(join(layout, "oci-layout"), '{"imageLayoutVersion":"1.0.0"}');
  writeFileSync(
    join(layout, "index.json"),
    JSON.stringify({
      manifests: roots,
      mediaType: "application/vnd.oci.image.index.v1+json",
      schemaVersion: 2,
    }),
  );
  return layout;
}

class FakeRegistry implements PublicationRegistry {
  readonly operations: string[] = [];
  readonly tags = new Map<string, string>();
  failVerification?: string;

  push(layout: string, sourceTag: string, destinationTag: string): void {
    this.operations.push(`push ${sourceTag} ${destinationTag}`);
    const inventory = inspectLayout(layout);
    const entry = [...inventory.dialects, inventory.index].find(({ tag }) => tag === sourceTag);
    if (!entry) throw new Error("missing source tag");
    this.tags.set(destinationTag, entry.descriptor.digest);
  }

  resolve(tag: string): string | undefined {
    this.operations.push(`resolve ${tag}`);
    return this.tags.get(tag);
  }

  tag(value: string, tag: string): void {
    this.operations.push(`tag ${tag}`);
    this.tags.set(tag, value);
  }

  verify(_layout: string, sourceTag: string, _value: string): void {
    this.operations.push(`verify ${sourceTag}`);
    if (this.failVerification === sourceTag) throw new Error(`verification failed: ${sourceTag}`);
  }
}

function publisherFixture(options: { secondSalt?: string } = {}) {
  const registry = new FakeRegistry();
  const workspace = mkdtempSync(join(tmpdir(), "rootform-publish-test-"));
  let builds = 0;
  const evidence = () =>
    publishDistribution({
      buildLayout(destination) {
        builds++;
        writeLayout({ root: destination, salt: builds === 2 ? options.secondSalt : undefined });
      },
      registry,
      repository: OFFICIAL_REPOSITORY,
      workingDirectory: workspace,
    });
  return { builds: () => builds, evidence, registry, workspace };
}

test("publishes every dialect before a regenerated verified index and moves discovery last", () => {
  const fixture = publisherFixture();
  const evidence = fixture.evidence();
  const immutableIndex = evidence.index.immutable_tag;
  expect(fixture.builds()).toBe(2);
  expect(fixture.registry.operations).toEqual([
    "resolve dialect-alpha-0.1.0",
    "resolve dialect-beta-0.1.0",
    "push dialect-alpha-0.1.0 dialect-alpha-0.1.0",
    "resolve dialect-alpha-0.1.0",
    "verify dialect-alpha-0.1.0",
    "push dialect-beta-0.1.0 dialect-beta-0.1.0",
    "resolve dialect-beta-0.1.0",
    "verify dialect-beta-0.1.0",
    `resolve ${immutableIndex}`,
    `push ${INDEX_TAG} ${immutableIndex}`,
    `resolve ${immutableIndex}`,
    `verify ${INDEX_TAG}`,
    `tag ${INDEX_TAG}`,
    `resolve ${INDEX_TAG}`,
  ]);
  expect(evidence.artifacts.map(({ name }) => name)).toEqual(["alpha", "beta"]);
  expect(fixture.registry.tags.get(INDEX_TAG)).toBe(evidence.index.manifest_digest);
  expect(JSON.stringify(evidence)).not.toContain(fixture.workspace);
});

test("preflights every immutable dialect tag and refuses drift before any push", () => {
  const fixture = publisherFixture();
  fixture.registry.tags.set("dialect-beta-0.1.0", `sha256:${"a".repeat(64)}`);
  expect(fixture.evidence).toThrow("immutable dialect tag already has different content");
  expect(fixture.registry.operations.some((operation) => operation.startsWith("push "))).toBe(
    false,
  );
  expect(fixture.builds()).toBe(1);
});

test("never builds or publishes an index after artifact verification failure", () => {
  const fixture = publisherFixture();
  fixture.registry.failVerification = "dialect-beta-0.1.0";
  expect(fixture.evidence).toThrow("verification failed");
  expect(fixture.builds()).toBe(1);
  expect(fixture.registry.operations.some((operation) => operation.includes(INDEX_TAG))).toBe(
    false,
  );
});

test("refuses regenerated distribution drift before index publication", () => {
  const fixture = publisherFixture({ secondSalt: "changed" });
  expect(fixture.evidence).toThrow("distribution changed after artifact publication");
  expect(fixture.builds()).toBe(2);
  expect(fixture.registry.operations.some((operation) => operation.includes(INDEX_TAG))).toBe(
    false,
  );
});

test("layout inspection rejects an index that references another dialect digest", () => {
  const layout = writeLayout({
    indexDrift: true,
    root: mkdtempSync(join(tmpdir(), "rootform-layout-")),
  });
  expect(() => inspectLayout(layout)).toThrow("unpublished dialect descriptor");
});

test("publish arguments keep production fixed and bound test injection to loopback", () => {
  const root = mkdtempSync(join(tmpdir(), "rootform-publish-arguments-"));
  const config = join(root, "config.json");
  const ca = join(root, "ca.pem");
  writeFileSync(config, "{}\n");
  writeFileSync(ca, "test-ca\n");
  expect(
    parsePublishArguments(
      ["--rootform-version=0.1.0", "--evidence", "evidence.json", "--registry-config", config],
      root,
    ),
  ).toEqual({
    caFile: undefined,
    evidence: join(root, "evidence.json"),
    plainHTTP: false,
    registryConfig: config,
    repository: OFFICIAL_REPOSITORY,
    versionArguments: ["--rootform-version", "0.1.0"],
  });
  expect(
    parsePublishArguments(
      [
        "--rootform-version",
        "0.1.0",
        "--evidence=evidence.json",
        "--test-repository=127.0.0.1:5000/rootform-dev/dialects",
        "--ca-file",
        ca,
      ],
      root,
    ).repository,
  ).toBe("127.0.0.1:5000/rootform-dev/dialects");
  expect(() =>
    parsePublishArguments(["--rootform-version=0.1.0", "--evidence=x", "--plain-http"], root),
  ).toThrow("custom transport");
  expect(() =>
    parsePublishArguments(
      [
        "--rootform-version=0.1.0",
        "--evidence=x",
        "--test-repository=registry.example/rootform-dev/dialects",
      ],
      root,
    ),
  ).toThrow("loopback registry");
});

test("ORAS copy applies registry transport flags to correct remote side", () => {
  expect(
    orasTransportFlags({
      caFile: "/ca.pem",
      plainHTTP: true,
      registryConfig: "/auth.json",
    }),
  ).toEqual({
    common: ["--registry-config", "/auth.json", "--ca-file", "/ca.pem", "--plain-http"],
    from: [
      "--from-registry-config",
      "/auth.json",
      "--from-ca-file",
      "/ca.pem",
      "--from-plain-http",
    ],
    to: ["--to-registry-config", "/auth.json", "--to-ca-file", "/ca.pem", "--to-plain-http"],
  });
});
