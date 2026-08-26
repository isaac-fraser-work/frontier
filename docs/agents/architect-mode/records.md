# Records

Every decision taken without escalating is recorded. Two formats; the tier and the author decide which. Read [`../architect-mode.md`](../architect-mode.md) first.

## Forensic line — the default

For any decision your own layer authorised. One line, **at the site of the decision** — wherever that unit of work records its outcome. Under a ticket-based tracker that is the resolution comment; absent one, the working-context entry covering the work. The rule is the siting, not the venue: a record filed away from the decision it describes will not be found by anyone tracing back to it.

```markdown
## Committed without asking
- <what was chosen> — <the one fact that characterises it> [BLD-901]
```

**Write it for the case where nobody reads it.** These are read only when something is already wrong, so the record is **forensic, not explanatory** — the minimum that identifies what was chosen, so it can be found later. State the choice and the one fact that distinguishes it from the alternative. No justification, no reasoning, no alternatives considered.

*(`BLD-901` is illustrative. The `9xx` block in every id family is reserved for examples and is never allocated, so a template id can never be mistaken for a claim about a real entry.)*

**The citation is not optional.** The bracketed id names the context entry that authorised the decision, and it is what turns a flat log into something traversable: from a symptom to the decision, from the decision to the context that permitted it, and from a bad context entry to everything built on it. A line with no citation is a decision nobody could trace, which is the failure the record exists to prevent.

If you cannot name the entry that authorised it, you did not have authority — escalate instead of recording.

## Trail entry — clanker only

Heavier, and licensed to exactly one agent. Full format and obligations in [`clanker.md`](clanker.md).

The asymmetry is deliberate and worth stating plainly. A forensic line is enough for decisions taken under context an architect wrote, because the reasoning that mattered is already in the context. Clanker writes the context itself, so nothing upstream holds its reasoning — the trail entry has to carry what would otherwise have been an architect's judgement, or a bad decision by clanker is unrecoverable rather than merely wrong.

## What is never recorded this way

Decisions the architect took. Those land as actual-context entries with their own ids; a record saying the architect chose something is noise, and it invites an agent to treat their decision as one of its own.
