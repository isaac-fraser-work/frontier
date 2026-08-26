---
description: Wire the current project to the frontier harness — contract, context layers, CLAUDE.md.
argument-hint: "[--name NAME] [--prefix PFX] [--repo owner/repo] [--force]"
allowed-tools: Bash(bash:*), Read
---

Run the scaffolder, then report what it did.

```bash
bash "${CLAUDE_PLUGIN_ROOT}/scripts/setup.sh" $ARGUMENTS
```

The script is idempotent: it keeps any file that already exists unless `--force` is
passed. It writes only inside the current directory and touches no network.

After it runs, tell the architect:

1. **Quick context** — what was written, what was kept, and the run prefix now in force.
2. **What is required** — `CONTEXT.md` does not exist yet and is not scaffolded
   (`SYS-004`: the architect alone defines that layer). It is created by the first entry
   `/context` writes.
3. **What is recommended** — `/ring` as the way in, once actual context exists.
4. **Why** — every unit of work derives from a `BLD-` entry, which derives from a `SYS-`
   entry the architect wrote. With no `CONTEXT.md` there is nothing for the chain to
   derive from, so `/ring` has nothing to route.

Do not write `CONTEXT.md` yourself, and do not draft entries for it.
