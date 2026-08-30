#!/usr/bin/env bun

import { readdirSync, readFileSync } from "node:fs";
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
const evidenceNames = new Set([
  "core-abstractions.json",
  "coverage-matrix.json",
  "coverage-summary.json",
  "icon-license-spike.md",
  "provider-baseline.json",
  "provider-boundaries-spike.md",
  "provider-compatibility.json",
  "provider-source-inventory.json",
  "provider-surfaces-spike.md",
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

export function validateRepository(): void {
  const inventory = JSON.parse(readFileSync(join(root, "dialects.json"), "utf8")) as Inventory;
  if (inventory.format_version !== "1" || inventory.dialects.length === 0) {
    throw new Error("dialects.json must contain format version 1 and at least one dialect");
  }

  const expected = inventory.dialects.map(({ name }) => name);
  const actual = readdirSync(join(root, "dialects"), { withFileTypes: true })
    .filter((entry) => entry.isDirectory())
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
      path.startsWith("dialects/") &&
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
    }
  }

  for (const { name, version } of inventory.dialects) {
    const declaration = readFileSync(join(root, "dialects", name, "dialect.rf"), "utf8");
    const match = declaration.match(
      /^dialect\s+"([^"]+)"\s*\{[\s\S]*?^\s*version\s*=\s*"([^"]+)"/mu,
    );
    if (!match || match[1] !== name || match[2] !== version) {
      throw new Error(`dialect declaration does not match inventory: ${name}@${version}`);
    }
    JSON.parse(readFileSync(join(root, "dialects", name, "presentation.json"), "utf8"));
  }

  const workflowPaths = files.filter((path) => path.startsWith(".github/workflows/"));
  if (JSON.stringify(workflowPaths) !== JSON.stringify([".github/workflows/ci.yml"])) {
    throw new Error("workflow inventory must contain only .github/workflows/ci.yml");
  }
  const workflow = readFileSync(join(root, workflowPaths[0] ?? ""), "utf8");
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

if (import.meta.main) {
  try {
    validateRepository();
    console.log("Repository structure is valid.");
  } catch (error) {
    console.error(error instanceof Error ? error.message : String(error));
    process.exit(1);
  }
}
