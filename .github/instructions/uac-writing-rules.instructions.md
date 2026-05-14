---
applyTo: "copilot/uac/**/*.md"
---

# UAC Writing Rules

Rules automatically applied when creating or editing user acceptance criteria documents.

## Writing Style

1. **No code references** — Never mention class names, method names, enum values, widget types, state objects, cubits, repositories, builders, drivers, or keys.
2. **No specific UI text** — Do not hardcode exact strings, labels, or translated text from the app (e.g., don't write "Hlutabréf", write "the stocks page header"). Describe elements by their **function**: "the page header", "the subtitle", "the error message". The actual text content is a design/localization concern, not a UAC concern.
3. **Use domain-specific nomenclature** — Do not use generic terms like "the page" or "the overview page". Use domain-specific names: "the stocks page", "the funds page", "the portfolio page". This makes criteria unambiguous and directly tied to the feature being described.
4. **No specific colors** — Do not name colors (e.g., "green", "red", "gray"). Instead describe the **visual meaning**: "visually indicated as positive", "visually indicated as negative", "visually indicated as neutral". Color choices are a design/theme concern.
5. **No animation terms** — Do not use words like "animation", "shimmer", or "skeleton". Use "loading state" or "loading indicator" instead.
6. **No layout positioning** — Do not describe specific positions like "below the header", "on the left side", "on the right side", "in the top left corner". Simply state that the element "should be visible" or "should be displayed".
7. **Describe what the user sees** — "A loading state is shown" not "ShimmerAtom is rendered" or "A skeleton animation appears".
8. **One behavior per criterion** — Each criterion tests one observable outcome. Split complex scenarios into multiple criteria.
9. **Include realistic examples** — Use realistic data in examples (e.g., "Arion banki hf." at 179,5 with +0,56%) rather than abstract placeholders.
10. **Be precise about quantities** — "5 placeholder items" not "some placeholders". "The first 3 orders" not "a few orders".
11. **Only cover what the design shows** — If a feature is not visible in the provided screenshot or design (e.g., search field, accessibility mode, specific settings), do NOT create criteria for it.

## What NOT to include in criteria

- ❌ Class names (`StocksOverviewCubit`, `IsbFeatureErrorOrganism`)
- ❌ State enums or properties (`StocksOverviewStatus.loading`, `hasLoadError`)
- ❌ Widget keys (`MarketsOverviewPage.stocksOverviewButtonKey`)
- ❌ Method names (`getData(forceGet: true)`, `filterTextChanged`)
- ❌ Builder or driver patterns (`MarketsBuilder().order()`)
- ❌ Route or link objects (`RouteLink.stocksOverview()`)
- ❌ Repository or service references (`ITradeRepository.stocksStream`)
- ❌ Exact UI strings or labels (`"Hlutabréf"`, `"Leita í hlutabréfum"`)
- ❌ Specific color names (`green`, `red`, `gray`, `backgroundAccentSuccess`)
- ❌ Animation terminology (`shimmer`, `skeleton`, `animation`)
- ❌ Layout positioning (`below the header`, `on the left side`, `in the top left corner`)
- ❌ Features not shown in the provided design (search, accessibility, tabs, etc.)

## Azure DevOps Formatting

The output must be directly copy-pasteable into Azure DevOps work items:

- **Titles** use `**bold**` (not `###` headings) so they render inline in ticket descriptions
- **Given/When/Then/And** keywords are **bold** at the start of each bullet
- Each step is a bullet point (`- `). Only `**And**` lines are indented with 5 spaces to render as nested bullets
- Do NOT use code blocks for criteria

Example:

```markdown
**1. A loading state is shown while data is being fetched**

- **Given** the user opens the stocks page
- **When** the stock data has not yet loaded
- **Then** a loading state should be visible
     - **And** the page header should be visible
```

