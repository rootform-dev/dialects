import { expect, test } from "bun:test";
import { parsePackageArguments } from "./package.ts";

test("requires one destination and preserves exact candidate version", () => {
  expect(
    parsePackageArguments(["--to", "artifacts/oci", "--rootform-version=0.1.0-pr.81.1"]),
  ).toEqual({
    destination: "artifacts/oci",
    versionArguments: ["--rootform-version=0.1.0-pr.81.1"],
  });
});

test("rejects missing, duplicate, and unknown package arguments", () => {
  expect(() => parsePackageArguments([])).toThrow("--to requires a directory");
  expect(() => parsePackageArguments(["--to"])).toThrow("--to requires a directory");
  expect(() => parsePackageArguments(["--to=a", "--to=b"])).toThrow("duplicate");
  expect(() => parsePackageArguments(["--to=a", "--repository=x"])).toThrow("unknown");
});
