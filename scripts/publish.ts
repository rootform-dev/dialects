#!/usr/bin/env bun

import { createHash } from "node:crypto";
import {
  existsSync,
  lstatSync,
  mkdirSync,
  mkdtempSync,
  readdirSync,
  readFileSync,
  rmSync,
  writeFileSync,
} from "node:fs";
import { tmpdir } from "node:os";
import { dirname, isAbsolute, join, resolve } from "node:path";
import { packageDialects } from "./package.ts";

export const OFFICIAL_REPOSITORY = "ghcr.io/rootform-dev/dialects";
export const INDEX_TAG = "official-index-v1";

const OCI_INDEX_TYPE = "application/vnd.oci.image.index.v1+json";
const OCI_MANIFEST_TYPE = "application/vnd.oci.image.manifest.v1+json";
const DIALECT_ARTIFACT_TYPE = "application/vnd.rootform.dialect.v1";
const DIALECT_CONFIG_TYPE = "application/vnd.rootform.dialect.manifest.v1+json";
const DIALECT_LAYER_TYPE = "application/vnd.rootform.dialect.layer.v1.tar+gzip";
const INDEX_ARTIFACT_TYPE = "application/vnd.rootform.dialect-index.v1";
const INDEX_CONFIG_TYPE = "application/vnd.rootform.dialect-index.config.v1+json";
const INDEX_LAYER_TYPE = "application/vnd.rootform.dialect-index.v1+json";
const DIGEST = /^sha256:[0-9a-f]{64}$/u;
const DIALECT_TAG =
  /^dialect-([a-z][a-z0-9]*(?:-[a-z0-9]+)*)-(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)$/u;
const MAX_METADATA_BYTES = 4 * 1024 * 1024;
const MAX_BLOB_BYTES = 16 * 1024 * 1024;

type JsonObject = Record<string, unknown>;

type Descriptor = {
  annotations?: Record<string, string>;
  artifactType?: string;
  digest: string;
  mediaType: string;
  size: number;
};

export type LayoutEntry = {
  descriptor: Descriptor;
  name?: string;
  tag: string;
  version?: string;
};

export type LayoutInventory = {
  dialects: LayoutEntry[];
  index: LayoutEntry;
};

export type PublicationEvidence = {
  artifacts: Array<{
    manifest_digest: string;
    manifest_size: number;
    name: string;
    tag: string;
    version: string;
  }>;
  format_version: "1";
  index: {
    discovery_tag: typeof INDEX_TAG;
    immutable_tag: string;
    manifest_digest: string;
    manifest_size: number;
  };
  repository: string;
};

export interface PublicationRegistry {
  push(layout: string, sourceTag: string, destinationTag: string): void;
  resolve(tag: string): string | undefined;
  tag(digest: string, tag: string): void;
  verify(layout: string, sourceTag: string, digest: string): void;
}

export type PublishArguments = {
  caFile?: string;
  evidence: string;
  packageArguments: string[];
  plainHTTP: boolean;
  registryConfig?: string;
  repository: string;
};

function object(value: unknown, message: string): JsonObject {
  if (typeof value !== "object" || value === null || Array.isArray(value)) {
    throw new Error(message);
  }
  return value as JsonObject;
}

function readRegular(path: string, label: string, maximum = MAX_METADATA_BYTES): Buffer {
  if (!existsSync(path)) throw new Error(`${label} is missing`);
  const status = lstatSync(path);
  if (!status.isFile() || status.isSymbolicLink() || status.size < 1 || status.size > maximum) {
    throw new Error(`${label} must be a bounded regular file`);
  }
  return readFileSync(path);
}

function parseJSON(body: Uint8Array, message: string): JsonObject {
  try {
    return object(JSON.parse(Buffer.from(body).toString("utf8")), message);
  } catch {
    throw new Error(message);
  }
}

function digest(body: Uint8Array): string {
  return `sha256:${createHash("sha256").update(body).digest("hex")}`;
}

