#!/usr/bin/env bash
# Conformance check for architect mode.
#
# Verifies the invariants in docs/agents/architect-mode.md and its companions.
# Run it after touching anything under skills/ or docs/agents/.
#
# Two classes of finding, deliberately separated:
#
#   VIOLATION — wrong now. Fails the build.
#   PENDING   — un-migrated forked skill. Kept as a distinct LABEL for diagnosis,
#               but fatal since 2026-08-25. It stopped being advisory when the
#               migration finished.
#
# The split existed so the check stayed trustworthy while the fork sat
# half-migrated: a permanently-red check is one people stop reading, and it would
# have taken the real violations down with it.
#
# The migration completed 2026-08-19 and the count went to zero, at which point
# CLAUDE.md began asserting this script "enforces" the pointer and "fails on
# deprecated doctrine". Neither was true — pend never reached the exit code — so
# the claim and the behaviour disagreed for six days. Probed and corrected: a
# pend now counts as a violation. The label survives because "no pointer to
# contract" and "deprecated doctrine" are worth telling apart in the output.
#
# Exit 0 = no violations. Exit 1 = at least one violation.

set -uo pipefail
cd "$(dirname "$0")/.." || exit 1

CONTRACT="docs/agents/architect-mode.md"
COMPANIONS="docs/agents/architect-mode"
UPSTREAM="docs/skills/upstream"
fails=0
pends=0

# Pure reference: no actor, takes no decisions, never reports. Carries no pointer.
REFERENCE="codebase-design"
# Everything else has an actor at some tier and is governed.

# Retired. Not loaded, not invoked, therefore not governed — every check below skips it.
# Nesting under skills/deprecated/ already takes these out of the skills/*/ glob; the
# greps need telling separately. See skills/deprecated/README.md.
DEPRECATED_DIR="deprecated"
# Options only — they must precede the pattern, and any "--" that follows.
SKILL_GREP=(-r --exclude-dir="$DEPRECATED_DIR")

fail() { printf '  FAIL  %s\n' "$1"; fails=$((fails + 1)); }
pend() { printf '  pend  %s\n' "$1"; pends=$((pends + 1)); }
pass() { printf '  ok    %s\n' "$1"; }

is_reference() { case " $REFERENCE " in *" $1 "*) return 0;; *) return 1;; esac; }

# The harness owns skills/ and validates it. A scaffolded project reaches the
# same skills through .claude/skills, a symlink into archive/ — it does not own
# them, cannot fix them, and re-checking them there turns a green build red for
# something the project did not do. Checks preflight-9 are the harness's.
#
# Everything from check 10 on is about the project's OWN chain and runs everywhere.
if [ -d skills ] && [ ! -L skills ]; then IN_HARNESS=1; else IN_HARNESS=0; fi

# A project scaffolded five minutes ago has no CONTEXT.md, no build.md and no
# working.md, and that is correct: SYS-004 forbids scaffolding layer 1, and the
# rest derives from it. Failing on their absence turns the first run of every new
# project permanently red, which is the state this script's own header warns
# makes a check one people stop reading.
#
# An empty chain is a STATE, reported as such. The checks engage the moment the
# architect's first entry exists.
#
# CHAIN_STARTED is layer 1 and ONLY layer 1 — check 11 is the one thing entitled
# to read it. It used to gate check 15's suppression as well, which conflated
# "the architect has written CONTEXT.md" with "layers 2 and 3 exist". Writing the
# first entry then lifted suppression from two layers that had not been derived
# yet and from paths that only ever exist in the harness, and check 15 went from
# one finding to fourteen. Suppression is per-layer now: see expected_absent().
if [ -f CONTEXT.md ]; then CHAIN_STARTED=1; else CHAIN_STARTED=0; fi

