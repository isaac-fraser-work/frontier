# Layer 0 — tools

**Generated. Do not edit.** Run `scripts/gen-tools-index.sh`; check 13 fails the build if this
file and a fresh generation differ.

Which tool, and what for. Nothing else belongs here — not what the system does, not how any tool
works, not a route from a question to an answer. See
[`architect-mode/context-layers.md`](../agents/architect-mode/context-layers.md) for why layer 0
is orthogonal to the derivation chain rather than above it, and `SYS-013` for the confinement.

A tool's operating detail is loaded on demand by a subagent and never retained here.

| Tool | Invocation | What for |
| --- | --- | --- |
| `/audit` | model or user | Audit the system context an agent decided in your absence — which entries still hold, which were guesses, and what got built on the ones that were wrong. |
| `/codebase-design` | model or user | Shared vocabulary for designing deep modules. Use when the user wants to design or improve a module's interface, find deepening opportunities, decide where a seam goes, make code more testable or AI-navigable, or when another skill needs the deep-module vocabulary. |
| `/code-review` | model or user | Review the changes since a fixed point (commit, branch, tag, or merge-base) along two axes — Standards (does the code follow this repo's documented coding standards?) and Spec (does the code match what the originating issue/PRD asked for?). Runs both reviews in parallel sub-agents and reports them side by side. Use when the user wants to review a branch, a PR, work-in-progress changes, or asks to "review since X". |
| `/context` | model or user | Interview the architect and record what they decide as actual system context. Only they decide; this writes down what they said, quoted. |
| `/courier` | model or user | Answer what another run established, without either run holding the other's context. Reads any run's layers, returns a cited briefing, and never writes anything anywhere. |
| `/diagnosing-bugs` | model or user | Diagnosis loop for hard bugs and performance regressions. Use when the user says "diagnose"/"debug this", or reports something broken/throwing/failing/slow. |
| `/domain-modeling` | model or user | Build and sharpen a project's domain model. Use when the user wants to pin down domain terminology or a ubiquitous language, record an architectural decision, or when another skill needs to maintain the domain model. |
| `/frontier-control` | model or user | Hold build context, derive units of work from it, compose waves, dispatch subagents, and absorb their escalations so the architect sees only genuine holes. |
| `/grilling` | model or user | Grill the user relentlessly about a plan, decision, or idea. Use when the user wants to stress-test their thinking, or uses any 'grill' trigger phrases. |
| `/grill-with-docs` | user only | A relentless interview to sharpen a plan or design, which also creates docs (ADR's and glossary) as we go. |
| `/implement` | user only | Implement one unit of work: read it from working context, build to its criterion, record and commit. |
| `/prototype` | model or user | Build a throwaway prototype to answer a design question. Use when the user wants to sanity-check whether a state model or logic feels right, or explore what a UI should look like. |
| `/research` | model or user | Investigate a question against high-trust primary sources and capture the findings as a Markdown file in the repo. Use when the user wants a topic researched, docs or API facts gathered, or reading legwork delegated to a background agent. |
| `/resolving-merge-conflicts` | model or user | Use when you need to resolve an in-progress git merge/rebase conflict. |
| `/ring` | user only | The way in. Work out what the architect needs, pick the tool for it, and hand the job to an agent that runs it — never running it yourself. |
| `/tdd` | model or user | Test-driven development. Use when the user wants to build features or fix bugs test-first, mentions "red-green-refactor", or wants integration tests. |

_16 tools. Retired skills live in `skills/deprecated/` and are not listed: they are not loaded, so they are not selectable._