function descriptor(value: unknown, label: string): Descriptor {
  const record = object(value, `${label} descriptor is invalid`);
  if (
    typeof record.digest !== "string" ||
    !DIGEST.test(record.digest) ||
    typeof record.mediaType !== "string" ||
    typeof record.size !== "number" ||
    !Number.isSafeInteger(record.size) ||
    record.size < 1 ||
    record.size > MAX_BLOB_BYTES
  ) {
    throw new Error(`${label} descriptor is invalid`);
  }
  let annotations: Record<string, string> | undefined;
  if (record.annotations !== undefined) {
    const source = object(record.annotations, `${label} annotations are invalid`);
    annotations = {};
    for (const [name, content] of Object.entries(source)) {
      if (typeof content !== "string") throw new Error(`${label} annotations are invalid`);
      annotations[name] = content;
    }
  }
  if (record.artifactType !== undefined && typeof record.artifactType !== "string") {
    throw new Error(`${label} artifact type is invalid`);
  }
  return {
    annotations,
    artifactType: record.artifactType as string | undefined,
    digest: record.digest,
    mediaType: record.mediaType,
    size: record.size,
  };
}

function blobPath(layout: string, value: string): string {
  if (!DIGEST.test(value)) throw new Error("OCI digest is invalid");
  return join(layout, "blobs", "sha256", value.slice("sha256:".length));
}

function readBlob(layout: string, expected: Descriptor, label: string): Buffer {
  const body = readRegular(blobPath(layout, expected.digest), label, MAX_BLOB_BYTES);
  if (body.byteLength !== expected.size || digest(body) !== expected.digest) {
    throw new Error(`${label} digest or size changed`);
  }
  return body;
}

function manifestGraph(
  layout: string,
  root: Descriptor,
  expectedArtifactType: string,
): Descriptor[] {
  if (
    root.mediaType !== OCI_MANIFEST_TYPE ||
    (root.artifactType !== undefined && root.artifactType !== expectedArtifactType)
  ) {
    throw new Error("OCI root descriptor shape is invalid");
  }
  const manifest = parseJSON(readBlob(layout, root, "OCI manifest"), "OCI manifest is invalid");
  if (
    manifest.schemaVersion !== 2 ||
    manifest.mediaType !== OCI_MANIFEST_TYPE ||
    manifest.artifactType !== expectedArtifactType ||
    !Array.isArray(manifest.layers) ||
    manifest.layers.length !== 1
  ) {
    throw new Error("OCI manifest shape is invalid");
  }
  const config = descriptor(manifest.config, "OCI config");
  const layer = descriptor(manifest.layers[0], "OCI layer");
  readBlob(layout, config, "OCI config");
  readBlob(layout, layer, "OCI layer");
  return [root, config, layer];
}

function rootDescriptors(layout: string): LayoutEntry[] {
  const layoutBody = parseJSON(
    readRegular(join(layout, "oci-layout"), "OCI layout marker", 1024),
    "OCI layout marker is invalid",
  );
  if (layoutBody.imageLayoutVersion !== "1.0.0") throw new Error("OCI layout version is invalid");
  const index = parseJSON(
    readRegular(join(layout, "index.json"), "OCI layout index"),
    "OCI layout index is invalid",
  );
  if (
    index.schemaVersion !== 2 ||
    index.mediaType !== OCI_INDEX_TYPE ||
    !Array.isArray(index.manifests)
  ) {
    throw new Error("OCI layout index shape is invalid");
  }
  if (index.manifests.length < 1 || index.manifests.length > 1024) {
    throw new Error("OCI layout root inventory is invalid");
  }
  const seen = new Set<string>();
  return index.manifests.map((value, position) => {
    const root = descriptor(value, `OCI root ${position + 1}`);
    const tag = root.annotations?.["org.opencontainers.image.ref.name"];
    if (!tag || seen.has(tag)) throw new Error("OCI layout tags are invalid");
    seen.add(tag);
    return { descriptor: root, tag };
  });
}

