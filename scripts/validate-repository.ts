#!/usr/bin/env bun

import { existsSync, readdirSync, readFileSync } from "node:fs";
import { join, relative } from "node:path";

type Inventory = {
  format_version: string;
  dialects: Array<{ name: string; version: string }>;
};

type Toolchain = {
  format_version: string;
  repository: string;
  tag: string;
  version: string;
};

const root = join(import.meta.dir, "..");
const forbiddenPath = /(?:^|\/)(?:\.ai-private|docs\/internal|prd\.md|node_modules)(?:\/|$)/u;
const forbiddenText =
  /(?:\/Users\/|\/home\/[A-Za-z0-9._-]+\/|[A-Za-z]:\\Users\\|BEGIN (?:RSA|OPENSSH|EC|DSA) PRIVATE KEY|github_pat_|ghp_)/u;
const privateImplementationReference =
  /(?:^|[/ "'`])(?:specs\/[0-9]{3}-|testdata\/architecture\/|docs\/adr\/[0-9]{3}-|packages\/renderer\/|web\/src\/)|\b(?:SPEC|ADR)-[0-9]{3}\b|\baccepted_adr\b/u;
const qualifiedRuleReference =
  /(?<![A-Za-z0-9_.-])([a-z][a-z0-9]*(?:-[a-z0-9]+)*[.]rule[.][a-z][a-z0-9]*(?:-[a-z0-9]+)*)(?![A-Za-z0-9_.-])/gu;
// prior_rule_id records the pre-migration identity of an audited Rule. Audits
// with disposition removed or corrected intentionally reference ids that no
// longer exist; the field is provenance, not a live semantic reference.
const evidenceNames = new Set([
  "coverage-matrix.json",
  "coverage-summary.json",
  "icon-license-spike.md",
  "provider-baseline.json",
  "provider-boundaries-spike.md",
  "provider-compatibility.json",
  "provider-source-inventory.json",
  "provider-surfaces-spike.md",
  "rf-vocabulary-bindings.json",
  "rule-audit.json",
  "scenarios.json",
  "semantic-catalog.json",
  "service-catalog.json",
  "terminology.json",
]);

export function filesBelow(directory: string): string[] {
  const files: string[] = [];
  for (const entry of readdirSync(directory, { withFileTypes: true }).sort((a, b) =>
    a.name.localeCompare(b.name, "en"),
  )) {
    if ([".git", "artifacts", "build", "node_modules"].includes(entry.name)) continue;
    const path = join(directory, entry.name);
    const name = relative(root, path).replaceAll("\\", "/");
    if (entry.isSymbolicLink()) throw new Error(`symbolic link is forbidden: ${name}`);
    if (entry.isDirectory()) files.push(...filesBelow(path));
    else if (entry.isFile()) files.push(name);
    else throw new Error(`irregular filesystem entry is forbidden: ${name}`);
  }
  return files;
}

function isRecord(value: unknown): value is Record<string, unknown> {
  return value !== null && typeof value === "object" && !Array.isArray(value);
}

export function hasPrivateImplementationReference(body: string): boolean {
  return privateImplementationReference.test(body);
}

function validatePublicEvidenceReferences(value: unknown, source: string): void {
  if (typeof value === "string") {
    if (!value.startsWith("evidence/") && !value.startsWith("fixtures/")) return;
    const target = value.split("#", 1)[0] ?? "";
    if (!target || !existsSync(join(root, target))) {
      throw new Error(`public evidence reference is missing: ${source}: ${value}`);
    }
    return;
  }
  if (Array.isArray(value)) {
    for (const entry of value) validatePublicEvidenceReferences(entry, source);
    return;
  }
  if (isRecord(value)) {
    for (const entry of Object.values(value)) validatePublicEvidenceReferences(entry, source);
  }
}

export function validateLock(value: unknown): void {
  if (!isRecord(value)) throw new Error("rootform.lock must be an object");
  const expectedKeys = [
    "dialects",
    "excluded_owners",
    "format_version",
    "policy_packs",
    "replacements",
  ];
  if (Object.keys(value).sort().join("\n") !== expectedKeys.join("\n")) {
    throw new Error("rootform.lock must contain only project selection fields");
  }
  const lock = value as Record<string, unknown>;
  if (lock.format_version !== "1") {
    throw new Error("rootform.lock must use format version 1");
  }
  for (const field of ["dialects", "policy_packs", "excluded_owners", "replacements"]) {
    if (!Array.isArray(lock[field]) || lock[field].length !== 0) {
      throw new Error(`rootform.lock ${field} must be an empty selection`);
    }
  }
}

type RfBlock = { kind: "concept" | "rule"; name: string; text: string };

// MirrorPairCandidate is a resource rule that only reclassifies its own type
// into a local concept: static match, no where, no emission, and a concept used
// nowhere else in the dialect. The corpus prunes these pairs; the repository
// gate rejects any reappearance.
export type MirrorPairCandidate = {
  dialect: string;
  rule: string;
  type: string | null;
  file: string;
};

function parseRfBlocks(text: string): RfBlock[] {
  const blocks: RfBlock[] = [];
  const lines = text.split("\n");
  for (let index = 0; index < lines.length; ) {
    const line = lines[index] ?? "";
    const match = /^(concept|rule)\s+"([^"]+)"\s*\{/u.exec(line);
    if (match === null) {
      index += 1;
      continue;
    }
    const kind = match[1] as "concept" | "rule";
    const name = match[2] ?? "";
    let depth = 0;
    let end = index;
    for (; end < lines.length; end += 1) {
      const stripped = (lines[end] ?? "").replace(/"[^"]*"/gu, '""');
      depth += (stripped.match(/\{/gu) ?? []).length - (stripped.match(/\}/gu) ?? []).length;
      if (depth <= 0) {
        end += 1;
        break;
      }
    }
    blocks.push({ kind, name, text: lines.slice(index, end).join("\n") });
    index = end;
  }
  return blocks;
}

