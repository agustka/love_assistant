---
name: atomic-design-planner
description: >
  Plan and implement atomic design ISB components from Figma designs.
  Covers Figma MCP health checks, design intake, component reuse analysis,
  data class creation with factory constructors, widget implementation with
  design tokens, and golden test generation.
  Use when: implement component from Figma, create ISB component, refactor ISB component,
  Figma to Flutter, data class pattern, golden test for ISB, atomic design planning,
  IsbPadding, IsbSize, IsbRadius, design tokens.
---

# Atomic Design Planner Skill

Procedural guide for creating or refactoring ISB components from Figma designs with data classes and golden tests.

## Composition & State Management Rules

| Layer    | May compose                    | May NOT compose             |
|----------|--------------------------------|-----------------------------|
| Atom     | atoms                          | molecules, organisms, etc.  |
| Molecule | atoms, molecules               | organisms, templates, pages |
| Organism | atoms, molecules               | templates, pages            |
| Template | organisms, structural wrappers | pages                       |
| Page     | templates, BLoC context        | raw atoms/molecules         |

**BLoC/Cubit placement:**
- `BlocProvider` — pages only
- `context.watch` / `BlocBuilder` — organisms and pages
- `context.read` for navigation — pages only
- Never in atoms or molecules

## Anti-Patterns

- Hardcoded `Color(0xFF...)` or `Colors.blue` — use theme tokens
- Magic number `SizedBox(height: 32)` — use `IsbPadding` or `IsbSize`
- Inline `TextStyle(fontSize: 14)` — use `context.isbTheme.fonts.*`
- Adding strings to `S` class — use placeholder strings + TODO
- Changing line height or letter spacing without explicit instruction
- `BlocProvider` inside an organism — pages only
- Template composing atoms directly — use organism slots
- Missing `Isb` prefix or layer suffix on ISB components
- Widget-returning methods — extract as separate widget classes

## Design Token Quick Reference

### IsbPadding — For padding ONLY

| Token       | Value | Use for                    |
|-------------|-------|----------------------------|
| `none`      | 0     | No padding                 |
| `spacing1`  | 2     | Minimal internal           |
| `spacing2`  | 4     | Tight internal             |
| `spacing3`  | 8     | Small padding              |
| `spacing4`  | 12    | Medium-small padding       |
| `spacing5`  | 16    | Standard padding           |
| `spacing6`  | 24    | Large padding              |
| `spacing7`  | 32    | Extra large padding        |
| `spacing8`  | 40    | Section padding            |

**Location:** `lib/presentation/core/isb/utils/theme/isb_theme.dart`

### IsbSize — For all other dimensions (gaps, widths, heights, icon sizes)

| Token               | Value | Use for                  |
|---------------------|-------|--------------------------|
| `none`              | 0     | Zero size                |
| `microscopic`       | 2     | Hairline elements        |
| `tiny`              | 4     | Very small gaps          |
| `small`             | 8     | Small gaps/icons         |
| `mediumSmall`       | 12    | Medium-small elements    |
| `medium`            | 16    | Standard elements        |
| `mediumLarge`       | 20    | Medium-large elements    |
| `large`             | 24    | Large elements           |
| `extraLarge`        | 32    | Extra large elements     |
| `extraExtraLarge`   | 48    | Section heights          |
| `gigantic`          | 64    | Large containers         |
| `extraExtraGigantic`| 96    | Image sizes              |

### IsbRadius — For border radius

| Token    | Value | Use for              |
|----------|-------|----------------------|
| `none`   | 0     | Sharp corners        |
| `tiny`   | 4     | Subtle rounding      |
| `small`  | 8     | Standard rounding    |
| `medium` | 12    | Card rounding        |
| `large`  | 16    | Large card rounding  |
| `round`  | 180   | Fully rounded        |

## Data Class Pattern

Every ISB component gets a companion data class. The widget takes `data` + optional state params.

```dart
// Data class — immutable configuration object
class ExampleComponentData {
  final String title;
  final String? subtitle;
  final ExampleVariant variant;

  const ExampleComponentData({
    required this.title,
    this.subtitle,
    this.variant = ExampleVariant.standard,
  });

  // Factory constructors for design variants
  factory ExampleComponentData.highlighted({
    required String title,
    String? subtitle,
  }) {
    return ExampleComponentData(
      title: title,
      subtitle: subtitle,
      variant: ExampleVariant.highlighted,
    );
  }
}

// Widget — takes data + state
class IsbExampleMolecule extends StatelessWidget {
  static const Key titleKey = Key('IsbExampleMolecule_title');

  final ExampleComponentData data;
  final bool loading;

  const IsbExampleMolecule({
    super.key,
    required this.data,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) { ... }
}
```