export function inspectLayout(layout: string): LayoutInventory {
  const status = lstatSync(layout);
  if (!status.isDirectory() || status.isSymbolicLink()) {
    throw new Error("OCI layout must be a regular directory");
  }
  const roots = rootDescriptors(layout);
  if (roots.length < 2) throw new Error("OCI layout distribution is incomplete");
  const dialects: LayoutEntry[] = [];
  let indexEntry: LayoutEntry | undefined;
  for (const entry of roots) {
    if (entry.tag === INDEX_TAG) {
      if (indexEntry || entry.descriptor.artifactType !== INDEX_ARTIFACT_TYPE) {
        throw new Error("OCI layout official index is invalid");
      }
      const [, config, layer] = manifestGraph(layout, entry.descriptor, INDEX_ARTIFACT_TYPE);
      if (config?.mediaType !== INDEX_CONFIG_TYPE || layer?.mediaType !== INDEX_LAYER_TYPE) {
        throw new Error("OCI layout official index media types are invalid");
      }
      const configBody = readBlob(layout, config, "official index config");
      if (configBody.toString("utf8") !== '{"format_version":"1"}') {
        throw new Error("official index config is invalid");
      }
      indexEntry = entry;
      continue;
    }
    const match = entry.tag.match(DIALECT_TAG);
    if (!match?.[1] || entry.descriptor.artifactType !== DIALECT_ARTIFACT_TYPE) {
      throw new Error("OCI layout contains an unexpected root tag");
    }
    const version = `${match[2]}.${match[3]}.${match[4]}`;
    const [, config, layer] = manifestGraph(layout, entry.descriptor, DIALECT_ARTIFACT_TYPE);
    if (config?.mediaType !== DIALECT_CONFIG_TYPE || layer?.mediaType !== DIALECT_LAYER_TYPE) {
      throw new Error("dialect OCI media types are invalid");
    }
    const manifest = parseJSON(
      readBlob(layout, config, "dialect config"),
      "dialect config is invalid",
    );
    if (manifest.name !== match[1] || manifest.version !== version) {
      throw new Error("dialect tag and manifest identity differ");
    }
    dialects.push({ ...entry, name: match[1], version });
  }
  if (!indexEntry || dialects.length === 0)
    throw new Error("OCI layout distribution is incomplete");

  const [, , indexLayer] = manifestGraph(layout, indexEntry.descriptor, INDEX_ARTIFACT_TYPE);
  if (!indexLayer) throw new Error("official index layer is missing");
  const published = parseJSON(
    readBlob(layout, indexLayer, "official index layer"),
    "official index layer is invalid",
  );
  if (
    published.format_version !== "1" ||
    published.repository !== OFFICIAL_REPOSITORY ||
    !Array.isArray(published.dialects)
  ) {
    throw new Error("official index identity is invalid");
  }
  const indexed = new Map<string, { digest: string; size: number }>();
  for (const value of published.dialects) {
    const item = object(value, "official index dialect is invalid");
    const artifact = object(item.artifact, "official index artifact is invalid");
    if (
      typeof item.name !== "string" ||
      typeof item.version !== "string" ||
      typeof artifact.manifest_digest !== "string" ||
      !DIGEST.test(artifact.manifest_digest) ||
      typeof artifact.manifest_size !== "number" ||
      !Number.isSafeInteger(artifact.manifest_size)
    ) {
      throw new Error("official index artifact is invalid");
    }
    const key = `${item.name}@${item.version}`;
    if (indexed.has(key)) throw new Error("official index contains duplicate dialects");
    indexed.set(key, { digest: artifact.manifest_digest, size: artifact.manifest_size });
  }
  if (indexed.size !== dialects.length) throw new Error("official index dialect inventory differs");
  for (const item of dialects) {
    const expected = indexed.get(`${item.name}@${item.version}`);
    if (
      !expected ||
      expected.digest !== item.descriptor.digest ||
      expected.size !== item.descriptor.size
    ) {
      throw new Error("official index references an unpublished dialect descriptor");
    }
  }
  dialects.sort((left, right) => left.tag.localeCompare(right.tag, "en"));
  return { dialects, index: indexEntry };
}

function layoutFiles(directory: string, prefix = ""): Array<{ digest: string; path: string }> {
  const files: Array<{ digest: string; path: string }> = [];
  for (const entry of readdirSync(directory, { withFileTypes: true }).sort((left, right) =>
    left.name.localeCompare(right.name, "en"),
  )) {
    const relative = prefix ? `${prefix}/${entry.name}` : entry.name;
    const path = join(directory, entry.name);
    if (entry.isDirectory()) files.push(...layoutFiles(path, relative));
    else if (entry.isFile() && !entry.isSymbolicLink()) {
      files.push({ digest: digest(readFileSync(path)), path: relative });
    } else throw new Error("OCI layout contains an irregular file");
  }
  return files;
}

