# JJ Cheat Sheet

## Core concepts

`@` is the working change. `@-` is its parent, often the commit you just made after `jc`.

A JJ bookmark is like a Git branch. `trunk()` means the main or master branch.
In zsh, quote it when typing commands: `'trunk()'`.

There is no staging area. Edit files, then use `jc` to commit or `jj describe` to update the current change message.

`jp` uses force-with-lease safety by default. If push refuses, fetch first, fix the bookmark, then push again.

## Aliases

| cmd | what |
|-----|------|
| `jst` | status |
| `jd` | diff |
| `jl` / `jlr` | log / `jj lr` |
| `jjlt [n]` | trunk log, default 10 |
| `jf` / `jp` | fetch / push |
| `jn` / `jc` | new / commit |
| `jrt` | new change from trunk: `jj new 'trunk()'` |
| `jjpb` | nearest ancestor bookmark |
| `jjub [rev]` | move that bookmark, default `@` |

## Git → JJ command map

### Status, diff, log

| git | jj |
|-----|-----|
| `git status` | `jst` |
| `git diff` | `jd` |
| `git diff HEAD~1` | `jd -r @-` |
| `git diff A B` | `jj diff --from A --to B` |
| `git show` | `jj show <rev>` |
| `git log --oneline` | `jl` or `jj log -r ::@` |
| `git log --all` | `jj log -r 'all()'` |
| `git blame file` | `jj file annotate file` |

### Files, no staging

| git | jj |
|-----|-----|
| `git add file` | edit `file`; it is auto-tracked in the working copy |
| `git rm file` | `rm file` |
| `git rm --cached` | `jj file untrack file`, then add an ignore pattern |
| `git restore file` | `jj restore file` |
| `git checkout HEAD -- file` | `jj restore file` |

### Commit

| git | jj |
|-----|-----|
| `git commit -am "msg"` | `jc -m "msg"` |
| `git commit --amend` | `jj squash`, then maybe `jj describe` |
| `git commit --amend --only` | `jj describe -m "msg"` |
| amend previous commit message | `jj describe @- -m "msg"` |
| empty commit or message tweak | `jj describe -m "msg"` |

### Fetch, pull, push

| git | jj |
|-----|-----|
| `git fetch` | `jf` |
| `git push` | `jp --bookmark <name>` |
| `git push -u origin branch` | `jp --bookmark branch` |
| `git push --all` | `jp --all` |
| `git push --force-with-lease` | `jp --bookmark <name>` |
| `git push --force` | fetch, fix bookmark conflict, then `jp`; avoid bare force |
| `git pull` with rebase | `jf`, then `jj rebase -b <bookmark> -d 'trunk()'` |
| `git pull` with merge | `jf`, then `jj new @ <bookmark>@origin` |

### Branches become bookmarks

| git | jj |
|-----|-----|
| `git branch` | `jj bookmark list` or `jj b l` |
| `git branch -a` | `jj bookmark list --all-remotes` |
| `git branch -r` | `jj bookmark list --remote origin` |
| `git branch feature` | `jj bookmark create feature -r @` |
| `git branch -f feature <rev>` | `jj bookmark move feature --to <rev>` or `jjub <rev>` |
| `git branch -m old new` | `jj bookmark rename old new` |
| `git branch -d feature` | `jj bookmark delete feature` |
| `git switch -c topic main` | `jn main`, then `jj bookmark create topic -r @` |

### Switch or checkout

| git | jj |
|-----|-----|
| `git switch feature` | `jj edit feature` |
| `git checkout feature` | `jj edit feature` |
| `git checkout -b topic main` | `jn main`, work, then `jj bookmark create topic -r @-` |
| `git checkout main` just to inspect | `jj new main --no-edit` or `jj show main` |
| `git stash` | `jn @-`; old work stays as a sibling |
| `git stash pop` | `jj edit <stashed-change-id>` |

Prefer `jj edit` when resuming an existing branch. Use `jn <parent>` when starting new work on top of another change.

### Merge

| git | jj |
|-----|-----|
| `git merge other` | `jj new @ other` |
| merge conflict | fix files, then `jj resolve` or `jj squash` |

A JJ merge is a new change with two parents.

### Rebase

| git | jj |
|-----|-----|
| `git rebase main` | `jj rebase -b @ -d 'trunk()'` or `jj rebase -b my-branch -d 'trunk()'` |
| `git rebase main feature` | `jj rebase -b feature -d 'trunk()'` |
| `git rebase --onto B A` | `jj rebase -s <revs> -o B` |
| `git rebase -i` reorder | `jj rebase -r … --before/after …` or `jj arrange` |
| update remote after rebase | `jjub`, then `jp --bookmark …` |

### Squash, split, fixup

| git | jj |
|-----|-----|
| squash into parent | `jj squash` |
| squash interactively | `jj squash -i` |
| squash change X into Y | `jj squash --from X --into Y` |
| soft reset | `jj squash --from @-` |
| `git commit -p` or split commit | `jj split` or `jj split -i` |
| fixup / autosquash | `jj squash --into <target>` |

### Reset and discard

| git | jj |
|-----|-----|
| `git reset --soft HEAD~` | `jj squash --from @-` |
| `git reset --hard` | `jj abandon` or `jj restore` to empty current change |
| drop a commit | `jj abandon <rev>` |
| undo last JJ command | `jj undo` |

### Cherry-pick and revert

| git | jj |
|-----|-----|
| `git cherry-pick <rev>` | `jj duplicate <rev> -o @` |
| `git revert <rev>` | `jj revert -r <rev> -B @` |

### Tags and remotes

| git | jj |
|-----|-----|
| `git tag` | `jj tag list` or `jj tag set -r <rev>` |
| `git remote -v` | `jj git remote list` |
| `git remote add` | `jj git remote add` |

## Recommended habits

Use `jj edit <bookmark>` to resume existing work. Use `jn <parent>` to start a new change from a known base.

After `jc`, move the bookmark to the new committed change with `jjub @-`.

After a describe-only update, move the bookmark with `jjub`.

If push refuses, run `jf`, inspect the bookmark conflict, move the bookmark deliberately, then push again.

Use `jj undo` when the last JJ command did something unexpected.

## PR workflows

### New PR

```sh
jj git clone <url> && cd <repo> && jf
jrt
# edit → jst / jd
jc -m "msg"
jj bookmark create my-branch -r @-
jp --bookmark my-branch && gh pr create
```

### Update PR

```sh
jj edit my-branch
# edit → jst / jd
jc -m "msg"
jjub @-
jp --bookmark my-branch
```

### Describe-only update

```sh
jj describe -m "msg"
jjub
jp --bookmark my-branch
```

### Trunk moved

```sh
jf
jj rebase -b my-branch -d 'trunk()'
jp --bookmark my-branch
```

### Conflicts

```sh
jst
# fix files
jj resolve
jp --bookmark my-branch
```

## Rules and troubleshooting

After `jc`, run `jjub @-`. After describe-only changes, run `jjub`.

For conflicts, fix files, then run `jj resolve`. If you need to fold the resolution into another change, use `jj squash`.

For push failures, fetch before retrying. Do not use a bare force push; move the bookmark intentionally and use `jp`.