**Real examples in codebase:**
- `ParagraphData` + `IsbParagraphMolecule` → `lib/presentation/core/isb/molecules/texts/isb_paragraph_molecule.dart`
- `IsbListTileData` + `IsbListTileMolecule` → `lib/presentation/core/isb/molecules/lists/`
- `CardContentData` with factory constructors → `lib/presentation/core/isb/molecules/card_element/utils/isb_card_utils.dart`

## Naming Conventions

| Layer    | Pattern                          | Examples                                    |
|----------|----------------------------------|---------------------------------------------|
| Atom     | `Isb{Concept}Atom`               | `IsbTextAtom`, `IsbIconAtom`                |
| Molecule | `Isb{Description}{Noun}Molecule` | `IsbParagraphMolecule`, `IsbTagMolecule`    |
| Organism | `Isb{Feature}{Section}Organism`  | `IsbTransferFormOrganism`                   |
| Template | `Isb{Screen}Template`            | `IsbTransferSetupTemplate`                  |
| Page     | `{Screen}Page`                   | `TransferSetupPage` — no Isb prefix         |
| Data     | `{Component}Data`                | `ParagraphData`, `CardContentData`          |

**File names:** `isb_{description}_{level}.dart` for widgets, `isb_{description}_data.dart` for standalone data files.

## String Handling Rules

- **NEVER** add new keys to the `S` localization class
- Use placeholder strings: `'Placeholder title' // TODO: Add localized string`
- Components accept `String` parameters — they don't call `S.of(context).*` themselves
- The page or organism that assembles the component passes in the localized string

## Line Height & Letter Spacing

- **NEVER** change line height or letter spacing unless the user explicitly instructs it
- Use `context.isbTheme.fonts.*` styles as-is
- If the Figma design shows different line height/letter spacing, note it in comments but do not apply

## Outer Padding / Spacing

- Components must **NEVER** have outer padding or margin — spacing is the responsibility of the parent/consumer
- If the Figma design shows outer spacing around a component, do **NOT** bake it into the component itself
- If in doubt whether spacing belongs inside or outside the component, **ask before implementing**

## Subagent Delegation Strategy

Delegate to subagents throughout the workflow:

| Phase                     | Subagent Type       | Purpose                                          |
|---------------------------|---------------------|--------------------------------------------------|
| Design intake             | Explore             | Search ISB for similar components (parallel)     |
| Reuse discovery           | Explore ×2-3        | Search atoms/molecules + organisms/templates     |
| Usage analysis (refactor) | Explore             | Find all usages across lib/ and test/            |
| Data class creation       | Default             | Create data class file                           |
| Widget implementation     | Default             | Create widget file(s) in dependency order        |
| Usage updates (refactor)  | Default ×2          | Update lib/ and test/ in parallel                |
| Golden tests              | Test Specialist     | Create golden test file with all variants        |
| Verification              | Default ×2-3        | Run tests, lint, full suite in parallel           |

## Golden Test Surface Size Rule

**Golden test surface sizes must be as small as possible while still fitting all scenarios without clipping.** Excess whitespace wastes storage, slows diff review, and masks layout regressions.

- Estimate total height from: scenario count × (widget height + label + padding + gap).
- For accessibility, multiply only the text/label portion by `textScaleSize` — fixed-size widgets (icons, images) do not scale. Typical accessibility height is 1.5–2× light/dark, not 3×.
- After generating goldens, inspect the `.png` — shrink if there is empty space at the bottom.

## Figma-to-Code Comparison Pitfalls

### Figma Color Token Naming Mismatch
Figma design token paths (e.g., `border/brand`) do **not** always map directly to the obvious code token name. For example, `border/brand` in Figma may correspond to `borderBrand` in code, but could also be `foregroundBrand` or another token. **Always verify the actual color value** in both Figma and code rather than assuming a name-based match.

### Figma Code Connect Staleness
When a component is **renamed** (file, class, or both), any existing Figma Code Connect mappings still point to the old file path and class name. Always check and update Code Connect variant nodes after renaming. Look for the component's old name in the Figma Code Connect output from `mcp_figma_get_design_context`.

### Rename Checklist
When renaming an ISB component, update **all** of the following:
1. Widget file name and class name
2. Data class name (if applicable)
3. Test file name (must match component file: `isb_{name}_{level}_test.dart`)
4. Golden image names inside the test (the string passed to `screenMatchesGolden`)
5. Test group name (the string in `group()`)
6. Delete old golden image files (the `.png` files under `goldens/`)
7. Figma Code Connect variant node mappings (if component is linked in Figma)

## References

- **Component creation checklist:** Read `references/component-checklist.md` for detailed step-by-step
- **Golden test template:** Read `references/golden-test-template.md` for test structure and patterns
- **Run-tests skill:** Read `.claude/skills/run-tests/SKILL.md` for targeted golden test run guidance
