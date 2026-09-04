import { expect, test } from "bun:test";
import {
  hasPrivateImplementationReference,
  validateDialectLock,
  validateRepository,
} from "./validate-repository.ts";

test("current repository matches its explicit inventory", () => {
  expect(validateRepository).not.toThrow();
});

test("public evidence rejects private implementation references", () => {
  for (const privateReference of [
    `spe${"cs/062-aws/evidence.json"}`,
    `docs/ad${"r/086-provider.md"}`,
    `testdata/arch${"itecture/aws-v6/minimal"}`,
    `packages/rend${"erer/src/private.ts"}`,
    `web/s${"rc/private.ts"}`,
    `AD${"R-086"}`,
    `SPE${"C-062"}`,
    `accepted_${"adr"}`,
  ]) {
    expect(hasPrivateImplementationReference(privateReference)).toBeTrue();
  }
  expect(
    hasPrivateImplementationReference(
      "Rootform CLI owns parsing; evidence/aws/provider-surfaces-spike.md is public.",
    ),
  ).toBeFalse();
});

test("authoring lock requires format 1, empty non-coverage, and exact dialect identities", () => {
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
    "rootform.lock must use format 1 with an empty unsupported provider set",
  );
  expect(() =>
    validateDialectLock(
      { ...lock, unsupported_providers: ["example.invalid/no/dialect"] },
      inventory,
    ),
  ).toThrow("rootform.lock must use format 1 with an empty unsupported provider set");
  expect(() =>
    validateDialectLock({ ...lock, entries: lock.entries.slice(0, 1) }, inventory),
  ).toThrow("rootform.lock dialect identities do not match dialects.json");
});
