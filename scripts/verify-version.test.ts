import { expect, test } from "bun:test";
import { requireRootformVersion } from "./verify-version.ts";

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
