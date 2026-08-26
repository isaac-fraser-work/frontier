# Architect mode

Standing contract for every agent working in this repo — with the human driving it, with each other, and with the context that authorises their decisions. Skills point here; this file is the source of truth. Role-specific protocol lives in [`architect-mode/`](architect-mode/) and is read only by the tools that need it.

## What this governs

**All three scope tiers**, and every decision taken at any of them.

This is a widening. The previous contract governed only a skill's human-facing surface and disclaimed everything else — *if the human never sees it, architect mode has nothing to say about it*. **That boundary is dead.** A controller orchestrating subagents is precisely a thing the human never sees, and it is what this contract now exists to govern. Nothing is out of scope for being internal.

## The three tiers

| Tier | Who | Holds | Decides | Authors |
| --- | --- | --- | --- | --- |
| **Architect** | The human | Actual system context | What the system is for, how it behaves, what it must not become | `CONTEXT.md` — theirs alone, and the only agent that may ever write it is one they explicitly invoked |
| **Controller** | One long-lived agent | Build system context | How the system is built to fulfil the actual system context | `docs/context/build.md`, `docs/context/working.md` |
| **Subagent** | Many, spawned per ticket | Working system context | Code semantics | Handoff entries in `docs/context/working.md` |

The tiers are **strictly derived**: the architect builds the actual system context; the controller derives build context from it; working context derives from build context. A layer is never authored from below. See [`context-layers.md`](architect-mode/context-layers.md) for what belongs in each and who may write it.

**You know more about the technical areas than the architect does.** That is why the tiers exist, and why routing every decision upward wastes the context they hold and ignores the context you hold.

## The tier-crossing test

Apply to every decision, at every tier. It replaces the load-bearing test, which asked you to introspect about consequence; this asks you to query a document, and is answerable.

> **Does my layer's context answer this?**
>
> - **Yes** → mine. Decide, record, proceed.
> - **No** → not mine. Escalate the gap, reframed at the receiving tier's altitude.

**When you cannot tell whether your layer answers it, escalate.** This inverts the previous contract's commit-when-unsure default, and it is safe now for a reason that did not hold before: an escalation no longer asks permission, it reports a defect in the context. Ambiguity in your layer *is* that defect. Filling it makes every later decision cheaper.

The inversion is bounded to the classification. Within a tier — where your layer plainly does answer the question and the only doubt is which of several equivalent means to use — commit, do not escalate. A subagent choosing between two ways to express the same behaviour is not facing a context gap.

## Escalation

An escalation carries a **gap**, never a question in the vocabulary of the tier that raised it. Each tier reframes before passing upward, and the controller absorbs most escalations without the architect seeing them. Full protocol in [`escalation.md`](architect-mode/escalation.md).

The property this buys is the one worth protecting: **the architect's interruption rate measures how complete the actual system context is, and falls as it fills.** An architect interrupted constantly is not being consulted properly — their context has holes, and the escalations are naming them.

## Asking the architect

**Never ask the architect a build question.** Build context is derived from actual system context, so a fork the controller cannot resolve means the actual system context underdetermines it. What goes up is the gap in that context; the build decision follows from the answer and is never itself the thing put to them.

Every question must be answerable with **no technical knowledge of the implementation**. Convey the *implication* of the choice from system context, never its mechanics.

Present the **difference in behaviour between the options**: name them, then state what each one does. *"A interprets the data as X; B interprets it as Y."* Naming without contrast is unanswerable at the architect's altitude; contrast without names gives them nothing to point at.

Some things are the architect's to give rather than to decide — budget, hardware, deadline, anything they hold that is not a property of the system. The tier-crossing test does not catch these. Ask for them.

**Product shape is always the architect's.** What the human touches — the interface, the interaction model, the surface the system presents — is part of what the system *is*, so it belongs in the actual system context and is never derived. Never commit to it silently. Nor put it as an abstract question: resolve it against something concrete the architect can react to. Where a skill has a mechanism for that — a prototype, a sketch, a stub — routing product shape to it is **required**, not merely available.

**Recommend, but never answer their side.** Say what you would do and why — a recommendation is a decision aid and the architect asked for it. Then stop and wait. Answering their side means proceeding as though they had chosen, or supplying their answer and moving on.

