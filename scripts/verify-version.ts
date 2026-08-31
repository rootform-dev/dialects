export function requireRootformVersion(output: string, expectedVersion: string): void {
  const actual = output.trim();
  const expected = `rootform ${expectedVersion}`;
  if (actual !== expected) {
    throw new Error(
      `Rootform version mismatch: expected ${expected}, got ${actual || "no output"}`,
    );
  }
}
