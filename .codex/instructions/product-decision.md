# Product Decisions

## What the product is

A practical assistant for one partner in a relationship. It remembers important moments, drafts the message, finds the gift, plans the date, and eventually books or buys it. Good intentions turn into real-world action with almost no mental load.

It is built for someone who cares about their partner but struggles to consistently show it. The product handles the friction parts (remembering, researching, writing, planning, booking, buying). The user still chooses, still cares, still sends.

## Core principle

Prepare and present. Never automate.

The user does not delegate caring. The product does the preparation work and presents finished options. The user picks, edits, and acts. This is the line that separates the product from "AI does it for you" automation and from couples-coaching apps that ask the user to reflect more.

## What it is not

- Not a couple dashboard. No shared admin, no joint to-do list.
- Not a relationship-improvement app. No quizzes, no exercises, no coaching.
- Not a chatbot. No blank prompt, no thread, no "ask me anything" surface.
- Not an idea generator. Suggestions are concrete enough to act on, not lists to scroll.

## Interaction model: cards, not chat

Every output the product produces is a card. Every card is in one of three states:

1. Ready to use
2. Ready to approve
3. Ready to adjust with one tap

Never: ready to discuss.

A card is the unit of state. The user accepts it, edits it, replaces it, or saves it for later. The home screen is a feed of prepared cards. There is no global prompt.

### Card actions

Primary actions on any suggestion card:

- Use it (book, buy, send)
- Change it
- Show me 3 more
- Save for later

"Change it" opens an edit panel, bottom sheet, or inline controls attached to that card. It does not open a thread.

### Edits are structured first, free-text second

Use chips and focused options before asking the user to type. Examples:

**Date plan:** Change day. Change time. Lower budget. More casual. More romantic. Closer to home. No alcohol. Restaurants only. Surprise me.

**Gift:** Lower price. More personal. More practical. Arrives sooner. No jewelry. More experience-based. More handmade.

**Message:** Make it warmer. Make it shorter. Less intense. More playful. More romantic. Mention her stressful week. Remove the apology. Rewrite in my voice.

Free text is allowed, but only as a scoped note attached to one card.

Avoid: *"Ask the assistant anything..."*
Use: *"Add a detail (optional). 'She mentioned she wants somewhere quiet.'"*

Hard character limit on every free-text field, around 120 characters. The limit is the architectural defense against the field quietly becoming a chat.

## Onboarding: 5 minutes, useful from day one

Onboarding is brief on purpose. Birthday. Anniversary. A handful of "things she loves" chips. One or two "don't" chips. One short open field.

That is enough to generate generically-decent cards on day one. The partner model gets sharper over weeks through normal use, not through a long intake form.

## How the partner model grows over time

Every detail about the partner enters the model through one of three doors. None of them is a text box for talking to the assistant.

### Door 1: Onboarding

Covered above. Minimum viable profile.

### Door 2: Card-side learning (the main door)

Every time the user does anything other than accept a card, that action is a learning signal. The product harvests it without a conversation:

- User taps "Make it less formal" → after the rewrite, a small chip: *"Default to casual for her? [Save / Just this one]"*
- User taps "No alcohol" → *"Save as a permanent rule? [Save / This card only]"*
- User taps "Show 3 more" three times in a row on gifts → next card asks: *"Was the price the problem? [Too high / Too low / Other]"*
- User books a date-night option → *"Save 'Korean food' as a known winner? [Save / Skip]"*

Every learning prompt is one structured choice with a default. The user confirms, skips, or corrects. The model only updates from confirmed answers, never from silent inference. The moat is user-supplied trust. That trust collapses the first time the user discovers a fact about their partner they never typed.

### Door 3: Prompt cards in the feed (the slow door)

Occasionally the home screen shows a card whose purpose is to answer one question:

- *"What's a restaurant she's been wanting to try?"* (short text + recent suggestions as chips)
- *"Three things she'd never wear."* (chips, optional add)
- *"Last gift that really landed?"* (short text + a "why did it work?" chip set)
- *"Anniversary date, set it once?"* (date picker)

