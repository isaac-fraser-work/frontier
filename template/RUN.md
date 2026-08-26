# Run: {{PROJECT_NAME}}

**Prefix:** `{{RUN_PREFIX}}-`
**Created:** {{DATE}}
**Status:** open

One `/ring` invocation, one project ([`ADR-0003`]({{FRONTIER_REPO}}/docs/adr/0003-run-as-project.md)).
This run holds a complete derivation chain and inherits nothing from any other.

## Its layers

| Layer | File | Lifetime |
| --- | --- | --- |
| Layer 0 — tools | `docs/context/tools.md` | Regenerated at the start of every run |
| Actual | `CONTEXT.md` | Durable within this run |
| Build | `docs/context/build.md` | Revised when actual changes |
| Working | `docs/context/working.md` | Volatile — current state only |

## Its ids

Entries here are `{{RUN_PREFIX}}-001`, `{{RUN_PREFIX}}-BLD-001`, and so on. The prefix is unique
across `runs/`, so another run may cite one of these without qualifying it.

## Reaching other runs

Nothing here derives from another run. Where this run needs what another established, it asks
`courier` — read-only, spawned per query, returns a cited briefing. It never inherits, and it
never resolves a conflict between two runs' actual context.

## Artefacts

`artefacts/` holds what this run produced. Provenance is the path: the run that made a file is
where the file lives.
