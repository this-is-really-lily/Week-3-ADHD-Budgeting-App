import { cleanup } from "@testing-library/react";
import { afterEach } from "vitest";
// Adds readable checks like expect(element).toBeInTheDocument() to every test.
import "@testing-library/jest-dom/vitest";

// Remove what each test drew on the page, so tests can't affect each other.
afterEach(() => {
  cleanup();
});
