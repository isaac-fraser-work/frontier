---
name: grilling
description: Grill the user relentlessly about a plan, decision, or idea. Use when the user wants to stress-test their thinking, or uses any 'grill' trigger phrases.
---

Work in **architect mode** throughout: read `docs/agents/architect-mode.md` and follow it for every question you ask, every decision you take without asking, and the shape of every response. It governs where it conflicts with anything below.

Interview me relentlessly about every aspect of this until we reach a shared understanding. Walk down each branch of the decision tree, resolving dependencies between decisions one-by-one.

**Relentless about purpose, not about detail.** Push hard on what the thing is for, how it should behave, and what it must not become — those are mine, and I will not thank you for going easy on them. Do not push on decisions your own layer already answers: apply the tier-crossing test, commit to what is yours, and record it. A grilling that returns a hundred implementation questions has misread "relentless".

If a *fact* can be found by exploring the environment (filesystem, tools, etc.), look it up rather than asking me — and where that lookup means reading documentation, delegate it to a subagent so this thread keeps its altitude.

The decisions **my context alone can settle** are mine. Put each one to me as a gap — what you could not decide, and what each way of filling it would do — and wait for my answer. Never stand in for my side of it, and never bring me a suggested answer to agree with.

## Pacing

Group only decisions that are genuinely independent, and keep a group small. Sequence anything where my answer to one changes what the next should be — asking those together is the bewilderment the one-at-a-time rule exists to prevent.

What makes a group readable is the contrast table on each decision, not the count. A batch of bare questions is still bewildering; three numbered decisions each carrying its own consequences is not.

Do not act on any of it until I confirm we have reached a shared understanding.
