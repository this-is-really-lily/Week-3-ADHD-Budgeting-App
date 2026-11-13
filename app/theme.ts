"use client";

import { createTheme } from "@mui/material/styles";

// Calm, no-shame theme (see docs/adr/0001 and Epic 5 "Calm, not shame").
// Every text color below has at least 4.5:1 contrast on the background (WCAG 2.2 AA).
const calmColors = {
  background: "#F7F5F0", // warm off-white, softer than pure white
  surface: "#FFFFFF",
  text: "#1F2933", // near-black, ~14:1 on the background
  textSecondary: "#4A5560", // ~7:1 on the background
  primary: "#2E5E6E", // calm teal, ~7:1 with white text
  attention: "#8A5300", // warm amber used instead of red for "error" states
} as const;

const theme = createTheme({
  cssVariables: true,
  palette: {
    mode: "light",
    background: { default: calmColors.background, paper: calmColors.surface },
    text: { primary: calmColors.text, secondary: calmColors.textSecondary },
    primary: { main: calmColors.primary },
    // Our specs say "never red", so MUI's red error color is replaced on purpose.
    error: { main: calmColors.attention },
  },
  typography: {
    fontFamily:
      'system-ui, -apple-system, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif',
    h1: {
      // MUI's default h1 is very large; this scales from phones to desktops.
      fontSize: "clamp(2rem, 6vw, 3rem)",
      fontWeight: 600,
      lineHeight: 1.2,
    },
  },
  components: {
    MuiCssBaseline: {
      styleOverrides: {
        // Turn off animations for people who ask their device for reduced motion (T9).
        "@media (prefers-reduced-motion: reduce)": {
          "*, *::before, *::after": {
            animationDuration: "0.01ms !important",
            animationIterationCount: "1 !important",
            transitionDuration: "0.01ms !important",
            scrollBehavior: "auto !important",
          },
        },
      },
    },
  },
});

export default theme;
