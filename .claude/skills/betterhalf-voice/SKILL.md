---
name: betterhalf-voice
description: BetterHalf brand voice review and authoring. Use proactively whenever editing or writing user-facing text in the BetterHalf product — including UI labels, button text, error messages, onboarding flows, push notifications, empty states, confirmation dialogs, success messages, in-app strings, localizable text, App Store listings, email subject lines, or any text the user will read. Catches and fixes marketing fog, AI-coded language ("Assistant", "Smart", "AI-powered"), em-dashes and curly quotes, gendered defaults, the "so I built this" indie-hacker trope, stereotyped failure tropes (e.g. "gift card"), fake-friendly softeners ("just", "simply"), and other voice violations. Also use when writing new copy from scratch — apply the voice rules and mental model before producing strings.
version: 1.0.0
user-invocable: true
---

# BetterHalf voice

Brand voice review and authoring for the BetterHalf product.

## The product, in one paragraph

BetterHalf helps men show up for their partner without doing the part they're bad at: figuring out what to give, what to write, and what to plan. Positioned as a thoughtful friend who knows your partner combined with a secretary who handles the artifacts. **Not** an AI product. **Not** an Assistant. **Not** a reminder app. Built solo by Ágúst Karlsson.

## The voice in one paragraph

Plain-spoken. First-person where the founder is present ("I built this", never "we"). Second-person where the product addresses the user ("you pick, you send"). Honest about uncertainty. Names concrete failures (decision paralysis, blank cards, day-of scrambles) but never stereotyped ones ("gift cards" — real users laugh at that one). Gender-neutral by default ("they/their"). No marketing fog. No AI branding. No em-dashes or curly quotes. Audience leans male and recognizes fake polish instantly — write like a real person, not a brand.

## When to apply this skill

Apply whenever editing or authoring user-facing text. The trigger isn't *"is this marketing copy"* — it's *"will the user read this."* That includes:

- UI labels, button text, form field labels
- Error messages and validation messages
- Empty states
- Confirmation dialogs
- Success / completion messages
- Onboarding flows and tooltips
- Push notifications
- In-app dialog text
- Email subject lines and body
- App Store / Play Store listings
- Toast messages and snackbars
- Loading state text
- Settings descriptions and help text
- Any localizable strings

Skip only for: code comments, log messages, internal debug strings, and developer-facing documentation.

## The non-negotiables (bright-line rules)

These are not preferences. They're hard rules. Catch and fix every violation.

### 1. No AI branding

Never use these words in user-facing text:

- "AI"
- "AI-powered"
- "Assistant" (the noun, referring to the product)
- "Smart" / "Smarter"
- "Intelligent" / "Intelligence"
- "Machine learning" / "ML"
- "Algorithm" (when describing what the product does)
- "Magical" / "Magic" (the AI-coded version)
- "Neural" / "Powered by AI"

**Why:** The product is deliberately positioned as a clever solution to a real human problem, not another AI product. AI branding is everywhere; slipping into it pattern-matches BetterHalf to a category the audience has rejected.

**Replace with:** "BetterHalf", "it", or plain descriptions of what's actually happening (*"It looks through what your partner's mentioned"* beats *"Our AI analyzes..."*).

### 2. First-person founder voice (where the founder speaks)

