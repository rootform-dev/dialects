#!/usr/bin/env bun

import { mkdtempSync, readFileSync, rmSync } from "node:fs";
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
