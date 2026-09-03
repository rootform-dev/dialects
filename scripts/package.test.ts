import { expect, test } from "bun:test";
import { parsePackageArguments, provenanceArguments } from "./package.ts";

test("requires one destination and preserves exact candidate version", () => {
  const revision = "a".repeat(40);
  expect(
    parsePackageArguments([
      "--to",
      "artifacts/oci",
      "--rootform-version=0.1.0-pr.81.1",
      `--revision=${revision}`,
    ]),
  ).toEqual({
    destination: "artifacts/oci",
    revision,
    versionArguments: ["--rootform-version=0.1.0-pr.81.1"],
  });
});

test("derives deterministic public provenance only from explicit inputs", () => {
  const revision = "b".repeat(40);
  expect(provenanceArguments(revision)).toEqual([
    "--source-url",
    "https://github.com/rootform-dev/dialects",
    "--documentation-url",
    `https://github.com/rootform-dev/dialects/blob/${revision}/README.md`,
    "--licenses",
    "MPL-2.0",
    "--revision",
    revision,
  ]);
  expect(provenanceArguments()).not.toContain("--revision");
  expect(() => provenanceArguments("/private/checkout")).toThrow("exact commit");
});

test("rejects missing, duplicate, and unknown package arguments", () => {
  expect(() => parsePackageArguments([])).toThrow("--to requires a directory");
  expect(() => parsePackageArguments(["--to"])).toThrow("--to requires a directory");
  expect(() => parsePackageArguments(["--to=a", "--to=b"])).toThrow("duplicate");
  expect(() => parsePackageArguments(["--to=a", "--repository=x"])).toThrow("unknown");
  expect(() => parsePackageArguments(["--to=a", "--revision=dev"])).toThrow("exact commit");
  expect(() =>
    parsePackageArguments([
      "--to=a",
      `--revision=${"a".repeat(40)}`,
      `--revision=${"b".repeat(40)}`,
    ]),
  ).toThrow("duplicate");
});
