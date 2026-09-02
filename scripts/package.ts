#!/usr/bin/env bun

import { mkdtempSync, readFileSync, rmSync } from "node:fs";
import { tmpdir } from "node:os";
import { isAbsolute, join, resolve } from "node:path";
import { requireRootformVersion, resolveRootformVersion } from "./verify-version.ts";

const root = join(import.meta.dir, "..");

export type PackageArguments = {
  destination: string;
  versionArguments: string[];
};

export function parsePackageArguments(arguments_: string[]): PackageArguments {
  let destination: string | undefined;
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
    throw new Error(`unknown package argument: ${argument}`);
  }
  if (!destination) throw new Error("--to requires a directory");
  return { destination, versionArguments };
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
