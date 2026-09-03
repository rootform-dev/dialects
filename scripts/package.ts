#!/usr/bin/env bun

import { mkdtempSync, readFileSync, rmSync } from "node:fs";
import { tmpdir } from "node:os";
import { isAbsolute, join, resolve } from "node:path";
import { requireRootformVersion, resolveRootformVersion } from "./verify-version.ts";

const root = join(import.meta.dir, "..");
const SOURCE_URL = "https://github.com/rootform-dev/dialects";
const LICENSES = "MPL-2.0";

export type PackageArguments = {
  destination: string;
  revision?: string;
  versionArguments: string[];
};

export function parsePackageArguments(arguments_: string[]): PackageArguments {
  let destination: string | undefined;
  let revision: string | undefined;
  const versionArguments: string[] = [];
  for (let index = 0; index < arguments_.length; index++) {
    const argument = arguments_[index] ?? "";
    if (argument === "--to" || argument.startsWith("--to=")) {
      if (destination !== undefined) throw new Error("duplicate package argument: --to");
      const supplied = argument.startsWith("--to=")
        ? argument.slice("--to=".length)
        : arguments_[++index];
      if (!supplied || supplied.startsWith("--")) throw new Error("--to requires a directory");
      destination = supplied;
      continue;
    }
    if (argument === "--rootform-version" || argument.startsWith("--rootform-version=")) {
      versionArguments.push(argument);
      if (argument === "--rootform-version") {
        const supplied = arguments_[++index];
        if (!supplied || supplied.startsWith("--")) {
          throw new Error("--rootform-version requires a value");
        }
        versionArguments.push(supplied);
      }
      continue;
    }
    if (argument === "--revision" || argument.startsWith("--revision=")) {
      if (revision !== undefined) throw new Error("duplicate package argument: --revision");
      const supplied = argument.startsWith("--revision=")
        ? argument.slice("--revision=".length)
        : arguments_[++index];
      if (!supplied || supplied.startsWith("--")) {
        throw new Error("--revision requires one exact commit");
      }
      if (!/^[0-9a-f]{40}$/u.test(supplied)) {
        throw new Error("--revision requires one exact commit");
      }
      revision = supplied;
      continue;
    }
    throw new Error(`unknown package argument: ${argument}`);
  }
  if (!destination) throw new Error("--to requires a directory");
  return { destination, revision, versionArguments };
}

export function provenanceArguments(revision?: string): string[] {
  if (revision !== undefined && !/^[0-9a-f]{40}$/u.test(revision)) {
    throw new Error("provenance revision must be one exact commit");
  }
  return [
    "--source-url",
    SOURCE_URL,
    "--documentation-url",
    revision ? `${SOURCE_URL}/blob/${revision}/README.md` : `${SOURCE_URL}/blob/dev/README.md`,
    "--licenses",
    LICENSES,
    ...(revision ? ["--revision", revision] : []),
  ];
}

function run(command: string[], environment: Record<string, string>): string {
  const result = Bun.spawnSync({
    cmd: command,
    cwd: root,
    env: { ...process.env, ...environment },
    stderr: "pipe",
    stdout: "pipe",
  });
  process.stdout.write(result.stdout);
  process.stderr.write(result.stderr);
  if (result.exitCode !== 0) throw new Error(`Rootform exited ${result.exitCode}`);
  return result.stdout.toString();
}

export function packageDialects(arguments_: string[]): void {
  const options = parsePackageArguments(arguments_);
  const configuredBinary = process.env.ROOTFORM_BIN;
  if (!configuredBinary) {
    throw new Error("ROOTFORM_BIN must name the checksum-verified Rootform executable");
  }
  const binary = isAbsolute(configuredBinary) ? configuredBinary : resolve(root, configuredBinary);
  const toolchain = JSON.parse(readFileSync(join(root, "toolchain.json"), "utf8")) as {
    version: string;
  };
  const expectedVersion = resolveRootformVersion(options.versionArguments, toolchain.version);
  const isolatedHome = mkdtempSync(join(tmpdir(), "rootform-package-dialects-"));
  const environment = { ROOTFORM_HOME: isolatedHome };
  try {
    requireRootformVersion(run([binary, "version"], environment), expectedVersion);
    run(
      [
        binary,
        "package",
        "dialects",
        ".",
        "--to",
        resolve(root, options.destination),
        "--repository",
        "ghcr.io/rootform-dev/dialects",
        ...provenanceArguments(options.revision),
      ],
      environment,
    );
  } finally {
    rmSync(isolatedHome, { force: true, recursive: true });
  }
}

if (import.meta.main) {
  try {
    packageDialects(process.argv.slice(2));
  } catch (error) {
    console.error(error instanceof Error ? error.message : String(error));
    process.exit(1);
  }
}
