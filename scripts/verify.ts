#!/usr/bin/env bun

import { mkdtempSync, readdirSync, readFileSync, rmSync } from "node:fs";
import { tmpdir } from "node:os";
import { isAbsolute, join, resolve } from "node:path";
import { requireRootformVersion, resolveRootformVersion } from "./verify-version.ts";

const root = join(import.meta.dir, "..");

function run(command: string[], environment: Record<string, string> = {}): string {
  const result = Bun.spawnSync({
    cmd: command,
    cwd: root,
    env: { ...process.env, ...environment },
    stderr: "pipe",
    stdout: "pipe",
  });
  const stdout = result.stdout.toString();
  const stderr = result.stderr.toString();
  process.stdout.write(stdout);
  process.stderr.write(stderr);
  if (result.exitCode !== 0) throw new Error(`${command.join(" ")} exited ${result.exitCode}`);
  return stdout;
}

function snapshot(directory: string, prefix = ""): Record<string, string> {
  const files: Record<string, string> = {};
  for (const entry of readdirSync(directory, { withFileTypes: true }).sort((left, right) =>
    left.name.localeCompare(right.name, "en"),
  )) {
    const relative = prefix ? `${prefix}/${entry.name}` : entry.name;
    const path = join(directory, entry.name);
    if (entry.isDirectory()) Object.assign(files, snapshot(path, relative));
    else if (entry.isFile()) files[relative] = readFileSync(path).toString("base64");
    else throw new Error(`irregular distribution output: ${relative}`);
  }
  return files;
}

run(["bun", "run", "check"]);

const requiredTools = [
  { command: ["gitleaks", "version"], expected: "8.30.1", name: "gitleaks" },
  { command: ["actionlint", "-version"], expected: "1.7.12", name: "actionlint" },
];
for (const tool of requiredTools) {
  const version = run(tool.command).trim().split("\n", 1)[0] ?? "";
  if (version !== tool.expected) {
    throw new Error(`${tool.name} ${tool.expected} is required, got ${version || "unavailable"}`);
  }
}
run(["actionlint", "-no-color", "-oneline"]);

const configuredBinary = process.env.ROOTFORM_BIN;
if (!configuredBinary)
  throw new Error("ROOTFORM_BIN must name the checksum-verified Rootform executable");
const binary = isAbsolute(configuredBinary) ? configuredBinary : resolve(root, configuredBinary);
const isolatedHome = mkdtempSync(join(tmpdir(), "rootform-dialects-"));
const environment = { ROOTFORM_HOME: isolatedHome };
const toolchain = JSON.parse(readFileSync(join(root, "toolchain.json"), "utf8")) as {
  version: string;
};
const expectedVersion = resolveRootformVersion(process.argv.slice(2), toolchain.version);

try {
  requireRootformVersion(run([binary, "version"], environment), expectedVersion);
  run([binary, "fmt", "--check", "."], environment);
  run([binary, "validate", "dialects", "."], environment);
  run([binary, "install", "dialects", "."], environment);
  run([binary, "verify", "dialects", "."], environment);
  const firstLayout = join(isolatedHome, "distribution-first");
  const secondLayout = join(isolatedHome, "distribution-second");
  run(
    [
      binary,
      "package",
      "dialects",
      ".",
      "--to",
      firstLayout,
      "--repository",
      "ghcr.io/rootform-dev/dialects",
    ],
    environment,
  );
  run(
    [
      binary,
      "package",
      "dialects",
      ".",
      "--to",
      secondLayout,
      "--repository",
      "ghcr.io/rootform-dev/dialects",
    ],
    environment,
  );
  const firstDistribution = snapshot(firstLayout);
  const secondDistribution = snapshot(secondLayout);
  if (JSON.stringify(firstDistribution) !== JSON.stringify(secondDistribution)) {
    throw new Error("official dialect distribution changed between identical builds");
  }
  if (
    !("index.json" in firstDistribution) ||
    !("oci-layout" in firstDistribution) ||
    !Object.keys(firstDistribution).some((path) => path.startsWith("blobs/sha256/"))
  ) {
    throw new Error("official dialect distribution is incomplete");
  }
  const first = run([binary, "test", "./fixtures", "--format", "json"], environment);
  const second = run([binary, "test", "./fixtures", "--format", "json"], environment);
  if (first !== second) throw new Error("fixture output changed between identical runs");
} finally {
  rmSync(isolatedHome, { force: true, recursive: true });
}

run(["git", "diff", "--check"]);
run(["gitleaks", "dir", "--no-banner", "--redact", "--config", ".gitleaks.toml", "."]);
run(["gitleaks", "git", "--no-banner", "--redact", "--config", ".gitleaks.toml", "."]);

console.log("Dialect verification passed.");
