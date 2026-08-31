import { expect, test } from "bun:test";
import { requireRootformVersion, resolveRootformVersion } from "./verify-version.ts";

test("uses the configured Rootform version by default", () => {
  expect(resolveRootformVersion([], "0.1.0-dev.2")).toBe("0.1.0-dev.2");
});

test("accepts an exact candidate Rootform version", () => {
  expect(resolveRootformVersion(["--rootform-version=0.1.0-pr.39.1"], "0.1.0-dev.2")).toBe(
    "0.1.0-pr.39.1",
  );
  expect(resolveRootformVersion(["--rootform-version", "0.1.0-dev.4"], "0.1.0-dev.2")).toBe(
    "0.1.0-dev.4",
  );
});

test("rejects malformed candidate version arguments", () => {
  expect(() => resolveRootformVersion(["--rootform-version"], "0.1.0-dev.2")).toThrow(
    "--rootform-version requires a value",
  );
  expect(() => resolveRootformVersion(["--rootform-version=latest"], "0.1.0-dev.2")).toThrow(
    "--rootform-version is invalid",
  );
  expect(() =>
    resolveRootformVersion(["--rootform-version=0.1.0", "--rootform-version=0.1.1"], "0.1.0-dev.2"),
  ).toThrow("duplicate verification argument: --rootform-version");
  expect(() => resolveRootformVersion(["--unknown"], "0.1.0-dev.2")).toThrow(
    "unknown verification argument: --unknown",
  );
});

test("accepts the exact configured Rootform version", () => {
  expect(() => requireRootformVersion("rootform 0.1.0-dev.2\n", "0.1.0-dev.2")).not.toThrow();
});

test("rejects another Rootform version", () => {
  expect(() => requireRootformVersion("rootform 0.1.0-dev.1\n", "0.1.0-dev.2")).toThrow(
    "Rootform version mismatch: expected rootform 0.1.0-dev.2, got rootform 0.1.0-dev.1",
  );
});

test("rejects missing version output", () => {
  expect(() => requireRootformVersion("\n", "0.1.0-dev.2")).toThrow(
    "Rootform version mismatch: expected rootform 0.1.0-dev.2, got no output",
  );
});
