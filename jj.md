# JJ Workflow

This is the `jj` version of the old basic Git flow:

```txt
clone repo -> create branch -> edit -> git add -> commit -> push -> PR -> rebase if main moved
```

With `jj`, the flow becomes:

```txt
clone repo -> create a change -> edit -> commit/describe -> bookmark -> push -> PR -> rebase if main moved
```

## Mental Model

`jj` does not use Git's staging area as the center of the workflow.

The current working copy is always a real `jj` change:

```txt
@   = current working change
@-  = previous change
```

After `jj commit`, `jj` leaves you on a new empty `@`, and the real committed work is usually at `@-`.

A `jj` bookmark is the thing that maps to a Git branch on GitHub.

## Existing Aliases

These are already in `.zshrc`:

```sh
jst   # jj status
jd    # jj diff
jf    # jj git fetch
jn    # jj new
jc    # jj commit
jp    # jj git push
jl    # jj log
jjub  # move the current bookmark found by jjpb
```

Do not rely on this one yet:

```sh
jrt   # jj retrunk
```

Your installed `jj` does not currently have a `retrunk` command.

## Start Work

Clone:

```sh
jj git clone <repo-url>
cd repo
```

Fetch latest remote state:

```sh
jf
```

Start a new change from trunk:

```sh
jn trunk()
```

Now edit files normally.

## Check Work

Status:

```sh
jst
```

Diff:

```sh
jd
```

Log:

```sh
jl
```

## Commit Work

Commit the current change:

```sh
jc -m "message"
```

After this, `@` is usually empty and the real committed change is at `@-`.

Create a bookmark for the PR branch:

```sh
jj bookmark create my-branch -r @-
```

Push it:

```sh
jp --bookmark my-branch
```

Create the PR:

```sh
gh pr create
```

## Update An Existing PR

Edit the PR change:

```sh
jj edit my-branch
```

Make changes, then check:

```sh
jst
jd
```

If you want to commit and move back to an empty `@`:

```sh
jc -m "message"
jjub @-
jp --bookmark my-branch
```

If you are still on the same change and only changed its content/message:

```sh
jj describe -m "message"
jjub @
jp --bookmark my-branch
```

Rule:

```txt
After jc, move/push @-
Before jc, move/push @
```

## When Trunk Moved

Fetch:

```sh
jf
```

Rebase your PR bookmark onto trunk:

```sh
jj rebase -b my-branch -d trunk()
```

Push again:

```sh
jp --bookmark my-branch
```

## Conflicts

After a rebase, check status:

```sh
jst
```

Fix files manually, then mark conflicts resolved:

```sh
jj resolve
```

Push again:

```sh
jp --bookmark my-branch
```

## Git To JJ Translation

```txt
gst                 -> jst
gd                  -> jd
git log             -> jl
gaa / ga            -> usually nothing
gc -m "message"     -> jc -m "message"
git checkout -b x   -> jn trunk(), then jj bookmark create x -r @-
git branch -a       -> jj bookmark list
git fetch           -> jf
git pull --rebase   -> jf + jj rebase -b <bookmark> -d trunk()
git push            -> jp --bookmark <bookmark>
git push --force    -> jp --bookmark <bookmark> --force-with-lease
```

## Boring Default PR Flow

Use this until the model feels natural:

```sh
jf
jn trunk()

# edit files
jst
jd

jc -m "message"
jj bookmark create my-branch -r @-
jp --bookmark my-branch
gh pr create
```

For later updates to the same PR:

```sh
jj edit my-branch

# edit files
jst
jd

jc -m "message"
jjub @-
jp --bookmark my-branch
```
