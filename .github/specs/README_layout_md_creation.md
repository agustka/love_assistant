# Layout Specification (layout.md)

Describes the **UI structure and layout** of a feature.

Used by the UI agent to build the interface.

---

## What to include

Describe the layout in a simple, structured way:

- Screens / states (e.g. loading, error, success)
- Main sections of the UI
- Order and hierarchy of elements
- Key interactions (navigation, buttons, flows)

Focus on structure, not styling details.

---

## Images

Yes, images can be included.

Use them to:
- show layout structure
- clarify complex UI
- provide visual reference

Keep in mind:
- images support the description, they do not replace it
- the layout must still be understandable from text alone

---

## Figma

Figma links can be included.

If included:
- link directly to the relevant screen or component
- avoid linking entire files without context

Figma is a reference, not a source of truth.  
The layout description should still stand on its own.

---

## Notes

- Do not describe API or data structures (see `api.yaml`)
- Do not describe behavior in detail (see `bdd.md`)
- Do not include implementation details

---

Keep it simple.  
Describe what the UI looks like and how it is structured.  
If something is obvious, don’t over-explain it.