function assertSameLayout(first: string, second: string): void {
  if (JSON.stringify(layoutFiles(first)) !== JSON.stringify(layoutFiles(second))) {
    throw new Error("dialect distribution changed after artifact publication");
  }
}

function graph(layout: string, tag: string): Array<{ digest: string; size: number }> {
  const root = rootDescriptors(layout).find((entry) => entry.tag === tag);
  if (!root) throw new Error("OCI graph tag is missing");
  const manifest = parseJSON(
    readBlob(layout, root.descriptor, "OCI graph manifest"),
    "OCI graph manifest is invalid",
  );
  const expectedType = manifest.artifactType;
  if (expectedType !== DIALECT_ARTIFACT_TYPE && expectedType !== INDEX_ARTIFACT_TYPE) {
    throw new Error("OCI graph artifact type is invalid");
  }
  return manifestGraph(layout, root.descriptor, expectedType)
    .map(({ digest: value, size }) => ({ digest: value, size }))
    .sort((left, right) => left.digest.localeCompare(right.digest, "en"));
}

function orasFlags(
  options: {
    caFile?: string;
    plainHTTP: boolean;
    registryConfig?: string;
  },
  direction?: "from" | "to",
): string[] {
  const prefix = direction ? `${direction}-` : "";
  const flags: string[] = [];
  if (options.registryConfig) flags.push(`--${prefix}registry-config`, options.registryConfig);
  if (options.caFile) flags.push(`--${prefix}ca-file`, options.caFile);
  if (options.plainHTTP) flags.push(`--${prefix}plain-http`);
  return flags;
}

export function orasTransportFlags(options: {
  caFile?: string;
  plainHTTP: boolean;
  registryConfig?: string;
}): {
  common: string[];
  from: string[];
  to: string[];
} {
  return {
    common: orasFlags(options),
    from: orasFlags(options, "from"),
    to: orasFlags(options, "to"),
  };
}

type CommandResult = { exitCode: number; stderr: string; stdout: string };

export class OrasRegistry implements PublicationRegistry {
  readonly #binary: string;
  readonly #flags: string[];
  readonly #fromFlags: string[];
  readonly #repository: string;
  readonly #toFlags: string[];

  constructor(options: {
    binary: string;
    caFile?: string;
    plainHTTP: boolean;
    registryConfig?: string;
    repository: string;
  }) {
    this.#binary = options.binary;
    const directional = orasTransportFlags(options);
    this.#flags = directional.common;
    this.#fromFlags = directional.from;
    this.#repository = options.repository;
    this.#toFlags = directional.to;
  }

  #run(arguments_: string[]): CommandResult {
    const result = Bun.spawnSync({
      cmd: [this.#binary, ...arguments_],
      env: process.env,
      stderr: "pipe",
      stdout: "pipe",
    });
    return {
      exitCode: result.exitCode,
      stderr: result.stderr.toString(),
      stdout: result.stdout.toString(),
    };
  }

  resolve(tag: string): string | undefined {
    const result = this.#run(["resolve", ...this.#flags, `${this.#repository}:${tag}`]);
    if (result.exitCode !== 0) {
      if (/(?:not found|manifest unknown|manifest_unknown|404)/iu.test(result.stderr))
        return undefined;
      throw new Error(`registry resolve failed for ${tag}`);
    }
    const value = result.stdout
      .split(/\r?\n/u)
      .map((line) => line.trim())
      .find((line) => DIGEST.test(line));
    if (!value) throw new Error(`registry resolve returned no digest for ${tag}`);
    return value;
  }

