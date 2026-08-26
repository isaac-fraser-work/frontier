# Context layers

Three layers, one per scope tier. Read [`../architect-mode.md`](../architect-mode.md) first — this file is the schema, not the doctrine.

| Layer | File | Written by | Lifetime |
| --- | --- | --- | --- |
| **Layer 0 — tools** | `docs/context/tools.md` | Derived from the skills themselves | Regenerated; never hand-authored |
| **Actual system context** | `CONTEXT.md` | The architect, and [clanker](clanker.md) alone among agents | Durable — outlives every build |
| **Build system context** | `docs/context/build.md` | The controller, derived from actual | Revised when actual changes |
| **Working system context** | `docs/context/working.md` | The controller, with handoff entries from subagents | Volatile — current state only |

The human artifact sits at the repo root; the derived ones sit under `docs/context/`. That split is the mandate made physical: **what the architect authors is not filed alongside what the system generates from it.**

## Layer 0 is orthogonal, not superior

The numbering is misleading if read as a stack. Layers 1, 2 and 3 are a **derivation chain** — each is built from the one above and never from below. **Layer 0 is not above layer 1 and nothing derives from it.** It is a different axis entirely: layers 1-3 describe *the system being built*; layer 0 describes *the tools that build it*.

`ring` holds it (`SYS-013`), and its whole content is **which tool, and what for**. Nothing else may go in it:

- **Not** what the system does, is for, or must not become — that is layer 1, and putting it here gives the one agent that sees everything a private copy of the architect's layer.
- **Not** how a tool works. `ring` spawns a subagent to load a tool's interface when it needs one, so the operating detail never lands in layer 0 at all.
- **Not** a routing table for information. It routes *work to tools*, never *questions to answers*.

The failure it is shaped against is specific: a top-level agent that accumulates system knowledge stops delegating and starts answering, and it is the one agent able to do so invisibly, because everything below it arrives through it. Confining layer 0 to selection and delegation is what keeps the abstraction an abstraction.

**It is derived, not written.** `docs/context/tools.md` is regenerated from the skills' own frontmatter. That is the anti-contamination guarantee made structural rather than promised: knowledge smuggled into a generated file does not survive the next regeneration.

## Which layer does a fact belong in

Three questions, in order. The first that answers *yes* names the layer.

1. **Would this still be true if the system were thrown away and rebuilt from scratch by a different team?** → **actual**. It is a property of what the system is for, not of this construction of it.
2. **Could a competent team fulfil the actual context differently and still satisfy it?** → **build**. It is one interpretation among several, and the choice between them is what build context records.
3. Otherwise → **working**. It is true of the code as it stands right now, and stops being true when the code changes.

The common error is filing a build decision as actual, which freezes an interpretation into something that was meant to survive it. When a fact reads as actual but you arrived at it by reasoning about construction, it is build.

## Actual system context — `CONTEXT.md`

What the system is for, how it must behave, what it must not become. The ubiquitous language. The product shape — interface, interaction model, the surface presented to whoever uses it.

**Agents do not decide this.** A gap here is escalated to the architect, never filled from below; that prohibition is the whole reason the tiers hold.

Two routes put words in this file, and they differ in kind — one *decides*, one *records*:

- **[Clanker](clanker.md) decides**, in the architect's place, and only for a run they explicitly invoked it for. Every entry it writes is marked as such and backed by a trail entry.
- **Any agent may transcribe** a decision the architect has already taken — but only with their own words quoted verbatim beside it (`SYS-010`). No record, no entry. A record that paraphrases, tidies or completes what they said is not a record, and where the entry reaches further than the quote, the excess is authored rather than transcribed.

The second is not a weaker form of the first. Clanker is granted judgement; transcription is granted none — it is typing, made checkable by showing its source.

The prohibition covers **filling** the layer, not raising questions against it, and the distinction is where the tiers are actually load-bearing. A lower tier may say *"this is not covered"* as loudly as it likes; it may never decide what covering it would say. What flows upward is the shape of the hole, never a proposed filling for it — a suggested answer attached to an escalation is an agent authoring the top layer through the architect's hand, and it is the politest form of the failure this file exists to prevent.

Entries carry a stable id — `SYS-001`, `SYS-002` — so records and trail entries can cite them. Ids are never reused and never renumbered; a superseded entry is struck and left in place with a pointer to its successor.

## Build system context — `docs/context/build.md`

The interpretation of actual system context into what the build looks like. Structure, mechanism, the working principle — *how the database is navigated* rather than *how it is organised*. Everything a subagent needs in order to know what it is building toward without reading the architect's mind.

Entries carry ids — `BLD-001` — and **each cites the actual-context entries it derives from**. An entry that cites nothing is either mis-filed or evidence of a derivation nobody checked; both are defects.

**Rejected interpretations live here.** When the controller weighed contrasting readings and committed to one, the ones it ruled out are recorded alongside it. They are the only thing in the system that can detect drift back toward an interpretation already discarded, and nothing else will notice it happening.

Where a fork was resolved by escalating to the architect, the derived entry names the actual-context entry their answer created. That is what makes the chain auditable in both directions.

## Working system context — `docs/context/working.md`

The state of play: what the code currently does, what the last wave completed, what the next wave is, and the handoffs between them.

Written for the agent that arrives with no history. A subagent picking up work reads this and nothing else about what came before — so it carries what was done and what it means for what comes next, never a transcript of how it was done.

No stable ids. Entries here are superseded rather than amended, and citing volatile state from a durable record would break the moment the code moved.

## Derive for meaning, not for letter

**A context entry is evidence of intent, not the authority on it.** Derivation reads the layer above for what it *means* in light of the question at hand, and never applies it verbatim.

The architect writes actual system context in their own register, about the system as a whole, without anticipating every fork it will later have to settle. A literal reading therefore fails constantly — *"users should never lose work"* says nothing verbatim about a specific fork and everything about it in meaning. An agent that derives only where the words match will escalate questions the context already answers, and the architect's interruption rate stops measuring anything useful.

So read for intent, and apply the intent. The same holds for an escalation's answer: interpret it into build context, do not transcribe it.

**The citation is what keeps this honest.** Interpretation is where an agent can rationalise anything, and the guard is not restraint — it is that every derived entry names what it derived from. `BLD-003` claiming to derive from `SYS-002` is a claim anyone can go and check — and that one is live, so go and check it. An interpretation nobody can inspect is indistinguishable from an invention, which is why an uncited entry is a defect no matter how sound its reasoning was.

Where the intent genuinely does not reach — not merely where the words don't — that is a gap, and it escalates.

## Deriving downward, never upward

A layer is built from the one above it and never from the one below. When working context reveals something that contradicts build context, that is not a correction to make in place — it is an escalation, because the derivation is what was wrong. The same holds one level up.

The failure this prevents is the quiet one: an agent notices reality has diverged from the plan, edits the plan to match reality, and destroys the record that a decision was ever made. After that nothing can tell a deliberate choice from an accident.