function mirrorRuleInfo(text: string): {
  type: string | null;
  data: boolean;
  emissions: boolean;
  where: boolean;
  asLocal: string | null;
  asRf: string | null;
  matchExtra: string[];
} {
  const info = {
    type: null as string | null,
    data: false,
    emissions: false,
    where: false,
    asLocal: null as string | null,
    asRf: null as string | null,
    matchExtra: [] as string[],
  };
  const matchHead = /\bmatch\s*\{/u.exec(text);
  if (matchHead !== null) {
    const start = (matchHead.index ?? 0) + matchHead[0].length;
    let depth = 1;
    let cursor = start;
    for (; cursor < text.length && depth > 0; cursor += 1) {
      if (text[cursor] === "{") depth += 1;
      else if (text[cursor] === "}") depth -= 1;
    }
    const matchBody = text.slice(start, cursor - 1);
    const typeMatch = /type\s*=\s*"([^"]+)"/u.exec(matchBody);
    if (typeMatch !== null) info.type = typeMatch[1] ?? null;
    if (/kind\s*=\s*"data"/u.test(matchBody)) info.data = true;
    info.matchExtra = [...matchBody.matchAll(/^\s*([a-z_]+)\s*=/gmu)]
      .map((entry) => entry[1] ?? "")
      .filter((field) => field !== "type" && field !== "kind");
  }
  const localAs = /^\s*as\s*=\s*concept\.([\w-]+)\s*$/mu.exec(text);
  const sharedAs = /^\s*as\s*=\s*rf\.concept\.([\w-]+)\s*$/mu.exec(text);
  if (localAs !== null) info.asLocal = localAs[1] ?? null;
  if (sharedAs !== null) info.asRf = sharedAs[1] ?? null;
  info.emissions = /^\s*(?:composition|context|relation|contribution|emission)\b/gmu.test(text);
  info.where = /\bwhere\b/u.test(text);
  return info;
}

