---
name: implement
description: "Implement one unit of work: read it from working context, build to its criterion, record and commit."
disable-model-invocation: true
---

Work at **subagent tier** under `docs/agents/architect-mode.md`: decide what your own layer of context answers, escalate what it does not rather than guessing, and record each decision you take against the entry that authorised it.

**Read the unit you were dispatched for**, in `docs/context/working.md`. It carries four things and you need all of them: **Cited** (what authorised it), **Stated** (what to build), **Declared** (what you may read and write), **Criterion** (the bar it closes against).

*Until 2026-08-25 this skill read "implement the work described in the spec or tickets". `SYS-009` abolished tickets and `ADR-0002` put work in `working.md`; the skill had never been told.*

**The criterion is not yours to set.** It was fixed before you were dispatched, precisely so the agent doing the work cannot choose its own bar. If it cannot be met as written, escalate — do not reinterpret it.

**Stay inside Declared.** Writing a path the unit did not declare breaks the wave composition that put you here: the controller intersected declarations to decide what could run alongside you.

Use /tdd where possible, at pre-agreed seams.

Run typechecking regularly, single test files regularly, and the full test suite once at the end.

Once done, use /code-review to review the work.

**Write your forensic record into the unit's entry in `docs/context/working.md`**, then commit — the record and the change go in the same commit, because working context is superseded per wave and the commit is what makes the record durable (`ADR-0002`).