  push(layout: string, sourceTag: string, destinationTag: string): void {
    const result = this.#run([
      "cp",
      "--from-oci-layout",
      "--no-tty",
      ...this.#toFlags,
      `${layout}:${sourceTag}`,
      `${this.#repository}:${destinationTag}`,
    ]);
    if (result.exitCode !== 0) throw new Error(`registry push failed for ${destinationTag}`);
  }

  tag(value: string, tag: string): void {
    const result = this.#run(["tag", ...this.#flags, `${this.#repository}@${value}`, tag]);
    if (result.exitCode !== 0) throw new Error(`registry tag update failed for ${tag}`);
  }

  verify(layout: string, sourceTag: string, value: string): void {
    const pulled = mkdtempSync(join(tmpdir(), "rootform-dialect-pull-"));
    try {
      const result = this.#run([
        "cp",
        "--to-oci-layout",
        "--no-tty",
        ...this.#fromFlags,
        `${this.#repository}@${value}`,
        `${pulled}:verified`,
      ]);
      if (result.exitCode !== 0)
        throw new Error(`registry digest verification failed for ${sourceTag}`);
      if (JSON.stringify(graph(layout, sourceTag)) !== JSON.stringify(graph(pulled, "verified"))) {
        throw new Error(`registry graph differs for ${sourceTag}`);
      }
    } finally {
      rmSync(pulled, { force: true, recursive: true });
    }
  }
}

export function publishDistribution(options: {
  buildLayout: (destination: string) => void;
  registry: PublicationRegistry;
  repository: string;
  workingDirectory: string;
}): PublicationEvidence {
  const firstLayout = join(options.workingDirectory, "before-publication");
  const finalLayout = join(options.workingDirectory, "after-publication");
  options.buildLayout(firstLayout);
  const first = inspectLayout(firstLayout);

  const existing = new Map<string, string | undefined>();
  for (const dialect of first.dialects) {
    const current = options.registry.resolve(dialect.tag);
    if (current !== undefined && current !== dialect.descriptor.digest) {
      throw new Error(`immutable dialect tag already has different content: ${dialect.tag}`);
    }
    existing.set(dialect.tag, current);
  }
  for (const dialect of first.dialects) {
    if (existing.get(dialect.tag) === undefined) {
      options.registry.push(firstLayout, dialect.tag, dialect.tag);
    }
    if (options.registry.resolve(dialect.tag) !== dialect.descriptor.digest) {
      throw new Error(`published dialect tag did not resolve exactly: ${dialect.tag}`);
    }
    options.registry.verify(firstLayout, dialect.tag, dialect.descriptor.digest);
  }

  options.buildLayout(finalLayout);
  assertSameLayout(firstLayout, finalLayout);
  const final = inspectLayout(finalLayout);
  const immutableIndexTag = `index-${final.index.descriptor.digest.replace(":", "-")}`;
  const existingIndex = options.registry.resolve(immutableIndexTag);
  if (existingIndex !== undefined && existingIndex !== final.index.descriptor.digest) {
    throw new Error("immutable index tag already has different content");
  }
  if (existingIndex === undefined) {
    options.registry.push(finalLayout, INDEX_TAG, immutableIndexTag);
  }
  if (options.registry.resolve(immutableIndexTag) !== final.index.descriptor.digest) {
    throw new Error("published index tag did not resolve exactly");
  }
  options.registry.verify(finalLayout, INDEX_TAG, final.index.descriptor.digest);
  options.registry.tag(final.index.descriptor.digest, INDEX_TAG);
  if (options.registry.resolve(INDEX_TAG) !== final.index.descriptor.digest) {
    throw new Error("official index discovery tag did not move to verified digest");
  }

  return {
    artifacts: final.dialects.map((entry) => ({
      manifest_digest: entry.descriptor.digest,
      manifest_size: entry.descriptor.size,
      name: entry.name as string,
      tag: entry.tag,
      version: entry.version as string,
    })),
    format_version: "1",
    index: {
      discovery_tag: INDEX_TAG,
      immutable_tag: immutableIndexTag,
      manifest_digest: final.index.descriptor.digest,
      manifest_size: final.index.descriptor.size,
    },
    repository: options.repository,
  };
}

function takeValue(
  arguments_: string[],
  index: number,
  name: string,
): { next: number; value: string } {
  const argument = arguments_[index] ?? "";
  const inline = argument.startsWith(`--${name}=`)
    ? argument.slice(name.length + 3)
    : arguments_[index + 1];
  if (!inline || inline.startsWith("--")) throw new Error(`--${name} requires a value`);
  return { next: argument.startsWith(`--${name}=`) ? index : index + 1, value: inline };
}

function testRepository(value: string): boolean {
  const match = value.match(
    /^(localhost|127\.0\.0\.1|\[::1\]):([1-9][0-9]{0,4})\/rootform-dev\/dialects$/u,
  );
  return Boolean(match?.[2] && Number(match[2]) <= 65535);
}

