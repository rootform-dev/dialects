#!/usr/bin/env bun

import { createHash } from "node:crypto";
import { readFileSync } from "node:fs";
import { resolve } from "node:path";

const configuredBinary = process.env.ROOTFORM_BIN;
if (!configuredBinary) throw new Error("ROOTFORM_BIN must name the verified Rootform executable");
const binary = resolve(configuredBinary);

function run(args: string[]): string {
  const result = Bun.spawnSync([binary, ...args], { stdout: "pipe", stderr: "pipe" });
  if (result.exitCode !== 0) throw new Error(result.stderr.toString());
  return result.stdout.toString();
}

function definitions(kind: string): unknown[] {
  const entries = JSON.parse(
    run(["list", `${kind}s`, "--dialect", "core", "--format", "json"]),
  ) as {
    id: string;
  }[];
  return entries.map(({ id }) => JSON.parse(run(["show", kind, id, "--format", "json"])));
}

console.log(
  JSON.stringify(
    {
      format_version: "1",
      generator: {
        identity: run(["version"]).trim(),
        binary_sha256: `sha256:${createHash("sha256").update(readFileSync(binary)).digest("hex")}`,
        command: "bun scripts/catalog.ts",
      },
      concepts: definitions("concept"),
      contexts: definitions("context"),
      relations: definitions("relation"),
    },
    null,
    2,
  ),
);
