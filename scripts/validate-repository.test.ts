import { expect, test } from "bun:test";
import { validateDialectLock, validateRepository } from "./validate-repository.ts";

test("current repository matches its explicit inventory", () => {
  expect(validateRepository).not.toThrow();
});

test("authoring lock stays on development format 1 and exact dialect identities", () => {
  const inventory = {
    format_version: "1",
    dialects: [
      { name: "core", version: "0.1.0" },
      { name: "google", version: "0.1.0" },
    ],
  };
  const lock = {
    format_version: "1",
    unsupported_providers: [],
    entries: [
      { name: "core", version: "0.1.0" },
      { name: "google", version: "0.1.0" },
    ],
  };
  expect(() => validateDialectLock(lock, inventory)).not.toThrow();
  expect(() => validateDialectLock({ ...lock, format_version: "2" }, inventory)).toThrow(
    "rootform.lock must use development format 1",
  );
  expect(() =>
    validateDialectLock(
      { ...lock, unsupported_providers: ["example.invalid/no/dialect"] },
      inventory,
    ),
  ).toThrow("rootform.lock must use development format 1");
  expect(() =>
    validateDialectLock({ ...lock, entries: lock.entries.slice(0, 1) }, inventory),
  ).toThrow("rootform.lock dialect identities do not match dialects.json");
});