# Actual-context ids do NOT all begin SYS-. That is the harness's own prefix;
# ADR-0003 makes every scaffolded run a project with its own chain, allocating
# its own prefix declared in RUN.md at init — precisely so a run's entries cannot
# collide with the SYS- ids of the doctrine symlinked into it (docs/agents/ids.md,
# "In a scaffolded run, the prefix is the run's"). Hard-coding SYS- in checks 11
# and 16 made both match nothing in every project except the harness, and a grep
# that matches nothing is not a check that passes — it is a check that is not run.
#
# Derived, never configured twice: RUN.md is the single declaration of the prefix
# and this reads it. No RUN.md means the harness itself, whose prefix is SYS-.
SYS_PREFIX="SYS-"
if [ -f RUN.md ]; then
  # Shape-checked rather than trusted. The value is spliced into grep patterns
  # below, and the scaffold ships RUN.md with an uninstantiated {{RUN_PREFIX}}
  # placeholder that must not be read as a real prefix.
  declared=$(sed -n 's/^\*\*Prefix:\*\*[[:space:]]*`\([^`]*\)`.*/\1/p' RUN.md | head -1)
  case "$declared" in
    ''|*[!A-Za-z0-9_-]*) ;;                  # absent, or not a bare id prefix
    *-) SYS_PREFIX="$declared" ;;
    *)  SYS_PREFIX="$declared-" ;;           # declared without its separator
  esac
fi

# The interpretation rule's grandfather window is a fact about the HARNESS's own
# history: SYS-001..SYS-016 were written before SYS-019 existed, and SYS-019's
# "Leaves open" leaves retrofitting them to the architect. A run scaffolded after
# SYS-019 has no such legacy — its very first entry is already subject to the
# rule — so the window is zero for any prefix but the harness's own. Keeping 16
# here unconditionally would skip UDSTANDRUN-001..016 in every run, i.e. silently
# turn check 16 off for exactly the projects it was generalised to reach.
if [ "$SYS_PREFIX" = "SYS-" ]; then GRANDFATHERED=16; else GRANDFATHERED=0; fi

if [ "$IN_HARNESS" -eq 0 ]; then
  echo "== 1-9. skill-set checks =="
  pass "skipped — these belong to the harness; this project links its skills from archive/"
fi

if [ "$IN_HARNESS" -eq 1 ]; then
echo "== 1. contract and companions exist =="
[ -f "$CONTRACT" ] && pass "$CONTRACT" || fail "$CONTRACT missing"
for c in context-layers escalation records clanker; do
  [ -f "$COMPANIONS/$c.md" ] && pass "$COMPANIONS/$c.md" || fail "$COMPANIONS/$c.md missing"
done

echo "== 2. contract's own companion links resolve =="
while read -r t; do
  [ -f "docs/agents/$t" ] && pass "contract -> $t" || fail "contract -> $t missing"
done < <(grep -o "](architect-mode/[a-z-]*\.md)" "$CONTRACT" | sed 's/](\(.*\))/\1/' | sort -u)
grep -q "architect-mode/" "$CONTRACT" || fail "contract points at no companions"

