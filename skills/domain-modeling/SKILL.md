---
name: domain-modeling
description: Build and sharpen a project's domain model. Use when the user wants to pin down domain terminology or a ubiquitous language, record an architectural decision, or when another skill needs to maintain the domain model.
---

Work in **architect mode** throughout: read `docs/agents/architect-mode.md` and follow it for every question you ask, every decision you take without asking, and the shape of every response. It governs where it conflicts with anything below.

# Domain Modeling

Actively build and sharpen the project's domain model as you design. This is the *active* discipline — challenging terms, inventing edge-case scenarios, and writing the glossary and decisions down the moment they crystallise. (Merely *reading* `CONTEXT.md` for vocabulary is not this skill — that's a one-line habit any skill can do. This skill is for when you're changing the model, not just consuming it.)

## File structure

Most repos have a single context:

```
/
├── CONTEXT.md
├── docs/
│   └── adr/
│       ├── 0001-event-sourced-orders.md
│       └── 0002-postgres-for-write-model.md
└── src/
```

If a `CONTEXT-MAP.md` exists at the root, the repo has multiple contexts. The map points to where each one lives:

```
/
├── CONTEXT-MAP.md
├── docs/
│   └── adr/                          ← system-wide decisions
├── src/
│   ├── ordering/
│   │   ├── CONTEXT.md
│   │   └── docs/adr/                 ← context-specific decisions
│   └── billing/
│       ├── CONTEXT.md
│       └── docs/adr/
```

Create files lazily — only when you have something to write. If no `docs/adr/` exists, create it when the first ADR is needed. **If no `CONTEXT.md` exists, say so and stop** — you do not create that file and you do not write to it (`SYS-004`; see below). Until 2026-08-25 this line told you to create one, contradicting the prohibition forty lines later.

## During the session

### Challenge against the glossary

When the user uses a term that conflicts with the existing language in `CONTEXT.md`, call it out immediately. "Your glossary defines 'cancellation' as X, but you seem to mean Y — which is it?"

### Sharpen fuzzy language

When the user uses vague or overloaded terms, propose a precise canonical term — and put the choice as what each reading makes the system do, not as two words to pick between. "You're saying 'account' — the Customer, who is billed and owns the orders, or the User, who signs in? Closing a Customer stops the money; closing a User only stops the login."

### Discuss concrete scenarios

When domain relationships are being discussed, stress-test them with specific scenarios. Invent scenarios that probe edge cases and force the user to be precise about the boundaries between concepts.

### Cross-reference with code

When the user states how something works, check whether the code agrees — where confirming it means reading around the codebase or the ADRs, send a subagent to reconcile and report back, so this thread stays in the conversation. If you find a contradiction, surface it: "Your code cancels entire Orders, but you just said partial cancellation is possible — which is right?"

### Update CONTEXT.md inline

When a term is resolved, it belongs in `CONTEXT.md` — but **you do not write that file** (`SYS-004`). Hand the resolved term to the architect as it happens rather than batching, in the format [CONTEXT-FORMAT.md](./CONTEXT-FORMAT.md) defines, and let them enter it.

`CONTEXT.md` should be totally devoid of implementation details. Do not treat it as a spec, a scratch pad, or a repository for implementation decisions.

**In this repo it is more than a glossary.** It carries the architect's `SYS-` entries alongside the language, and both are theirs. Never remove or rewrite what you find there on the grounds that it is not vocabulary.

### Offer ADRs sparingly

Only offer to create an ADR when all three are true:

1. **Hard to reverse** — the cost of changing your mind later is meaningful
2. **Surprising without context** — a future reader will wonder "why did they do it this way?"
3. **The result of a real trade-off** — there were genuine alternatives and you picked one for specific reasons

If any of the three is missing, skip the ADR. Use the format in [ADR-FORMAT.md](./ADR-FORMAT.md).

The ADR is also where the decisions you took without asking are recorded — one line each, in the `## Committed without asking` block [ADR-FORMAT.md](./ADR-FORMAT.md) defines. Never in `CONTEXT.md`: you do not write that file. A term you canonicalised without asking needs no separate line, since its glossary entry is already the record; where a decision warrants no ADR, its line rides with the artifact of whichever skill called you.
