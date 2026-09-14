#!/usr/bin/env bun

import { mkdtempSync, readdirSync, rmSync, writeFileSync } from "node:fs";
import { tmpdir } from "node:os";
import { dirname, isAbsolute, join, relative, resolve } from "node:path";

const root = join(import.meta.dir, "..");
const configuredBinary = process.env.ROOTFORM_BIN;
if (!configuredBinary) throw new Error("ROOTFORM_BIN must name a Rootform executable");
const binary = isAbsolute(configuredBinary) ? configuredBinary : resolve(root, configuredBinary);

function discoverGoldens(directory: string): string[] {
  const found: string[] = [];
  for (const entry of readdirSync(directory, { withFileTypes: true })) {
    const path = join(directory, entry.name);
    if (entry.isDirectory()) found.push(...discoverGoldens(path));
    else if (entry.name === "architecture.golden") found.push(path);
  }
  return found.sort();
}

type Generated = {
  path: string;
  content: string;
};

const home = mkdtempSync(join(tmpdir(), "rootform-dialect-goldens-"));
const generated: Generated[] = [];
let complete = 0;
let partial = 0;

try {
  for (const golden of discoverGoldens(join(root, "fixtures"))) {
    const fixture = dirname(golden);
    const result = Bun.spawnSync({
      cmd: [binary, "build", fixture],
      cwd: root,
      env: {
        ...process.env,
        ROOTFORM_HOME: home,
        ROOTFORM_DIALECTS_SOURCE: root,
      },
      stderr: "pipe",
      stdout: "pipe",
    });
    if (result.exitCode !== 0 && result.exitCode !== 3) {
      process.stderr.write(result.stderr);
      throw new Error(`rootform build ${relative(root, fixture)} exited ${result.exitCode}`);
    }

    const content = result.stdout.toString();
    const document = JSON.parse(content) as {
      format_version?: unknown;
      architecture?: { representations?: unknown };
      diagnostics?: unknown;
    };
    if (
      document.format_version !== "0.1.0" ||
      !Array.isArray(document.architecture?.representations)
    ) {
      throw new Error(`${relative(root, fixture)} produced invalid Architecture IR`);
    }
    if (result.exitCode === 3) {
      if (!Array.isArray(document.diagnostics) || document.diagnostics.length === 0) {
        throw new Error(`${relative(root, fixture)} produced unexplained partial IR`);
      }
      partial++;
    } else {
      complete++;
    }
    generated.push({ path: golden, content: content.endsWith("\n") ? content : `${content}\n` });
  }

  for (const entry of generated) writeFileSync(entry.path, entry.content);
} finally {
  rmSync(home, { force: true, recursive: true });
}

console.log(
  `Updated ${generated.length} Architecture IR goldens (${complete} complete, ${partial} partial).`,
);