export function declaredRuleIds(inventory: Inventory): Set<string> {
  const ids = new Set<string>();
  for (const { name } of inventory.dialects) {
    for (const path of filesBelow(name).filter((candidate) => candidate.endsWith(".rf"))) {
      const body = readFileSync(join(root, path), "utf8");
      for (const match of body.matchAll(/^rule\s+"([^"]+)"/gmu)) {
        ids.add(`${name}.rule.${match[1] ?? ""}`);
      }
    }
  }
  return ids;
}

export type UndeclaredRuleReference = { file: string; path: string; ref: string };

// Collect every qualified owner.rule.name string under documentary schemas
// that is not declared in the official dialect sources. Values of documentary
// provenance keys (prior_rule_id) are audit history and are skipped.
export function collectUndeclaredRuleReferences(
  value: unknown,
  file: string,
  jsonPath: string,
  declared: ReadonlySet<string>,
  out: UndeclaredRuleReference[],
): void {
  if (typeof value === "string") {
    for (const match of value.matchAll(qualifiedRuleReference)) {
      const ref = match[1] ?? "";
      if (!declared.has(ref)) out.push({ file, path: jsonPath, ref });
    }
    return;
  }
  if (Array.isArray(value)) {
    for (const [index, entry] of value.entries()) {
      collectUndeclaredRuleReferences(entry, file, `${jsonPath}[${index}]`, declared, out);
    }
    return;
  }
  if (isRecord(value)) {
    for (const [key, entry] of Object.entries(value)) {
      if (
        key === "prior_rule_id" &&
        (value.disposition === "removed" || value.disposition === "corrected")
      ) {
        continue;
      }
      const childPath = jsonPath === "$" ? `$.${key}` : `${jsonPath}.${key}`;
      collectUndeclaredRuleReferences(entry, file, childPath, declared, out);
    }
  }
}

export function undeclaredRuleReferences(inventory: Inventory): UndeclaredRuleReference[] {
  const declared = declaredRuleIds(inventory);
  const out: UndeclaredRuleReference[] = [];
  for (const path of filesBelow(root)) {
    if (!path.startsWith("evidence/")) continue;
    const body = readFileSync(join(root, path), "utf8");
    if (path.endsWith(".json")) {
      collectUndeclaredRuleReferences(JSON.parse(body) as unknown, path, "$", declared, out);
    } else {
      const lines = body.split("\n");
      for (const [index, line] of lines.entries()) {
        for (const match of line.matchAll(qualifiedRuleReference)) {
          const ref = match[1] ?? "";
          if (!declared.has(ref)) out.push({ file: path, path: `line ${index + 1}`, ref });
        }
      }
    }
  }
  return out;
}

function conceptReferenceCount(contents: string[], concept: string): number {
  const escaped = concept.replace(/[\\^$.*+?()[\]{}|]/gu, "\\$&");
  const pattern = new RegExp(`(?<![A-Za-z0-9-]\\.)concept\\.${escaped}\\b`, "gu");
  let count = 0;
  for (const content of contents) {
    count += (content.match(pattern) ?? []).length;
  }
  return count;
}

export function mirrorPairCandidates(): MirrorPairCandidate[] {
  const inventory = JSON.parse(readFileSync(join(root, "dialects.json"), "utf8")) as Inventory;
  const candidates: MirrorPairCandidate[] = [];
  for (const { name: dialect } of inventory.dialects) {
    const rfPaths = filesBelow(dialect).filter((path) => path.endsWith(".rf"));
    const contents = rfPaths.map((path) => ({
      path,
      text: readFileSync(join(root, path), "utf8"),
    }));
    const blocks = contents.flatMap((file) =>
      parseRfBlocks(file.text).map((block) => ({ ...block, file: file.path })),
    );
    const conceptNames = [
      ...new Set(blocks.filter((b) => b.kind === "concept").map((b) => b.name)),
    ];
    const allText = contents.map((file) => file.text);
    const referenceCount = new Map(
      conceptNames.map((name) => [name, conceptReferenceCount(allText, name)]),
    );
    for (const block of blocks.filter((b) => b.kind === "rule")) {
      const info = mirrorRuleInfo(block.text);
      if (info.data || info.where || info.emissions) continue;
      if (info.type === null || info.matchExtra.length > 0) continue;
      if (info.asRf !== null || info.asLocal === null) continue;
      if (referenceCount.get(info.asLocal) !== 1) continue;
      candidates.push({ dialect, rule: block.name, type: info.type, file: block.file });
    }
  }
  return candidates;
}

