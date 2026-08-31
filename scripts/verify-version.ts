const ROOTFORM_VERSION =
  /^(?:0|[1-9][0-9]*)\.(?:0|[1-9][0-9]*)\.(?:0|[1-9][0-9]*)(?:-[0-9A-Za-z]+(?:[.-][0-9A-Za-z]+)*)?$/u;

function version(value: string, label: string): string {
  if (!ROOTFORM_VERSION.test(value)) throw new Error(`${label} is invalid`);
  return value;
}

export function resolveRootformVersion(arguments_: string[], configuredVersion: string): string {
  let suppliedVersion: string | undefined;
  for (let index = 0; index < arguments_.length; index++) {
    const argument = arguments_[index] ?? "";
    if (argument !== "--rootform-version" && !argument.startsWith("--rootform-version=")) {
      throw new Error(`unknown verification argument: ${argument}`);
    }
    if (suppliedVersion !== undefined) {
      throw new Error("duplicate verification argument: --rootform-version");
    }
    const supplied = argument.startsWith("--rootform-version=")
      ? argument.slice("--rootform-version=".length)
      : arguments_[++index];
    if (!supplied || supplied.startsWith("--")) {
      throw new Error("--rootform-version requires a value");
    }
    suppliedVersion = version(supplied, "--rootform-version");
  }
  return suppliedVersion ?? version(configuredVersion, "toolchain Rootform version");
}

export function requireRootformVersion(output: string, expectedVersion: string): void {
  const actual = output.trim();
  const expected = `rootform ${expectedVersion}`;
  if (actual !== expected) {
    throw new Error(
      `Rootform version mismatch: expected ${expected}, got ${actual || "no output"}`,
    );
  }
}
