# Issue tracker: GitHub

> **Superseded as a work surface, 2026-08-19 (`SYS-009`).** Nothing arrives from outside the
> derivation, so **no unit of work is ever filed here.** Units live in
> `docs/context/working.md` — see [`ADR-0002`](../adr/0002-work-entry-model.md).
>
> This file survives as **tracker capability for the repository itself** — pull requests, and
> the `gh` invocations and proxy-CA workaround below. Read it as *how to talk to GitHub*, never
> as *where work goes*. The skills that filed work here (`to-spec`, `to-tickets`, `triage`) are
> retired in `skills/deprecated/`.

Issues and PRDs for this repo live as GitHub issues in
[`{{REPO_SLUG}}`](https://github.com/{{REPO_SLUG}}).
Use the `gh` CLI for all operations.

> **Auth prerequisite.** Every operation below needs a valid `gh` token. If a
> command fails with an auth error, run `gh auth status` — and if it reports an
> invalid token, `gh auth login -h github.com`. All traffic on this machine goes
> through an authenticating proxy at `localhost:3128`; if Go's TLS stack rejects
> the proxy CA, point `gh` at the system bundle with
> `export SSL_CERT_FILE=/etc/pki/tls/certs/ca-bundle.crt`.

## Conventions

- **Create an issue**: `gh issue create --title "..." --body "..."`. Use a heredoc for multi-line bodies.
- **Read an issue**: `gh issue view <number> --comments`, filtering comments by `jq` and also fetching labels.
- **List issues**: `gh issue list --state open --json number,title,body,labels,comments --jq '[.[] | {number, title, body, labels: [.labels[].name], comments: [.comments[].body]}]'` with appropriate `--label` and `--state` filters.
- **Comment on an issue**: `gh issue comment <number> --body "..."`
- **Apply / remove labels**: `gh issue edit <number> --add-label "..."` / `--remove-label "..."`
- **Close**: `gh issue close <number> --comment "..."`

Infer the repo from `git remote -v` — `gh` does this automatically when run inside a clone.

## Pull requests as a triage surface

**PRs as a request surface: no.** _(Set to `yes` if this repo treats external PRs as feature requests; `/triage` reads this flag.)_

## When a skill says "publish to the issue tracker"

Create a GitHub issue.

## When a skill says "fetch the relevant ticket"

Run `gh issue view <number> --comments`.

## Wayfinding operations

> **`/wayfinder` is deprecated** (`SYS-005`) and lives at `skills/deprecated/wayfinder/`.
> This section is kept because the **mechanisms** below outlive it — child issues, native
> dependency edges and the frontier query are the tracker scaffolding the harness reuses.
> Read it as tracker capability, not as method: nothing here authorises working in maps and
> tickets, and the harness adopts a mechanism on its own terms, recorded as build context.

The **map** is a single issue with **child** issues as tickets.

- **Map**: a single issue labelled `wayfinder:map`, holding the Destination / Notes / Decisions-so-far / Fog body. `gh issue create --label wayfinder:map`.
- **Principle issue**: a sibling of the map — a top-level issue labelled `wayfinder:principle`, **not** a child, so it never appears in the frontier query. `gh issue create --label wayfinder:principle`. Holds the chosen working principle, its consequences, and the rejected interpretations. Link it from the map's `## Notes` and link the map back from its body; revisions are edits to the body, with the reason left as a comment.
- **Child ticket**: an issue linked to the map as a GitHub sub-issue (`gh api` on the sub-issues endpoint). Where sub-issues aren't enabled, add the child to a task list in the map body and put `Part of #<map>` at the top of the child body. Labels: `wayfinder:<type>` (`research`/`prototype`/`grilling`/`task`). Once claimed, the ticket is assigned to the driving dev.
- **Blocking**: GitHub's **native issue dependencies** — the canonical, UI-visible representation. Add an edge with `gh api --method POST repos/{{REPO_SLUG}}/issues/<child>/dependencies/blocked_by -F issue_id=<blocker-db-id>`, where `<blocker-db-id>` is the blocker's numeric **database id** (`gh api repos/{{REPO_SLUG}}/issues/<n> --jq .id`, _not_ the `#number` or `node_id`). GitHub reports `issue_dependencies_summary.blocked_by` (open blockers only — the live gate). Where dependencies aren't available, fall back to a `Blocked by: #<n>, #<n>` line at the top of the child body. A ticket is unblocked when every blocker is closed.
- **Frontier query**: list the map's open children (`gh issue list --state open`, scoped to the map's sub-issues / task list), drop any with an open blocker (`issue_dependencies_summary.blocked_by > 0`, or an open issue in the `Blocked by` line) or an assignee; first in map order wins.
- **Claim**: `gh issue edit <n> --add-assignee @me` — the session's first write.
- **Resolve**: `gh issue comment <n> --body "<answer>"`, then `gh issue close <n>`, then append a context pointer (gist + link) to the map's Decisions-so-far.

## Label inventory

The `wayfinder:*` and triage labels this repo depends on are created by
`claude-init`. Re-run it in this directory to restore any that get deleted.

`wayfinder:principle` is **not** among them — it postdates `claude-init` and was added by
hand. Any repo running this fork of `/wayfinder` needs it created explicitly:

```bash
gh label create "wayfinder:principle" --color 3A1078 \
  --description "The working principle: chosen interpretation, consequences, rejected alternatives"
```