When copy is attributable to Ágúst (founder notes, personal messages from the maker, app intro text in the founder's voice):

- Use "I" / "my" / "me"
- Never "we" / "us" / "our"

There is no team. BetterHalf is built solo by Ágúst Karlsson. The "we" is misleading and breaks the indie-builder trust signal.

**Exception:** customer-voice content (e.g. a drafted message from the user to their partner) follows the natural pronouns of *that* content, not the founder voice.

### 3. Gender-neutral default for the user's partner

When the product copy refers to the user's partner:

- Use "they" / "their" / "your partner"
- Never default to "she/her" or "he/him"

The user's partner can be any gender. Gendered copy is reserved for specific targeted ad campaigns where the wedge calls for it — **not** for in-app strings. This does not apply
to specificly constructed strings based on the user-selected gender of their partner.
When available, use the partner's name or the use-selected gendered pronouns. When not, default to gender-neutral language.

**Examples in context:**
- ✓ "Tell BetterHalf about your partner: who they are, what they actually enjoy."
- ✗ "Tell BetterHalf about her: who she is, what she actually enjoys." - unless the user has explicitly selected "she/her" for their partner, in which case this would be fine but it is always programmatically constructed based on the user's selection, not hardcoded in copy.

### 4. No em-dashes, no curly quotes, no fancy punctuation

These characters are AI-text giveaways. The target audience is increasingly tuned to spotting them. Use ASCII punctuation only.

**Avoid:**
- Em-dash (—)
- En-dash (–)
- Curly double quotes (" ")
- Curly single quotes / apostrophes (' ')
- Ellipsis character (…)
- Middle dot / interpunct (·)
- Decorative arrows (→ ←)
- Non-breaking spaces in copy

**Use instead:**
- Period, comma, colon, or parentheses (restructure sentences that "needed" an em-dash)
- Straight double quotes (")
- Straight apostrophes (')
- Three dots (...)
- Plain text without separator chars (or restructure)
- Plain hyphen-minus (-) when a separator is truly needed

### 5. No marketing fog

Strike these phrases and any close cousins on sight. They sound like every other SaaS landing page.

**Banned phrases:**
- "Revolutionize" / "Reinvent" / "Disrupt"
- "Transform" (when used as a verb to mean "improve")
- "Unlock" / "Empower" / "Elevate"
- "Seamless" / "Effortless" / "Frictionless"
- "Curated experience" / "Tailored journey"
- "Mental load"
- "Make love visible"
- "Thoughtful moments"
- "Show up well"
- "The love you already feel"
- "Be more thoughtful"
- "Care deeply"
- "Mindful X" (when used as marketing positioning)
- "Reimagine X"
- "X, reimagined"

**Replace with:** plain description of what's literally happening. *"It drafts a message in your voice"* beats *"It helps you show up more thoughtfully."*

### 6. No "so I built this" indie-hacker trope

If founder-voice copy names a personal problem, do **not** then write the link to the product.

**Banned:**
- "So I built this."
- "So I built X."
- "I had to fix it, so I made BetterHalf."
- "Which is why I created..."
- "...and so this was born."

**Why:** This is the most overused solopreneur landing-page template of the last several years. Once a reader recognizes the pattern, they file the entire confession as marketing — even when the underlying story is true. Trust the reader to connect the dots.

### 7. Truthful first-person

For any founder-voice beat ("I used to X", "I'd Y"), only use verified failures:

**Verified true for Ágúst:**
- He'd *realize* the date the day of, or the day after
- He hates shopping
- He never knows what'll land as a gift
- He puts things off until it's too late
- He gets stressed/overwhelmed at the picking process

**Do NOT claim:**
- He gave gift cards (he never has)
- He knew the dates / remembered them (gives away a product feature)
- He scrambled for grocery-store flowers, gas-station chocolates, etc. (unverified)
- He had a specific dramatic incident (unverified)

If unsure whether a specific failure applies, ask the user before shipping.

## The friend + secretary mental model

The product is positioned as **two roles in one**:

- **The friend half** — taste, judgment, knowing your partner specifically. The thing that makes the recommendations land. Low-number, good-fit options instead of thousands of generic ones.
- **The secretary half** — drafts the message, books the table, lines up the gift options, handles the artifacts so you can just approve. The thing that means you don't have to do the legwork.

Both halves matter. Copy that names only the secretary (drafts, finds, plans) without the friend (taste, knowing your partner) misses the differentiator. Copy that names only the friend (warm, thoughtful) without the secretary (concrete artifacts) reads as vague.

**The user always picks.** The product prepares; the user decides and sends. This pre-empts the "is this faking my feelings?" objection. Lean on it in any context where the user might suspect the product is acting *for* them.

- ✓ "You pick, you send."
- ✓ "Edit the draft. Pick the gift. Book the table."
- ✗ "We'll handle it for you." (overpromises automation, undersells user agency)

## Product-specific copy contexts

**Drafting a message to the partner:**
- The draft is a starting point, not the final word.
- Tone in the surrounding UI: *"A draft to start from. Edit it your way."* not *"Here's the perfect message!"*
- The user's choice to send is the moment that matters.

**Presenting gift options:**
- Show a small set (3 is the canonical number).
- Name *why* each suggestion fits the partner specifically. *"A linen apron from the shop in Lisbon she keeps mentioning"* beats *"A cooking gift she might like."*
- The friend signal lives in the specificity. Generic suggestions break the metaphor.

**Date night planning:**
- One thoughtful suggestion at a time, not a menu.
- Tone: *"Late dinner at the small Korean place. Walk after."* — plain, concrete, easy to picture.
- If the user wants alternatives, show them — but don't lead with "here are 10 options."

**Empty states (no data yet):**
- Honest about why it's empty.
- Specific about what unlocks the content.
- ✓ *"Tell BetterHalf a bit more about what your partner enjoys, and it'll start lining up gift ideas they'd actually want."*
- ✗ *"You haven't added anything yet! 🎁 Click here to get started."*

**Push notifications:**
- Specific reason for the interruption.
- No clickbait.
- Respect the attention — if you don't have a real reason to interrupt, don't.
- ✓ *"Your anniversary is in 7 days. Three gift ideas ready when you want them."*
- ✗ *"Don't miss this! 💝 Tap to see what we've got for you."*

**Settings / privacy / data screens:**
- Plain language about what the product does with the user's data.
- No legal-speak hiding behind euphemism.
- ✓ *"Your partner's name and details stay on your device. BetterHalf doesn't send them anywhere."* (if true)
- ✗ *"We respect your privacy and handle your data in accordance with our policies."*

## What to NEVER do

- **Don't claim the product makes the user romantic.** The user brings the relationship; the product does the prep.
- **Don't apologize for what the product does.** No *"Sorry to bother you, but..."* The product earns its space.
- **Don't be cute when honest is available.** *"Oopsie!"* loses to *"Something went wrong."*
- **Don't use exclamation marks** except in extreme rare cases. They read as performative enthusiasm and break the plain-speech voice. Default to periods.
- **Don't use emoji** unless the user has explicitly asked for them in a specific context. Emoji read as brand-voice attempts to sound friendly. Plain text reads as confident.
- **Don't pre-solve the user's problem in copy.** *"We know how stressful planning a date can be..."* is mind-reading. Get to the point.
- **Don't write fake-personal copy.** *"Hey there, friend!"* reads as a chatbot. Real-person tone is plain, not performatively warm.
- **Don't use softeners.** *"Just"*, *"simply"*, *"easily"*, *"actually"* (when not adding meaning), *"only"* (when minimizing) — strip them. They sound like the writer is trying to make the user feel okay about something.
- **Don't ask the user how they feel.** Apps that ask *"How are you today?"* sound presumptuous and saccharine. Get on with the work.
- **Don't end statements with "..." for trailing-off effect.** Either commit to the sentence or rewrite it.

## Patterns by context (quick reference)

### Buttons / action labels

Verb-first, concrete about what happens.
- ✓ "Get on the list" / "Send draft" / "Pick this one" / "Save changes"
- ✗ "Submit" / "Continue" / "Let's go!" / "Click here"

### Error messages

Honest about what went wrong. Gentle without being chirpy. Actionable.
- ✓ "That email doesn't look right. Try again."
- ✓ "Couldn't save that. Check your connection and try again."
- ✗ "Oops! Something went wrong. Please try again later."
- ✗ "We're sorry, an error has occurred."

### Empty states

Helpful, not preachy. Explain why empty and what to do next.
- ✓ "No gift ideas yet. Tell BetterHalf a bit more about your partner."
- ✗ "Looks like you haven't added anything yet! Get started by..."

### Success messages

Matter-of-fact. Don't over-celebrate.
- ✓ "You're on the list. I'll be in touch soon."
- ✓ "Saved."
- ✗ "Awesome! 🎉 You're all set!"
- ✗ "Great choice!"

### Confirmation dialogs

Clear about consequences. No hedging.
- ✓ "Delete this draft? You can't recover it."
- ✗ "Are you sure you want to delete?"

### Loading states

Honest about what's happening. Don't lie about the mechanism.
- ✓ "Looking through what your partner's mentioned..."
- ✗ "Magic is happening..." / "AI is thinking..." / "Just a sec..."

### Form field placeholders

Show the format. Don't restate the label.
- ✓ "you@example.com" (for an email field)
- ✗ "Enter your email here"

## Voice checklist (run before shipping any copy)

- [ ] No "AI", "Assistant", "Smart", or related branding
- [ ] First-person ("I") where the founder speaks; never "we"
- [ ] Gender-neutral pronouns ("they/their") for the partner
- [ ] No em-dashes (—), curly quotes (" "), curly apostrophes (' '), or middle dots (·)
- [ ] No marketing fog phrases (revolutionize, unlock, transform, etc.)
- [ ] No "so I built this" trope
- [ ] Concrete, verified failure naming (no invented Ágúst-failures, no stereotyped tropes)
- [ ] No exclamation marks (except in rare deliberate cases)
- [ ] No emoji (unless explicitly required)
- [ ] No softeners ("just", "simply", "easily")
- [ ] No "we apologize for the inconvenience" energy
- [ ] User agency preserved ("you pick, you send")
- [ ] Reads like a real person, not a brand voice

## Example reviews

### Onboarding screen

**Before:**
> "Welcome! 🎉 Let's help you become a more thoughtful partner. Just tell us about your significant other and we'll generate AI-powered gift suggestions tailored just for them!"

**After:**
> "Tell BetterHalf a bit about your partner. It uses that to line up gift ideas they'd actually want, draft messages in your voice, and plan nights that match the mood."

**What changed:**
- Removed: emoji, "Welcome!", "more thoughtful partner" fog, "AI-powered", "just" softener, "tailored just for them" cliché
- Added: concrete artifacts (gift ideas, message drafts, plans), the personalization angle made specific
- Voice: matter-of-fact, says what it does, doesn't oversell

### Error message

**Before:**
> "Oops! Something went wrong. Please try again later. 😔"

**After:**
> "Couldn't save that. Check your connection and try again."

### Confirmation dialog

**Before:**
> "Are you sure you want to delete this draft?"

**After:**
> "Delete this draft? You can't recover it."

### Push notification

**Before:**
> "Hey there! 💝 Don't forget — your anniversary is coming up! We've got some great suggestions waiting for you!"

**After:**
> "Your anniversary is in 7 days. Three gift ideas ready when you want them."

### Empty state

**Before:**
> "Looks like there's nothing here yet! 🤔 Why not get started by adding some information about your special someone?"

**After:**
> "Nothing here yet. Tell BetterHalf about your partner and it'll start lining up ideas."

### Success message

**Before:**
> "Awesome! Your message has been saved successfully! 🎉 You can edit it anytime."

**After:**
> "Draft saved. Edit it anytime."

## When in doubt

Read the line aloud in the voice of someone you'd actually trust — a thoughtful friend, not a brand. If it sounds like marketing, rewrite it. If it sounds like a real person, ship it.

A useful gut check: would Ágúst send this exact sentence to a friend in a text? If no, it's probably not in voice.

## Provenance

These voice rules were established through extensive copy-review sessions on the BetterHalf landing page (`love_assistant_signup` repo). Specific lessons captured here include:

- The "no AI branding" rule — Ágúst's explicit positioning against the AI-product category
- The "first-person solo builder" rule — built solo, no team
- The "no em-dashes / curly quotes" rule — discovered when sweeping the landing page for AI-coded characters; ~165 curly apostrophes were swept in one pass
- The "no gift cards" rule — Ágúst's partner laughed at the "no more gift cards" cold headline; men don't recognize gift cards as a failure
- The "friend + secretary" mental model — emerged from rubber-ducking the cold variant CTA
- The "anti-paralysis, not anti-laziness" framing — replaced earlier laziness-framed copy
- The "you pick, you send" agency line — pre-empts the "is this faking my feelings?" objection
- The "no 'so I built this'" trope rule — Ágúst explicitly called this "top cringe"

If a copy review surfaces something this skill doesn't cover, ask the user — they have strong, considered opinions and will give you a clear answer.
