import { render, screen } from "@testing-library/react";
import { describe, expect, it } from "vitest";
import HomePage from "@/app/page";

describe("Home page", () => {
  it("shows exactly one main heading with the app's welcome text", () => {
    render(<HomePage />);

    const headings = screen.getAllByRole("heading", { level: 1 });
    expect(headings).toHaveLength(1);
    expect(headings[0]).toHaveTextContent("Safe to Spend — coming together");
  });

  it("puts the content inside a main landmark for screen readers", () => {
    render(<HomePage />);

    const main = screen.getByRole("main");
    expect(main).toContainElement(screen.getByRole("heading", { level: 1 }));
  });
});
