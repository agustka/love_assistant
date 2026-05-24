# Setup Wizard — Partner Profile Data Collected

Reference for the CTA marketing page. Lists everything the in-app onboarding wizard asks the user about their partner.

Source files:
- `lib/application/wizard/wizard_cubit.dart` + `wizard_state.dart`
- `lib/domain/wizard/entities/user_partner_profile.dart`
- `lib/domain/wizard/entities/wizard_config.dart`
- `lib/presentation/wizard/widgets/wizard_step_*.dart`

---

## Two flows

The wizard runs in one of two modes (`WizardMode`):

- **Initial** — first-run onboarding, before a profile exists. 4 steps. Asks only for essentials so the user gets value quickly.
- **Detailed** — opened later to enrich the partner profile. 5 steps. Adds optional/long-tail data.

---

## What's asked, step by step

### Step 0 — Greetings
No input. Welcome screen with two bullet points.

### Step 1 — Basic info (both flows, required)
- **Partner name** — free text, max 90 chars
- **Partner pronouns** — single select: `she/her`, `he/him`, `they/them`, or **custom** (free text)
- **Partner birthday** — date picker (1900 → today). Required in initial flow; in detailed flow validated only at the basic-info step.

### Step 2 — Personal preferences

Differs by flow:

**Initial flow (required):**
- **Love languages** — multi-select from: Acts of Service, Quality Time, Words of Affirmation, Physical Touch, Receiving Gifts

**Detailed flow (optional):**
- **Hobbies** — multi-select from: Reading, Cooking, Traveling, Gaming, Fitness, Music, Crafting, Gardening, Movies & TV, Fishing & Hunting, Sports

**Both flows (optional):**
- **Tone of voice** — single select: Playful, Romantic, Casual, Formal *(this controls how the assistant speaks about/to the partner)*

### Step 3 — Foods & gifts (both flows, optional)
- **Favorite foods** — multi-select from: Chocolate, Coffee, Pizza, Pasta, Noodle dishes, Seafood, Salads, Spicy food, Street food, Home-made, Wine, Desserts
- **Gift categories** — multi-select from: Experience, Sentimental, Practical Gifts, Luxury Items, Hobbies, Food & Drinks, Wellness, Surprise Me

### Step 4 — Anniversary & relationship (detailed flow only, optional)
- **Relationship type** — single select: Dating, Engaged, Married, Life Partners, Other
- **Anniversary** — date picker (1900 → today)

---

## What's persisted vs. only captured in-flight

`UserPartnerProfile` (the entity emitted to the rest of the app at the end of the initial flow) holds:

`partnerName`, `partnerPronoun` (+ `customPronoun`), `partnerBirthday`, `partnerLoveLanguages`, `partnerToneOfVoice`, `partnerFavoriteFoods`, `partnerGiftCategories`.

The wizard **also collects** but does **not** currently include in `UserPartnerProfile`: `partnerHobbies`, `partnerAnniversary`, `relationshipType`. These are tracked in `WizardState` for the detailed flow but aren't part of the entity contract yet.

---

## Marketing-relevant summary (one-liner)

The wizard asks for the partner's **name, pronouns, birthday, love languages, tone of voice, favorite foods, gift preferences**, plus — in the deeper profile — **hobbies, relationship type, and anniversary**. Together this gives the assistant enough to generate genuinely personalized messages, gift ideas, and reminders rather than generic prompts.