Same shape as every other card: prepared, structured, single action, dismissible. The user feels they're answering a card, not filling out a profile. Reward is immediate: the next suggestion visibly uses what they just told you.

## The "what I know about her" page

A read-only-by-default page that shows the assembled partner model in plain English. Sections:

- Important dates
- Things she loves
- Things to avoid
- Past gifts that landed
- Past gifts that missed
- Recurring stress points

Each fact has an edit or delete chip. The "add" action on each section opens the same structured pickers used in onboarding (chips, date picker, scoped text), never a blank prompt.

The page does two jobs: it gives the user an audit surface (so they can see and correct what the model knows), and it acts as visible proof that the model is getting sharper. Both jobs matter for retention.

## Architectural rule: four input shapes

Every fact about the partner has to be expressible as one of:

1. A chip selection
2. A date or number picker
3. A scoped text field bound to one specific question, hard-capped around 120 characters
4. A confirmation on a system-suggested fact (*"save this?"*)

If a fact cannot be captured this way, either decompose it into smaller structured questions or accept that it stays out of the model. No free-text "tell me about your partner" surface, ever.

## Where the pressure to add a chat surface will come from

Three places, all real, all solvable without chat.

1. **"I want to ask about X."** Users will want to ask things like *"what about a weekend trip for her birthday?"* The answer is: that is a *gift card* with a free-text note ("budget for a trip"), not a chat. The home screen needs a "show me ideas for ___" entry that opens a structured card-creation flow.
2. **"This is wrong in a way none of your chips capture."** Every card needs a scoped "tell me what to change about *this card*" field. Character-limited. The limit is the defense.
3. **"Just let me talk to it."** Some users will explicitly ask for chat. Resist for the first year. The product's distinctive value collapses the moment cards become chat outputs.

## Avoid these UI cues

They drag the product back toward a chatbot:

- Chat bubbles
- Conversation threads
- Large empty prompt boxes
- Assistant avatars
- Typing animations
- "Ask me anything"
- "What would you like to do today?"
- Prompt examples
- Back-and-forth turns
- "Regenerate response"

Use instead:

- Cards
- Bottom sheets
- Chips
- Inline edits
- Version replacement
- "Update plan"
- "Try another"
- "Make it..."
- "Use this"

## Long-term USP: real-world follow-through

The product does not stop at the suggestion. It moves to the action.

- Not "here is a gift idea." Buy it.
- Not "here is a restaurant." Book it.
- Not "here is a message draft." Edit and send from inside the product.

The roadmap should drive toward integrations with booking platforms, gift shops, restaurants, florists, calendars, and local services. This is the long-term moat. Suggestion engines are commodity. Booked tables are not.

## Design risks to plan for

### Correction asymmetry

Users reject bad suggestions easily ("not this") but rarely articulate *why* in a way that generalizes. Negative signal is weak; the model needs positive signal to get sharp.

Two design moves help:

- Make every "save this preference" prompt concrete and binary. Not *"tell me what went wrong"* but *"is $200+ too much for gifts? [Yes / Just this one / No]"*
- Front-load prompt cards with positive-signal questions (*"name something she loved getting"*). One good example teaches the model more than ten rejections.

### Card decay

What happens when a suggestion is wrong, a booking fails, or the user ignores a card and the date passes? The card-first model needs a graceful "this didn't land" path, or dead cards accumulate and the feed feels stale. Worth designing a "what happened?" capture at the moment a card expires.

### Trigger model

Birthdays and anniversaries have built-in triggers (the date). Date nights and "just because" messages do not. Without an explicit trigger model, the home screen has no logic for what to show today, and the product quietly becomes a to-do list. Design decision required: cadence-based ("offer a date night every 10 to 14 days unless one is already planned"), context-based ("she had a stressful week, suggest something quiet"), or both.

## Summary

The product prepares the next thoughtful action and presents it as a card. The user picks, edits, and sends. The partner model gets sharper over time through chips and confirmations, never through chat. The long-term value is moving from "here is an idea" to "here is the booked table."

The card is the unit of state. The chip is the unit of input. The confirmation is the unit of trust. Everything else is interface.