# Preflight, deliberately unnumbered so checks 1-9 keep the numbers the docs cite.
# A directory under skills/ with no SKILL.md is either a broken skill or a leftover:
# git will not remove a directory that still holds ignored content, so moving a skill
# away (e.g. deprecating one) strands an empty shell behind if anything like
# .claude/.cc-writes/ sits inside it. Caught once, here, with the fix named — the
# per-skill checks below would otherwise each trip over it separately and cryptically.
echo "== preflight: every skills/ entry is a skill =="
SKILLS=""
for d in skills/*/; do
  s=$(basename "$d")
  [ "$s" = "$DEPRECATED_DIR" ] && continue
  if [ -f "skills/$s/SKILL.md" ]; then
    SKILLS="$SKILLS $s"
  else
    fail "$s: directory under skills/ with no SKILL.md — delete it, or restore the file"
  fi
done
[ -n "$SKILLS" ] && pass "$(set -- $SKILLS; echo $# skills found)"

echo "== 3. governed skills point at the contract =="
for s in $SKILLS; do
  is_reference "$s" && continue
  if grep -q "docs/agents/architect-mode" "skills/$s/SKILL.md" 2>/dev/null; then
    pass "$s"
  else pend "$s: no pointer to contract"; fi
done

echo "== 4. reference-only skills carry no pointer =="
for s in $REFERENCE; do
  if grep -q "docs/agents/architect-mode" "skills/$s/SKILL.md" 2>/dev/null; then
    fail "$s: pointer present, should be reference-only"
  else pass "$s"; fi
done

echo "== 5. no skill restates the contract =="
# Phrases that must appear in the contract and nowhere else. A skill repeating
# one of these has copied doctrine instead of pointing at it.
while IFS= read -r phrase; do
  [ -z "$phrase" ] && continue
  hits=$(grep -l "${SKILL_GREP[@]}" -- "$phrase" skills/ 2>/dev/null)
  if [ -n "$hits" ]; then
    fail "doctrine restated: \"$phrase\""
    printf '        in: %s\n' $hits
  else pass "not restated: \"$phrase\""; fi
done <<'PHRASES'
Does my layer's context answer this
has not escalated — it has abdicated
forensic, not explanatory
A layer is never authored from below
PHRASES

echo "== 6. no skill carries deprecated doctrine =="
# Superseded by the three-tier model. Any hit is un-migrated, not merely stale.
# Phrases are deliberately narrow: "load-bearing" alone is ordinary English and
# appears legitimately (a minimal repro's load-bearing elements, a load-bearing
# reason). Only the doctrinal uses are matched — a check that cries wolf is a
# check people learn to skip.
while IFS= read -r phrase; do
  [ -z "$phrase" ] && continue
  hits=$(grep -l "${SKILL_GREP[@]}" -- "$phrase" skills/ 2>/dev/null)
  if [ -n "$hits" ]; then
    pend "deprecated doctrine: \"$phrase\""
    printf '        in: %s\n' $hits
  else pass "absent: \"$phrase\""; fi
done <<'DEPRECATED'
load-bearing test
load-bearing decision
wayfinder:principle
principle issue
more than one ticket per session
DEPRECATED

echo "== 7. invocation modes unchanged from upstream =="
for s in $SKILLS; do
  u="$UPSTREAM/$s/SKILL.md"
  [ -f "$u" ] || continue
  a=$(grep -c "^disable-model-invocation: true" "skills/$s/SKILL.md" 2>/dev/null || echo 0)
  b=$(grep -c "^disable-model-invocation: true" "$u" 2>/dev/null || echo 0)
  if [ "$a" = "$b" ]; then pass "$s"; else fail "$s: invocation mode changed ($b -> $a)"; fi
done

echo "== 8. edits are targeted, not rewrites =="
# A skill more than 60 lines longer than upstream has probably been rewritten
# rather than pointed.
for s in $SKILLS; do
  u="$UPSTREAM/$s/SKILL.md"
  [ -f "$u" ] || continue
  delta=$(( $(wc -l < "skills/$s/SKILL.md") - $(wc -l < "$u") ))
  if [ "$delta" -gt 60 ]; then fail "$s: +$delta lines — rewrite, not a targeted edit"; else pass "$s (+$delta)"; fi
done

echo "== 9. skill companion pointers resolve =="
for f in $(grep -lo "${SKILL_GREP[@]}" -- "](\([A-Z-]*\).md)" skills/ 2>/dev/null | sort -u); do
  d=$(dirname "$f")
  while read -r target; do
    if [ -f "$d/$target" ]; then pass "$(basename "$d") -> $target"; else fail "$(basename "$d") -> $target missing"; fi
  done < <(grep -o "](\([A-Z][A-Z-]*\).md)" "$f" | sed 's/](\(.*\))/\1/' | sort -u)
done

fi   # end of the harness-only skill-set checks

echo "== 10. every cited id is defined =="
# The scheme is load-bearing but nothing read it until now. This catches the
# mechanical half: an id referenced anywhere in the live derivation chain that
# names no entry. It cannot catch the other half — a citation to an entry that
# exists but does not reach the decision — which needs judgement and is
# /audit's job. A dangling citation is worse than none: it reads as derived.
#
# Fenced blocks are stripped first: an id inside ``` is a template placeholder,
# an id in prose is a claim. The 9xx block of every family is reserved for
# illustration, never allocated, and skipped here — so doctrine can show a
# format without asserting that a real entry exists.
ID_SCAN_DIRS="CONTEXT.md docs/context docs/adr docs/agents docs/skills/reconciliation.md skills"

defined=$(mktemp); referenced=$(mktemp)
{ grep -ho '^## SYS-[0-9]\{3\}' CONTEXT.md 2>/dev/null
  grep -ho '^## BLD-[0-9]\{3\}' docs/context/build.md 2>/dev/null
  # In a project, the symlinked doctrine cites the HARNESS's SYS-/BLD- ids. They
  # are defined in the reference copies the archive ships, never in the project's
  # own layers — which carry the run's prefix instead (ADR-0003). Without this the
  # contract dangles every citation it makes, which is the defect the archive was
  # built to close rather than relocate.
  grep -ho '^## SYS-[0-9]\{3\}' docs/agents/harness-context.md 2>/dev/null
  grep -ho '^## BLD-[0-9]\{3\}' docs/agents/harness-build.md 2>/dev/null
} | sed 's/^## //' | sort -u > "$defined"

find $ID_SCAN_DIRS -name '*.md' -not -path '*/deprecated/*' -not -path '*/upstream/*' \
     -not -path '*/history/*' 2>/dev/null | while read -r f; do
  awk '/^```/{fence=!fence; next} !fence' "$f"
done | grep -o '\(SYS\|BLD\)-[0-9]\{3\}' | grep -v -- '-9[0-9][0-9]$' | sort -u > "$referenced"

dangling=$(comm -13 "$defined" "$referenced")
if [ -n "$dangling" ]; then
  for d in $dangling; do fail "cited but not defined: $d"; done
else
  pass "$(wc -l < "$defined" | tr -d ' ') ids defined, every citation resolves"
fi
rm -f "$defined" "$referenced"

echo "== 11. every ${SYS_PREFIX} entry carries a verbatim record =="
if [ "$CHAIN_STARTED" -eq 0 ]; then
  pass "no CONTEXT.md yet — the chain has not started; /context writes the first entry"
else
# The criterion for the /context unit (docs/context/working.md), made executable
# per BLD-011 — the criterion and its enforcement are the same artifact, so the
# checkpoint cannot pass by assertion.
#
# SYS-010: an agent may write an entry in this layer only where the architect's
# own words are quoted verbatim alongside it. An entry with no record is either
# authored by an agent or unattributable, and the two are indistinguishable
# afterwards. This is the only guard on the one layer with nothing above it.
missing=0
entries=0
# Fed by process substitution, NOT by a here-doc wrapped round a command
# substitution. `<<EOF ... $(grep) ... EOF` with a grep that matches nothing is
# not an empty input: the here-doc still holds one blank line, so the loop runs
# once with an empty id and reports a failure against an entry that does not
# exist. That is what produced "FAIL : no verbatim record" with no id in front of
# it. Process substitution yields zero lines for zero matches, which is the state
# actually being described.
while read -r id; do
  entries=$((entries + 1))
  # The record must appear before the next entry begins. index()==1 rather than a
  # regex so the prefix is matched literally and never has to be escaped.
  block=$(awk -v id="$id" -v pfx="$SYS_PREFIX" '
    index($0, "## " id " ") == 1 {inblock=1; next}
    inblock && index($0, "## " pfx) == 1 {exit}
    inblock {print}
  ' CONTEXT.md)
  if printf '%s' "$block" | grep -q '^\*\*Record\*\*'; then
    :
  else
    fail "$id: no verbatim record (SYS-010)"
    missing=$((missing + 1))
  fi
done < <(grep -o "^## ${SYS_PREFIX}[0-9]\{3\}" CONTEXT.md | sed 's/^## //')
if [ "$entries" -eq 0 ]; then
  # Zero entries under the declared prefix is not the same as zero entries. If
  # CONTEXT.md carries headings that this prefix does not match, the prefix is
  # wrong — and passing quietly would hide the very defect this generalisation
  # exists to remove, leaving check 11 green while enforcing nothing.
  if grep -q '^## ' CONTEXT.md; then
    fail "CONTEXT.md holds entries, none matching the prefix ${SYS_PREFIX} — check the Prefix declared in RUN.md"
  else
    pass "CONTEXT.md exists but holds no entries yet"
  fi
elif [ "$missing" -eq 0 ]; then
  pass "$entries entries, every one recorded"
fi

fi

echo "== 12. every unit of work is well-formed =="
# ADR-0002 gives a unit four tests, and wave 1 found the third failing on the
# first unit ever written: it under-declared its reads. A malformed unit is
# cheapest to catch at derivation time, which is what this does.
#
# What it CANNOT reach, and BLD-013 records: whether a Declared block is
# COMPLETE. Nothing can observe what an agent read. This checks the four tests
# are present, not that their contents are true.
WORKING="docs/context/working.md"
if [ -f "$WORKING" ]; then
  units=0; bad=0
  while IFS= read -r unit; do
    units=$((units + 1))
    block=$(awk -v u="$unit" '
      $0 == u {inblock=1; next}
      inblock && /^### Unit/ {exit}
      inblock && /^## / {exit}
      inblock {print}
    ' "$WORKING")
    for t in "Cited" "Stated" "Declared" "Criterion"; do
      printf '%s' "$block" | grep -q "^\*\*$t" || {
        fail "${unit#### }: no **$t** (ADR-0002)"; bad=$((bad + 1))
      }
    done
  # Same here-doc-round-a-command-substitution bug as check 11 had: a working.md
  # with no units yet fed one blank line, counted it as a unit, and reported four
  # missing tests against it. The `units -eq 0` branch below was unreachable.
  done < <(grep '^### Unit' "$WORKING")
  if [ "$units" -eq 0 ]; then
    pass "no units derived"
  elif [ "$bad" -eq 0 ]; then
    pass "$units units, all four tests present on each"
  fi
else
  pass "no working context yet"
fi

echo "== 13. layer 0 is generated, not written =="
# SYS-013 confines layer 0 to tool selection. BLD-014 makes that structural by
# generating it: knowledge smuggled into docs/context/tools.md by hand does not
# survive regeneration, and this fails the build the moment the two differ.
#
# The guarantee is the point. A hand-maintained index would depend on ring
# declining to write down what it learns, and no document enforces anything
# (BLD-012).
if [ -f docs/context/tools.md ]; then
  if [ -x scripts/gen-tools-index.sh ]; then
    if diff -q <(bash scripts/gen-tools-index.sh --check) docs/context/tools.md >/dev/null 2>&1; then
      pass "docs/context/tools.md matches a fresh generation"
    else
      fail "docs/context/tools.md differs from a fresh generation — run scripts/gen-tools-index.sh"
    fi
  else
    fail "scripts/gen-tools-index.sh missing or not executable"
  fi
else
  pass "layer 0 not generated yet"
fi

echo "== 14. CLAUDE.md carries the rules that bind before any skill fires =="
# BLD-012 sites an instruction by when it must be known, and two of them must be
# known on a turn where nothing has been fetched yet:
#
#   BLD-017 — git operations are bookkeeping. An agent deciding whether to ask
#             permission to commit has not loaded build.md.
#   SYS-014 — a decision put to the architect carries a number, and the numbering
#             resets at each fork. It binds the turn on which the decision is put,
#             including one where no skill fires.
#
# BLD-018 rejected pointing at CONTEXT.md for these: a pointer is a fetch, so the
# anchors below are the rules' own words, not their ids — a line that cites the
# entry and states nothing is the carriage that was rejected.
#
# What this cannot reach is whether an agent then obeys what it read. Nothing in
# this repo can, and it is left outside the criterion rather than smuggled in.
ALWAYS_LOADED="CLAUDE.md"
if [ -f "$ALWAYS_LOADED" ]; then
  while IFS='|' read -r entry anchor; do
    [ -z "$entry" ] && continue
    if grep -qi -- "$anchor" "$ALWAYS_LOADED"; then
      pass "$entry: \"$anchor\""
    else
      fail "$entry not carried by $ALWAYS_LOADED: no \"$anchor\" (BLD-018)"
    fi
  done <<'CARRIERS'
BLD-017|Git operations are bookkeeping
BLD-017|content versus carriage
SYS-014|explicit number
SYS-014|resets at each decision fork
CARRIERS
else
  fail "$ALWAYS_LOADED missing — the always-loaded layer carries nothing"
fi

if [ "$GRANDFATHERED" -gt 0 ]; then
  echo "== 16. every entry after $(printf '%s%03d' "$SYS_PREFIX" "$GRANDFATHERED") carries an interpretation =="
else
  echo "== 16. every entry carries an interpretation =="
fi
# SYS-019: an entry carries the architect's words AND the reading taken of them,
# marked as the agent's. SYS-010 already forced the quote and check 11 enforces
# it; neither made the READING visible, so an entry could quote faithfully and
# still rest on an interpretation nobody could see.
#
# From SYS-017 only. SYS-019's "Leaves open" leaves retrofitting the earlier
# sixteen to the architect, so this must not fail on them.
if [ -f CONTEXT.md ]; then
  missing_interp=0
  while read -r id; do
    n=${id#"$SYS_PREFIX"}
    # 10# forces decimal so 008 is not read as octal. It is also why the blank
    # iteration the here-doc used to produce was fatal rather than merely wrong:
    # "10#" with nothing after it is an arithmetic syntax error, and the script
    # died here with `10#: invalid integer constant` instead of reporting.
    [ "$((10#$n))" -le "$GRANDFATHERED" ] && continue
    block=$(awk -v u="## $id" '
      $0 ~ "^"u {inblock=1; next}
      inblock && /^## / {exit}
      inblock {print}
    ' CONTEXT.md)
    if printf '%s' "$block" | grep -q '^\*\*Interpretation\*\*'; then
      pass "$id"
    else
      fail "$id: no **Interpretation** (SYS-019)"
      missing_interp=$((missing_interp + 1))
    fi
  done < <(grep -o "^## ${SYS_PREFIX}[0-9]\{3\}" CONTEXT.md | sed 's/^## //')
  [ "$missing_interp" -eq 0 ] || true
else
  pass "no CONTEXT.md yet — the chain has not started"
fi

echo "== 15. every repo-relative path a skill or doc cites resolves =="
# Check 10 does this for ids; nothing did it for paths, and two dangled unnoticed:
# skills/diagnosing-bugs cited scripts/hitl-loop.template.sh while the file sat in
# skills/diagnosing-bugs/scripts/, and all 21 links in docs/skills/reference/index.md
# pointed at ./name/SKILL.md against flat name.md pages. Check 9 could not see either
# — it matches only same-directory UPPERCASE links.
#
# Two citation forms are scanned: markdown links, and backticked paths that start at
# a repo root directory. Fenced blocks are stripped, on check 10's reasoning: a path
# inside ``` is a template, a path in prose is a claim.
#
# Skipped deliberately: docs/context/trail.md, absent by design and guarded in place
# by skills/audit/SKILL.md:55; and anything holding nnnn/NNNN/<> which is a format
# placeholder, not a citation.
# harness-*.md are READ-ONLY REFERENCE copies of the harness's own layers. Their
# internal citations are the harness's and resolve there, not here — scanning them
# from a project reports the harness's whole tree as missing.
path_scan_dirs="docs/agents docs/skills skills"
path_scan_excl="-not -name harness-context.md -not -name harness-build.md"
missing_paths=0

# The doctrine cites the layers it is ABOUT, and those layers are DERIVED — each
# comes into existence at a different point in a run's life, layer by layer. A
# citation to one of them is expected first-run state only while THAT layer is
# still absent. The moment the layer exists, an unresolved citation into it is a
# real broken reference and must be reported.
#
# This used to hang off the single CHAIN_STARTED flag, so the architect writing
# CONTEXT.md — layer 1, and nothing else — lifted suppression from layers 2 and 3,
# which by design are not derived until later. Fourteen expected absences were
# reported as defects in one step.
#
# Keyed per layer, and never to one global flag:
#
#   CONTEXT.md              layer 1  — keyed to CONTEXT.md
#   docs/context/build.md   layer 2  — keyed to docs/context/build.md
#   docs/context/working.md layer 3  — keyed to docs/context/working.md
#   docs/adr/..., docs/observations/...  the HARNESS's own history — keyed to
#                           IN_HARNESS, checked there, not a project's to answer for
#
# The three layer files are keyed to themselves rather than to docs/context/,
# because layer 0 (docs/context/tools.md) is GENERATED at the start of every run.
# That directory therefore exists from minute one and says nothing whatever about
# whether layers 2 and 3 have been derived. Each is suppressed exactly until the
# file it names exists, and checked from that moment on.
#
# The ADR and observation arms cannot be keyed on the directory: the scaffold
# creates docs/adr/ and docs/observations/ empty, holding only .gitkeep, so their
# existence is a fact about scaffolding and not about anything having been
# derived. Nor are these citations the project's to answer for. They are made by
# doctrine under docs/agents/, which in a project is symlinked read-only out of
# archive/, and they name the harness's own ADRs and observations — files that
# live in the harness and are never copied into a run. This is the rule the
# script already applies twice: checks 1-9 are skipped in a project because it
# does not own skills/, and harness-*.md is excluded from this very scan because
# "their internal citations are the harness's and resolve there, not here".
# Re-checking them in a project turns a green build red for something the project
# did not do and cannot fix.
#
# This is emphatically not suppression-always-on. IN_HARNESS is 1 in the harness,
# where these citations must resolve and where a mistyped ADR filename fails the
# build. The same holds locally for a mistyped docs/context/bulid.md: it matches
# no arm below and is checked from the moment it is written.
#
# ../ forms are matched as well as root-relative ones: doctrine under docs/agents/
# cites ../adr/nnnn-slug.md, and a skill two levels down cites ../../docs/adr/... .
# Both name the same thing and are keyed to the same thing.
expected_absent() {
  case "$1" in
    CONTEXT.md)                                   [ ! -e CONTEXT.md ] ;;
    docs/context/build.md|*/context/build.md)     [ ! -e docs/context/build.md ] ;;
    docs/context/working.md|*/context/working.md) [ ! -e docs/context/working.md ] ;;
    docs/context|docs/context/|*/context/)        [ ! -d docs/context ] ;;
    docs/adr|docs/adr/*|*/adr/*)                  [ "$IN_HARNESS" -eq 0 ] ;;
    docs/observations/*|*/observations/*)         [ "$IN_HARNESS" -eq 0 ] ;;
    *) false ;;
  esac
}
while read -r citation; do
  f="${citation%%|*}"; t="${citation#*|}"
  case "$t" in
    *nnnn*|*NNNN*|*'<'*|*'$'*|docs/context/trail.md) continue ;;
  esac
  # A layer that has not been derived yet is expected state, not a broken
  # reference — but only until that layer itself exists.
  expected_absent "$t" && continue
  case "$t" in
    docs/*|scripts/*|bin/*|CONTEXT.md) resolved="$t" ;;
    /*|http*) continue ;;
    *) resolved="$(dirname "$f")/$t" ;;
  esac
  # In a project, skills are reached through .claude/skills, not skills/.
  if [ ! -e "$resolved" ]; then
    case "$resolved" in
      *skills/*) alt="${resolved#*skills/}"; [ -e ".claude/skills/$alt" ] && continue ;;
    esac
  fi
  if [ ! -e "$resolved" ]; then
    fail "$f cites $t — does not resolve"
    missing_paths=$((missing_paths + 1))
  fi
done <<EOF
$(find $path_scan_dirs -name '*.md' -not -path '*/deprecated/*' -not -path '*/upstream/*' \
       -not -path '*/history/*' $path_scan_excl 2>/dev/null | while read -r f; do
    awk '/^```/{fence=!fence; next} !fence' "$f" \
      | grep -oE '\]\([^)#][^)]*\.(md|sh)\)|`(docs|scripts|bin)/[A-Za-z0-9._/-]+`|`CONTEXT\.md`' \
      | sed -e 's/^](//' -e 's/)$//' -e 's/^`//' -e 's/`$//' \
      | sort -u | while read -r t; do printf '%s|%s\n' "$f" "$t"; done
  done)
EOF
[ "$missing_paths" -eq 0 ] && pass "every cited path resolves"

echo
[ "$pends" -gt 0 ] && echo "$pends pending — a pend is a regression, not leftover work (CLAUDE.md); counted as a violation"
if [ "$((fails + pends))" -eq 0 ]; then
  echo "CONFORMANT"
  exit 0
else
  echo "$((fails + pends)) violation(s)"
  exit 1
fi
