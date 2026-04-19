---
name: commit-push-pr
description: Stage all changes, commit with an auto-generated message, push to remote, and open a pull request against main.
argument-hint: "[commit message]"
allowed-tools: Bash, Read, Glob, Grep
---

You are performing a full commit → push → PR workflow. Follow these steps exactly.

## 1. Gather state

Run these in parallel:
- `git status` — see what's staged and unstaged
- `git diff HEAD` — see all changes
- `git log --oneline -5` — understand recent commit style

## 2. Determine commit message

If `$ARGUMENTS` is non-empty, use it as the commit message.

Otherwise, analyse the diff and write a concise message (imperative mood, ≤72 chars) that describes *why* the change exists, not just what files changed.

## 3. Stage and commit

Stage only tracked/modified files — do not blindly `git add .` if there are unrelated untracked files. Commit with the message. Append the Co-Authored-By trailer:

```
Co-Authored-By: Claude Opus 4.7 <noreply@anthropic.com>
```

## 4. Push

Push the current branch to origin. If the branch has no upstream yet, set it with `-u`.

## 5. Open a PR

Use `gh pr create` targeting `main`. Write a short body with:
- A bullet-point summary of what changed
- A "Test plan" checklist

If a PR already exists for this branch, print its URL instead of creating a duplicate.

## 6. Report

Print the PR URL and a one-line summary of what was committed.