export function parsePublishArguments(arguments_: string[], cwd = process.cwd()): PublishArguments {
  let caFile: string | undefined;
  let evidence: string | undefined;
  let plainHTTP = false;
  let registryConfig: string | undefined;
  let repository = OFFICIAL_REPOSITORY;
  let revision: string | undefined;
  let rootformVersion: string | undefined;
  let testOverride = false;
  const seen = new Set<string>();
  for (let index = 0; index < arguments_.length; index++) {
    const argument = arguments_[index] ?? "";
    if (argument === "--plain-http") {
      if (plainHTTP) throw new Error("duplicate publish argument: --plain-http");
      plainHTTP = true;
      continue;
    }
    const name = [
      "ca-file",
      "evidence",
      "registry-config",
      "revision",
      "rootform-version",
      "test-repository",
    ].find((candidate) => argument === `--${candidate}` || argument.startsWith(`--${candidate}=`));
    if (!name) throw new Error(`unknown publish argument: ${argument}`);
    if (seen.has(name)) {
      throw new Error(`duplicate publish argument: --${name}`);
    }
    seen.add(name);
    const supplied = takeValue(arguments_, index, name);
    index = supplied.next;
    if (name === "ca-file") caFile = resolve(cwd, supplied.value);
    if (name === "evidence") evidence = resolve(cwd, supplied.value);
    if (name === "registry-config") registryConfig = resolve(cwd, supplied.value);
    if (name === "revision") revision = supplied.value;
    if (name === "rootform-version") rootformVersion = supplied.value;
    if (name === "test-repository") {
      if (!testRepository(supplied.value))
        throw new Error("--test-repository must use a loopback registry");
      repository = supplied.value;
      testOverride = true;
    }
  }
  if (!evidence) throw new Error("--evidence requires a file");
  if (!rootformVersion) throw new Error("--rootform-version requires a value");
  if (!revision || !/^[0-9a-f]{40}$/u.test(revision)) {
    throw new Error("--revision requires one exact commit");
  }
  if ((plainHTTP || caFile) && !testOverride) {
    throw new Error("custom transport is allowed only with --test-repository");
  }
  if (plainHTTP && caFile) throw new Error("--plain-http and --ca-file cannot be combined");
  for (const [path, label] of [
    [caFile, "CA file"],
    [registryConfig, "registry config"],
  ] as const) {
    if (path !== undefined) readRegular(path, label, 1024 * 1024);
  }
  return {
    caFile,
    evidence,
    packageArguments: ["--rootform-version", rootformVersion, "--revision", revision],
    plainHTTP,
    registryConfig,
    repository,
  };
}

function writeEvidence(path: string, evidence: PublicationEvidence): void {
  if (!isAbsolute(path)) throw new Error("publication evidence path must be absolute");
  mkdirSync(dirname(path), { recursive: true });
  writeFileSync(path, `${JSON.stringify(evidence, null, 2)}\n`, { flag: "wx", mode: 0o644 });
}

function main(arguments_: string[]): void {
  const options = parsePublishArguments(arguments_);
  const configuredBinary = process.env.ROOTFORM_ORAS_BIN || "oras";
  const workspace = mkdtempSync(join(tmpdir(), "rootform-dialect-publication-"));
  try {
    const evidence = publishDistribution({
      buildLayout(destination) {
        packageDialects(["--to", destination, ...options.packageArguments]);
      },
      registry: new OrasRegistry({
        binary: configuredBinary,
        caFile: options.caFile,
        plainHTTP: options.plainHTTP,
        registryConfig: options.registryConfig,
        repository: options.repository,
      }),
      repository: options.repository,
      workingDirectory: workspace,
    });
    writeEvidence(options.evidence, evidence);
    console.log(
      `Published ${evidence.artifacts.length} dialects and ${INDEX_TAG}@${evidence.index.manifest_digest}.`,
    );
  } finally {
    rmSync(workspace, { force: true, recursive: true });
  }
}

if (import.meta.main) {
  try {
    main(process.argv.slice(2));
  } catch (error) {
    console.error(error instanceof Error ? error.message : String(error));
    process.exit(1);
  }
}