export function validatePresentationManifests(): void {
  const inventory = JSON.parse(readFileSync(join(root, "dialects.json"), "utf8")) as Inventory;
  for (const { name } of inventory.dialects) {
    const value = JSON.parse(readFileSync(join(root, name, "presentation.json"), "utf8")) as Record<
      string,
      unknown
    >;
    const resources = value.resources;
    const labels = value.resource_labels;
    if (resources === undefined && labels === undefined) continue;
    if (!isRecord(resources) || !isRecord(labels)) {
      throw new Error(`presentation manifests must pair resources with resource_labels: ${name}`);
    }
    const resourceKeys = Object.keys(resources);
    const labelKeys = Object.keys(labels).sort();
    if (JSON.stringify(labelKeys) !== JSON.stringify([...resourceKeys].sort())) {
      throw new Error(`presentation resources and resource_labels must share keys: ${name}`);
    }
    for (const key of resourceKeys) {
      if (!key.startsWith("resource/")) {
        throw new Error(`presentation resource key must start with resource/: ${name}: ${key}`);
      }
      if (typeof resources[key] !== "string" || typeof labels[key] !== "string") {
        throw new Error(`presentation resource entries must be strings: ${name}: ${key}`);
      }
    }
  }
}

export function validateRepository(): void {
  const inventory = JSON.parse(readFileSync(join(root, "dialects.json"), "utf8")) as Inventory;
  if (inventory.format_version !== "1" || inventory.dialects.length === 0) {
    throw new Error("dialects.json must contain format version 1 and at least one dialect");
  }
  validateLock(JSON.parse(readFileSync(join(root, "rootform.lock"), "utf8")));

  const expected = inventory.dialects.map(({ name }) => name);
  const allowedTopLevel = new Set([
    ...expected,
    ".gitattributes",
    ".github",
    ".gitignore",
    ".gitleaks.toml",
    "AGENTS.md",
    "CONTRIBUTING.md",
    "LICENSE",
    "README.md",
    "SECURITY.md",
    "THIRD_PARTY_NOTICES.md",
    "biome.json",
    "bun.lock",
    "dialects.json",
    "evidence",
    "fixtures",
    "package.json",
    "rootform.lock",
    "scripts",
    "toolchain.json",
    "tsconfig.json",
  ]);
  for (const entry of readdirSync(root, { withFileTypes: true })) {
    if ([".git", "artifacts", "build", "node_modules"].includes(entry.name)) continue;
    if (!allowedTopLevel.has(entry.name))
      throw new Error(`unexpected top-level path: ${entry.name}`);
  }
  const actual = readdirSync(root, { withFileTypes: true })
    .filter((entry) => entry.isDirectory() && expected.includes(entry.name))
    .map(({ name }) => name)
    .sort((a, b) => a.localeCompare(b, "en"));
  if (JSON.stringify(actual) !== JSON.stringify(expected)) {
    throw new Error(
      `dialect inventory mismatch: expected ${expected.join(", ")}; got ${actual.join(", ")}`,
    );
  }

  const toolchain = JSON.parse(readFileSync(join(root, "toolchain.json"), "utf8")) as Toolchain;
  if (
    toolchain.format_version !== "1" ||
    toolchain.repository !== "rootform-dev/rootform" ||
    toolchain.tag !== `v${toolchain.version}` ||
    !/^(?:0|[1-9][0-9]*)\.(?:0|[1-9][0-9]*)\.(?:0|[1-9][0-9]*)(?:-[0-9A-Za-z.-]+)?$/u.test(
      toolchain.version,
    )
  ) {
    throw new Error("toolchain.json must pin one exact Rootform release");
  }

  const files = filesBelow(root);
  for (const path of files) {
    if (forbiddenPath.test(path)) throw new Error(`private path is forbidden: ${path}`);
    if (
      expected.includes(path.split("/", 1)[0] ?? "") &&
      !path.endsWith(".rf") &&
      !path.endsWith("/presentation.json")
    ) {
      throw new Error(`unexpected dialect file: ${path}`);
    }
    if (path.startsWith("evidence/") && !evidenceNames.has(path.split("/").at(-1) ?? "")) {
      throw new Error(`unexpected evidence file: ${path}`);
    }
    if (
      path !== "scripts/validate-repository.ts" &&
      /\.(?:json|md|rf|tf|ts|yml|yaml)$/u.test(path)
    ) {
      const body = readFileSync(join(root, path), "utf8");
      if (forbiddenText.test(body))
        throw new Error(`private or secret-shaped text is forbidden: ${path}`);
      if (hasPrivateImplementationReference(body)) {
        throw new Error(`private implementation reference is forbidden: ${path}`);
      }
      if (path.startsWith("evidence/") && path.endsWith(".json")) {
        validatePublicEvidenceReferences(JSON.parse(body) as unknown, path);
      }
    }
  }

  for (const { name, version } of inventory.dialects) {
    const declaration = readFileSync(join(root, name, "dialect.rf"), "utf8");
    const match = declaration.match(
      /^dialect\s+"([^"]+)"\s*\{[\s\S]*?^\s*version\s*=\s*"([^"]+)"/mu,
    );
    if (!match || match[1] !== name || match[2] !== version) {
      throw new Error(`dialect declaration does not match inventory: ${name}@${version}`);
    }
    JSON.parse(readFileSync(join(root, name, "presentation.json"), "utf8"));
  }

  const mirrors = mirrorPairCandidates();
  if (mirrors.length > 0) {
    const sample = mirrors
      .slice(0, 5)
      .map((candidate) => `${candidate.dialect}/${candidate.rule} (${candidate.type})`)
      .join(", ");
    throw new Error(`${mirrors.length} redundant resource-mirror pair(s) remain: ${sample}`);
  }
  validatePresentationManifests();

  const danglingRules = undeclaredRuleReferences(inventory);
  if (danglingRules.length > 0) {
    const sample = danglingRules
      .slice(0, 5)
      .map((hit) => `${hit.file}: ${hit.path} = ${hit.ref}`)
      .join("; ");
    throw new Error(`${danglingRules.length} undeclared rule reference(s) in evidence: ${sample}`);
  }

  const workflowPaths = files.filter((path) => path.startsWith(".github/workflows/"));
  if (JSON.stringify(workflowPaths) !== JSON.stringify([".github/workflows/ci.yml"])) {
    throw new Error("workflow inventory must contain only the source validation workflow");
  }
  for (const path of workflowPaths) {
    const workflow = readFileSync(join(root, path), "utf8");
    for (const match of workflow.matchAll(/^\s*-?\s*uses:\s*([^\s#]+)/gmu)) {
      const reference = match[1] ?? "";
      if (!/@[0-9a-f]{40}$/u.test(reference)) {
        throw new Error(`GitHub Action is not SHA-pinned: ${reference}`);
      }
    }
    if (/pull_request_target\s*:|permissions:\s*write-all/u.test(workflow)) {
      throw new Error("workflow uses a forbidden privilege surface");
    }
  }
}

if (import.meta.main) {
  try {
    validateRepository();
    console.log("Repository structure is valid.");
  } catch (error) {
    console.error(error instanceof Error ? error.message : String(error));
    process.exit(1);
  }
}
