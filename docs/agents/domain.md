# Domain Docs

How skills consume this repo's context documentation. The layer model itself is defined in [`architect-mode/context-layers.md`](architect-mode/context-layers.md) — this file is about reading it, not writing it.

**Layout: single-context.** Three context layers plus one `docs/adr/`.

## Before exploring, read your own layer

Read the layer belonging to the tier you are working at. Reading upward is fine; **writing upward is not**.

- **`CONTEXT.md`** at the repo root — actual system context. What the system is for, how it must behave, the ubiquitous language. Written by the architect.
- **`docs/context/build.md`** — build system context. The interpretation of the above into structure and mechanism, with rejected interpretations kept alongside.
- **`docs/context/working.md`** — working system context. What the code does now, what the last wave finished, what the next one is.
- **`docs/adr/`** — long-form build decisions. Read ADRs that touch the area you're about to work in.

**If `CONTEXT.md` does not exist, say so and stop.** Nothing can be derived from an absent layer 1,
and an entry that cites nothing is not a shortcut — it reads as derived and passes inspection. This
is the one absence that is never routine.

For `build.md`, `working.md` and `docs/adr/`: **name the absence once, then proceed.** They are
created lazily, when a decision actually gets resolved, so their being missing is normal on a first
run — but reporting *nothing to do* without saying *because the chain is empty* is the failure this
line used to cause.

*This read "proceed silently. Don't flag their absence" until 2026-08-25. Its effect is recorded in
observation `0001-first-scaffold-and-ring` in the harness's own workshop:
a controller entering a fresh project found no `BLD-` entries, composed an empty wave, and this
instruction "would make it report that absence as normal." Every scaffolded run links this file.*

## File structure

```
/                              ← repo root: the architect's artifact lives here
├── CONTEXT.md                 ← actual system context
└── docs/
    ├── context/               ← everything derived from it
    │   ├── tools.md           ← layer 0, generated
    │   ├── build.md
    │   ├── working.md
    │   └── trail.md           ← clanker's audit log. Does not exist; clanker has never run
    ├── adr/
    │   ├── 0001-....md
    │   └── 0002-....md
    └── agents/                ← this file, the contract, tracker + label config
```

This repo is a single context. If it ever grows into genuinely separate contexts, the multi-context layout is a root `CONTEXT-MAP.md` pointing at one `CONTEXT.md` per context, with context-scoped derivations alongside each.

## ADRs are build context

An ADR is a build-context entry that outgrew one line. `docs/context/build.md` stays scannable — it is queried constantly by the controller — so a decision needing real argument goes to an ADR, and the `build.md` entry cites it.

An ADR therefore obeys build-context rules: it names the actual-context entries it derives from, and it records what was ruled out. An ADR deriving from nothing is either mis-filed as build when it is actually the architect's, or a derivation nobody checked.

## Use the glossary's vocabulary

When your output names a domain concept (in an issue title, a refactor proposal, a hypothesis, a test name), use the term as defined in `CONTEXT.md`. Don't drift to synonyms it explicitly avoids.

If the concept you need isn't there yet, that's a signal — either you're inventing language the project doesn't use (reconsider) or there's a real gap in actual system context, which is escalated, never filled in passing.

## Flag conflicts, never reconcile upward

If your output contradicts an ADR or a build-context entry, surface it rather than silently overriding:

> _Contradicts ADR-0007 (event-sourced orders) — but worth reopening because…_

If it contradicts `CONTEXT.md`, that is not a conflict to flag in passing — it is an escalation. The derivation is what was wrong, and editing the upper layer to match what you found destroys the record that a decision was ever taken.
