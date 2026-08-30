import { expect, test } from "bun:test";
import { validateRepository } from "./validate-repository.ts";

test("current repository matches its explicit inventory", () => {
  expect(validateRepository).not.toThrow();
});
