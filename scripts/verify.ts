#!/usr/bin/env bun

import { existsSync, mkdtempSync, readdirSync, readFileSync, rmSync } from "node:fs";
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

type BoundaryScenario = {
  expected_build_failure: true;
  expected_diagnostic_codes: string[];
  fixture: string;
  forbidden_output?: string[];
};

function boundaryScenarios(): BoundaryScenario[] {
  const scenarios: BoundaryScenario[] = [];
  for (const entry of readdirSync(join(root, "evidence"), { withFileTypes: true })) {
    if (!entry.isDirectory()) continue;
    const path = join(root, "evidence", entry.name, "scenarios.json");
    if (!existsSync(path)) continue;
    const document = JSON.parse(readFileSync(path, "utf8")) as {
      scenarios?: BoundaryScenario[];
    };
    for (const scenario of document.scenarios ?? []) {
      if (scenario.expected_build_failure === true) scenarios.push(scenario);
    }
  }
  return scenarios.sort((left, right) => left.fixture.localeCompare(right.fixture, "en"));
}

function buildBoundary(
  binary: string,
  scenario: BoundaryScenario,
  environment: Record<string, string>,
): string {
  if (!/^fixtures\/[a-z0-9-]+\/boundary$/u.test(scenario.fixture)) {
    throw new Error(`invalid boundary fixture path: ${scenario.fixture}`);
  }
  const fixture = join(root, scenario.fixture);
  if (!existsSync(fixture)) throw new Error(`boundary fixture is unavailable: ${scenario.fixture}`);
  const result = Bun.spawnSync({
    cmd: [binary, "build", fixture],
    cwd: root,
    env: { ...process.env, ...environment },
    stderr: "pipe",
    stdout: "pipe",
  });
  if (result.exitCode !== 3) {
    throw new Error(`${scenario.fixture} must exit 3 with delivered partial IR`);
  }

  const stdout = result.stdout.toString();
  const stderr = result.stderr.toString();
  const document = JSON.parse(stdout) as {
    architecture?: { representations?: unknown };
    diagnostics?: Array<{ code?: unknown }>;
    format_version?: unknown;
  };
  if (
    document.format_version !== "0.1.0" ||
    !Array.isArray(document.architecture?.representations) ||
    document.architecture.representations.length === 0 ||
    !Array.isArray(document.diagnostics)
  ) {
    throw new Error(`${scenario.fixture} did not deliver valid partial Architecture IR`);
  }
  const actual = document.diagnostics.map(({ code }) => code).sort();
  const expected = [...scenario.expected_diagnostic_codes].sort();
  if (JSON.stringify(actual) !== JSON.stringify(expected)) {
    throw new Error(`${scenario.fixture} diagnostic codes drifted: ${JSON.stringify(actual)}`);
  }
  for (const sentinel of scenario.forbidden_output ?? []) {
    if (stdout.includes(sentinel) || stderr.includes(sentinel)) {
      throw new Error(`${scenario.fixture} leaked forbidden output`);
    }
  }
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
  const first = run([binary, "test", "./fixtures", "--format", "json"], environment);
  const second = run([binary, "test", "./fixtures", "--format", "json"], environment);
  if (first !== second) throw new Error("fixture output changed between identical runs");
  const boundaries = boundaryScenarios();
  if (boundaries.length === 0) throw new Error("no boundary evidence is declared");
  for (const scenario of boundaries) {
    const firstBoundary = buildBoundary(binary, scenario, environment);
    const secondBoundary = buildBoundary(binary, scenario, environment);
    if (firstBoundary !== secondBoundary) {
      throw new Error(`${scenario.fixture} partial Architecture IR is nondeterministic`);
    }
  }
  console.log(`Verified ${boundaries.length} delivered partial-IR boundaries.`);
} finally {
  rmSync(isolatedHome, { force: true, recursive: true });
}

run(["git", "diff", "--check"]);
run(["gitleaks", "dir", "--no-banner", "--redact", "--config", ".gitleaks.toml", "."]);
run(["gitleaks", "git", "--no-banner", "--redact", "--config", ".gitleaks.toml", "."]);

console.log("Dialect verification passed.");