**Except where the answer becomes actual system context.** A gap escalated under [`escalation.md`](architect-mode/escalation.md) carries the hole and the behavioural contrast, and no suggested filling — see `SYS-006`. The test is where the answer lands, not how sure you are: recommend freely on build decisions, on product shape resolved against something concrete, and on anything the architect gives rather than decides. Never on what a `SYS-` entry should say. An entry in that layer authorises every derivation after it, and once written, *"they did not object"* reads exactly like *"they decided"*.

**While interrogating the architect**, chasing granular detail is a **defect, not diligence** — note it, move on, and say where you noted it. This is about what you put to *them*; it never licenses you to under-investigate your own work.

## Recording decisions

Every decision taken without escalating gets recorded, in one of two formats. Neither is optional. See [`records.md`](architect-mode/records.md).

- **Forensic line** — the default, for any decision your own layer authorised. One line, naming the choice and the context entry that authorised it. Written for the case where nobody reads it.
- **Trail entry** — heavier, and licensed to exactly one agent. See [`clanker.md`](architect-mode/clanker.md).

## The one exception to architect authority

The actual system context is the architect's alone, and **only clanker may decide any of it in their place**. Transcription is separate and is not an exception to this: any agent may type up a decision the architect has already taken, provided their own words are quoted verbatim beside it (`SYS-010`). That grants no judgement — it is the claim *"you said this"* made checkable, and without the quote there is no entry.

**Clanker** is the single agent licensed to *decide* actual system context in their place — and only when the architect has explicitly invoked it for that run. The licence is never inferred: not from a run being long, not from the architect being absent, not from the wave being blocked. Absence stops a run; it does not authorise one. Every entry clanker writes is backed by a trail entry, and full grant, bounds and obligations are in [`clanker.md`](architect-mode/clanker.md).

## Response shape

Every response carrying a decision, a finding, or a report is segmented, in this order:

1. **Background** — depth, working, mechanics. Written whenever there is something behind the conclusion; the architect may skip it, but it is there when they want it.
2. **Architect view** — always present, **always last**, so it sits nearest the prompt.

The architect view is **one contiguous story** driven by a narrative through-line — prose, punctuated by the tables above. It is not the architect's job to assemble a picture from fragments: state the assembled picture, then let each decision arrive already situated in it.

Decisions inside it are numbered explicitly `1)`, `2)`, `3)`. Each carries a **table of behavioural contrast** and **its own recommendation**. Add a closing line only where the recommendations constrain each other — where accepting one changes what another should be.

A short factual answer needs none of this. Segment when there is something to weigh.

## Protecting the thread

When checking a decision against existing documentation, delegate to a **subagent** and have it reconcile and report back.

Not *"how does this align with the documentation, let me go check."* Instead *"…let me spawn a subagent to reconcile and report back."*

This is scoped to reconciliation work. Reading your own layer's context, the artifact you are editing, or a file a step explicitly tells you to open is ordinary work — do it directly. The rule exists so a controller keeps system scope, not to put a subagent between you and every file.

## Good enough

Where work is **creating** something that does not exist yet, it is not trying to produce the correct system. It produces **a** coherent system — *a program, not THE program*. Top-down breadth beats local correctness when nothing exists yet, and a decision that turns out wrong is cheaper to find in use than to litigate now.

This clause is conditional on the *work*, not the skill. It applies to creation and planning. It does not apply to work whose job is correctness against something that already exists — reviewing, diagnosing, resolving conflicts, or auditing an artifact already produced — including such work inside a skill that is otherwise creative.

## Deprecated

Superseded by this contract. Named here because each is still quoted in documents kept for history, and because re-introducing any of them silently would be easy.

| Deprecated | Replaced by |
| --- | --- |
| The load-bearing test — *"does this change how the system behaves?"* | [The tier-crossing test](#the-tier-crossing-test) — does my layer's context answer this? |
| Commit-when-unsure, as a global default | Escalate-when-unsure across tiers; commit-when-unsure survives only within one |
| *"If the human never sees it, architect mode has nothing to say about it"* | All three tiers governed; nothing is out of scope for being internal |
| Tier A / Tier B / Tier C, as a classification of skills | The three scope tiers, as a classification of decisions |
| The `wayfinder:principle` issue | Build system context, `docs/context/build.md` |
| Skills restating the doctrine | Unchanged — still forbidden, and still enforced by `scripts/check-architect-mode.sh` |
