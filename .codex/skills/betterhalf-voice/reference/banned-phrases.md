# Banned phrases — grep reference

Quick-reference list of phrases and characters to catch when reviewing existing strings. Useful for mass-review of an existing string catalog (e.g. `grep -ri "smart" lib/` in a Flutter project).

Each section lists the banned token plus suggested replacements / restructuring.

---

## AI branding (highest priority — never appear in user-facing copy)

| Banned | Replace with |
|---|---|
| `AI` | "BetterHalf" or plain description of what's happening |
| `AI-powered` | drop entirely, or describe the mechanism plainly |
| `Assistant` (the noun) | "BetterHalf" or "it" |
| `Smart` / `Smarter` | drop, or describe what makes it good |
| `Intelligent` / `Intelligence` | drop |
| `Machine learning` / `ML` | drop |
| `Algorithm` (describing product behavior) | drop, or describe what's literally being done |
| `Magic` / `Magical` | drop |
| `Neural` | drop |
| `Powered by AI` | drop |
| `Generated for you` | "lined up", "picked", "drafted" |

## Marketing fog (strike on sight)

| Banned | Notes |
|---|---|
| `Revolutionize` / `Reinvent` / `Disrupt` | dead on arrival |
| `Transform` (as verb meaning "improve") | use plain verbs (drafts, picks, plans) |
| `Unlock` | what's locked? say that |
| `Empower` | meaningless |
| `Elevate` | meaningless |
| `Seamless` / `Effortless` / `Frictionless` | overclaims, never true |
| `Curated experience` / `Tailored journey` | corporate fog |
| `Mental load` | overused therapy-speak |
| `Make love visible` | self-help fog |
| `Thoughtful moments` | abstract |
| `Show up well` | abstract |
| `The love you already feel` | abstract |
| `Be more thoughtful` | self-help fog (Ágúst explicitly rejected this) |
| `Care deeply` | abstract |
| `Mindful X` (as positioning) | corporate wellness fog |
| `Reimagine X` / `X, reimagined` | tired |
| `Unleash your potential` | dead |
| `At the intersection of X and Y` | tired |
| `World-class` / `Best-in-class` | meaningless |

## Indie-hacker confession trope

If any of these appear after a founder-voice problem statement, strike them. Trust the reader to connect the dots.

| Banned | Notes |
|---|---|
| `So I built this` | the canonical trope |
| `So I built X` | any variant |
| `I had to fix it, so I made X` | same trope |
| `Which is why I created X` | same trope |
| `...and so this was born` | same trope |
| `That's why X exists` | same trope |

## Stereotyped failure tropes (don't resonate with this audience)

| Banned | Why |
|---|---|
| `Gift card` (as a failure) | Real users laugh. Men don't see gift cards as failure. |
| `Lazy gift` | Implies the audience is lazy. They're not — they're paralyzed by options. |
| `Forgot the anniversary` (as Ágúst-voice claim) | Use "realized the day of" instead. Ágúst doesn't *forget* dates; he *realizes* them too late. |
| `Grocery-store flowers` (unverified) | If you didn't verify with Ágúst, don't claim it. |
| `Last-minute Amazon order` (unverified) | Same — verify before using. |

## Fake-friendly softeners (strip these)

| Banned | Notes |
|---|---|
| `just` (as softener) | "Just tap here" → "Tap here" |
| `simply` | "Simply do X" → "Do X" |
| `easily` | "Easily set up" → "Set up" (or describe how it's easy if true) |
| `actually` (when not adding meaning) | Often filler |
| `only` (when minimizing) | "It only takes a minute" → "Takes about a minute" |
| `quickly` | usually filler |
| `Don't worry` | patronizing |
| `Don't forget to` | nagging |
| `Please` (in instructions) | "Please enter your email" → "Email" or "Your email" |
| `Kindly` | corporate-anachronistic |

## Performative-enthusiasm patterns

| Banned | Notes |
|---|---|
| `Awesome!` / `Great!` / `Perfect!` (alone, after a user action) | over-celebration |
| `Yay!` / `Hooray!` | infantilizing |
| `Woohoo!` | infantilizing |
| Exclamation marks in routine UI | "Saved!" → "Saved." |
| `Hey there!` / `Hi friend!` | fake-personal openings |
| `🎉` / `💝` / similar celebration emoji | brand-voice emoji |
| `Oops!` / `Oopsie!` | infantilizing error-speak |
| `Whoops!` | same |
| `Uh oh!` | same |

## Apologetic / hedging patterns (don't apologize for the product)

| Banned | Notes |
|---|---|
| `Sorry to bother you` | don't apologize for using the product |
| `We apologize for the inconvenience` | corporate-script |
| `Please bear with us` | corporate-script |
| `We're working on it` (without specifics) | vague |
| `Coming soon` (without context) | weak |
| `Are you sure...?` (confirmation dialogs) | hedge — state the consequence directly |

## Mind-reading / presumptuous patterns

| Banned | Notes |
|---|---|
| `We know how X you must feel` | mind-reading |
| `It's tough out there` | presumptuous |
| `Don't worry, we've got you covered` | overpromise + patronizing |
| `How are you today?` (app opens) | presumptuous |
| `Tell us how you feel about...` | unwanted emotional-mining |
| `Take a breath` | wellness-app overreach |

## Generic / weak action labels

| Banned | Replace with |
|---|---|
| `Submit` | concrete verb ("Send", "Save", "Get on the list") |
| `Continue` | what does continuing do? say that |
| `Click here` | name the action |
| `Learn more` (when more specific is possible) | "See how it works", "Read privacy" |
| `Get started` | name the first step |
| `Let's go!` | name the action |
| `OK` (where action is consequential) | concrete verb |

## Non-ASCII characters (AI giveaways)

| Banned | Replace with |
|---|---|
| `—` (em-dash, U+2014) | period, comma, colon, or parentheses (restructure) |
| `–` (en-dash, U+2013) | hyphen-minus (-) |
| `"` `"` (curly double quotes, U+201C / U+201D) | straight `"` |
| `'` `'` (curly single quotes / apostrophes, U+2018 / U+2019) | straight `'` |
| `…` (ellipsis char, U+2026) | three dots (`...`) |
| `·` (middle dot / interpunct, U+00B7) | comma, period, or restructure |
| `→` `←` (decorative arrows) | drop (rely on UI affordance) |

For sweeping a codebase with grep:
```bash
# Find any em-dashes
grep -r "—" lib/

# Find any curly apostrophes (most common AI tell)
grep -rP "'" lib/

# Find any curly double quotes
grep -rP '[""]' lib/

# Find middle dots
grep -r "·" lib/
```

## Gendered defaults (where partner could be any gender)

| Banned in product copy | Replace with |
|---|---|
| `she` / `her` (when referring to partner) | `they` / `their` |
| `he` / `him` (when referring to partner) | `they` / `their` |
| `wife` / `husband` (when "partner" works) | `partner` |
| `girlfriend` / `boyfriend` (when "partner" works) | `partner` |
| `your significant other` | `your partner` (less corporate) |
| `the special someone in your life` | `your partner` (less Hallmark) |

Exceptions: targeted ad campaigns where the wedge calls for gendered copy (e.g. Reddit campaign `red1` deliberately uses "she" because it's targeting hetero men with female partners). In-app strings should default neutral.
