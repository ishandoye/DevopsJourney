# Git Cherry-Pick vs Git Merge vs Git Rebase


## Before moving ahead, however, we have a better view of each.

- Rebase rewrites commit history to create a linear sequence of commits, making the project history cleaner and easier to follow.
- Merge combines branches by creating a merge commit, which preserves the original branching structure and results in a non-linear (graph-based) history.
### When using merge:
- The full development history is preserved
- It shows how branches diverged and were later combined
- The commit graph can become more complex to read
### When using rebase:
- The history appears as if all changes were made sequentially
- It simplifies logs and makes them easier to read
- However, it rewrites history and should be used carefully, especially on shared branches
### Recommendation:
- Use rebase when you want a clean, linear commit history (e.g., before merging feature branches)
- Use merge when you want to preserve the exact history of how changes were developed


**This document explains the difference between `git cherry-pick`, `git merge`, and `git rebase` in depth:
what they do, why they exist, when to use them, how they affect history, their risks, and their most useful commands.**

## 1. High-Level Difference

All three commands move changes between branches, but they do it differently.
- **git merge**
   - Combines the history of one branch into another branch.
   - Usually preserves the original branch structure.
   - May create a merge commit.

- **git rebase**
   - Reapplies commits from one branch on top of another base.
   - Rewrites commit history.
   - Produces a cleaner, more linear history.

- **git cherry-pick**
   - Copies one or more specific commits from one branch to another.
   - Does not bring the whole branch.
   - Useful when you want only selected changes.

### Simple memory trick:
- Merge = combine branches
- Rebase = rewrite a branch on top of another base
- Cherry-pick = copy selected commits

## 2. git merge

- What it does:
`git merge` integrates the changes from one branch into the current branch.

Example:
<pre>
    git checkout main
    git merge feature-login </pre>

Meaning:
- switch to `main`
- bring all commits from `feature-login` into `main`

### 2.1 Why git merge exists

Git merge exists because branch-based development is the normal way teams work.
Developers create feature branches, bugfix branches, release branches, and hotfix branches.
At some point, those branches must be combined. `git merge` is the standard and safest way to do that.

It is useful because:
- It preserves the relationship between branches
- It is easy to understand
- It does not rewrite existing public history
- It is a safe default in collaborative environments

### 2.2 When to use git merge

Use `git merge` when:
- A feature branch is complete and ready to be integrated
- You want to preserve branch history
- You are working on a shared branch or team branch
- Your team uses pull requests and branch merge workflows
- You want a non-destructive and collaboration-friendly integration method

Common use cases:
- merge a completed feature branch into `main`
- merge a bugfix branch into `develop`
- merge a release branch back into `main`

### 2.3 How git merge affects history

Suppose history looks like this:

    main:      A---B---C
                     \
    feature:          D---E

***After running:***
<pre>
    git checkout main
    git merge feature</pre>

***History may become:***

    A---B---C-------M
             \     /
              D---E

***Where:***
- `M` is a merge commit
- Git records that the two histories were combined

***This is useful because it preserves full context:***
- The feature branch existed
- It had commits D and E
- Those commits were merged into main at commit M

### 2.4 Fast-forward merge

If the current branch has not moved since the feature branch split, Git may do a fast-forward merge.

Example:

***Before:***
    A---B---C
             \
              D---E

If `main` is still at C and all new work is on the feature branch, then:
<pre>
    git checkout main
    git merge feature</pre>

***Result:***
    A---B---C---D---E

- No merge commit is created.
- Git simply moves the branch pointer forward.

Why does this happen?
- There is no divergent history
- The target branch can just "fast-forward" to the feature branch tip

### 2.5 No-fast-forward merge

If you want to always preserve the fact that a branch was merged, use:

<pre> git merge --no-ff feature</pre>

This forces a merge commit even if fast-forward is possible.

***Why use it:***
- Makes feature merges visible in history
- Easier to understand which commits came from which feature
- Common in teams that want explicit merge records

### 2.6 Merge conflicts

A merge conflict happens when Git cannot automatically combine the changes.

***Usually this happens when:***
- The same lines were changed differently in both branches
- One branch deleted a file that another branch modified
- both branches renamed or moved files in incompatible ways

Typical flow:
<pre>
    git checkout main
    git merge feature-branch</pre>

If conflicts happen:
<pre> git status </pre>

***Then:***
- open conflicted files
- resolve the conflict markers
- stage resolved files

Commands:
<pre>
    git add .
    git commit</pre>

Abort a merge if needed:
<pre> git merge --abort </pre>

### 2.7 Pros of git merge

- safe for shared history
- preserves full branch structure
- easy to understand
- ideal for team collaboration
- standard in PR-based workflows
- does not rewrite old commits

### 2.8 Cons of git merge

- can create many merge commits
- History can become visually messy
- log output can be harder to read in very active repos

### 2.9 Most useful merge commands

Merge a branch into the current branch:
<pre> git merge branch-name </pre>

Always create a merge commit:
<pre> git merge --no-ff branch-name </pre>

Abort current merge:
<pre> git merge --abort </pre>

Visualize history:
<pre> git log --oneline --graph --all </pre>

## 3. git rebase

What it does:
`git rebase` takes commits from your current branch and reapplies them on top of another branch.

Example:
<pre>
    git checkout feature-login
    git rebase main </pre>

Meaning:
- Take the commits from `feature-login`
- Replay them on top of the latest `main`

### 3.1 Why git rebase exists

**Git rebase exists to keep history clean and linear.**

Instead of showing that branches diverged and merged later, rebase lets Git present the branch
as though your work started from the latest version of the target branch.

This is useful because:
- commit history becomes easier to read
- feature branches can be updated with latest changes from main
- commit cleanup becomes easier before merging
- many teams prefer a linear history for simpler debugging and logging

----------------------------------------------------------------------
3.2 When to use git rebase
----------------------------------------------------------------------

Use `git rebase` when:
- your feature branch is behind `main`
- you want to update your branch before opening a PR
- you want a cleaner, linear history
- you want to squash, reorder, or reword commits
- the commits are local or private and not yet shared broadly

Common use cases:
- refresh a feature branch on top of latest `main`
- clean up commit history before merge
- reduce unnecessary merge commits in local development

----------------------------------------------------------------------
3.3 How git rebase affects history
----------------------------------------------------------------------

Suppose history looks like this:

    main:      A---B---C---F
                     \
    feature:          D---E

Run:
    git checkout feature
    git rebase main

After rebase:
    main:      A---B---C---F
                              \
    feature:                   D'---E'

Important:
- D' and E' are not literally the old commits
- Git creates new commits with new IDs
- the old commits D and E are replaced by rewritten versions

This is why rebase is called history rewriting.

----------------------------------------------------------------------
3.4 Why rebase makes history cleaner
----------------------------------------------------------------------

With merge, you may get:
    A---B---C---F---M
             \     /
              D---E

With rebase, you get:
    A---B---C---F---D'---E'

The second form is simpler to read because:
- there is a straight line of commits
- no merge commit is needed
- `git log` becomes easier to follow

This is the main reason developers like rebase.

----------------------------------------------------------------------
3.5 Rebase conflicts
----------------------------------------------------------------------

A rebase conflict happens while Git is replaying each commit.

Flow:
    git checkout feature
    git rebase main

If conflict happens:
    git status

Resolve the files, then:
    git add .
    git rebase --continue

Abort if needed:
    git rebase --abort

Skip the problematic commit if appropriate:
    git rebase --skip

Why rebase conflicts can feel harder:
- Git may stop on multiple commits one by one
- you may need to resolve conflicts multiple times during the replay

----------------------------------------------------------------------
3.6 Interactive rebase
----------------------------------------------------------------------

Interactive rebase is one of the most powerful Git features.

Command:
    git rebase -i HEAD~5

This opens an editor with the last 5 commits and lets you:
- pick: keep commit as-is
- reword: change commit message
- edit: stop to change commit contents
- squash: combine commit into previous commit
- fixup: combine without keeping the message
- drop: remove commit

Why use interactive rebase:
- clean up messy local commits
- combine "WIP" commits into a single logical commit
- reorder commits into a better sequence
- remove accidental or unnecessary commits

Example:
Before cleanup:
    commit 1 - create API
    commit 2 - typo fix
    commit 3 - debug print
    commit 4 - final API cleanup

After interactive rebase:
    commit 1 - create API with final cleanup

This is common before pushing or opening a PR.

----------------------------------------------------------------------
3.7 Dangerous side of rebase
----------------------------------------------------------------------

Rebase rewrites commit history, so it can be dangerous on shared branches.

Do not casually rebase:
- `main`
- `develop`
- any branch others are already using

Why:
- commit hashes change
- teammates may already have the old history
- they may get duplicate commits, conflicts, or broken branch relationships

Safe rule:
- rebase your own local feature branch
- do not rebase shared or public history unless the team intentionally uses that workflow

----------------------------------------------------------------------
3.8 Pull with rebase
----------------------------------------------------------------------

Useful command:
    git pull --rebase

What it does:
- fetches remote changes
- reapplies your local commits on top of the updated remote branch

Why teams use it:
- avoids unnecessary merge commits during `git pull`
- keeps local branch history cleaner

----------------------------------------------------------------------
3.9 Pros of git rebase
----------------------------------------------------------------------

- creates a clean linear history
- useful for updating feature branches
- excellent for commit cleanup
- makes logs easier to read
- avoids many unnecessary merge commits

----------------------------------------------------------------------
3.10 Cons of git rebase
----------------------------------------------------------------------

- rewrites history
- unsafe on shared branches if not coordinated
- conflicts may need repeated resolution
- can confuse beginners if used carelessly

----------------------------------------------------------------------
3.11 Most useful rebase commands
----------------------------------------------------------------------

Rebase current branch onto main:
    git rebase main

Continue after conflict resolution:
    git rebase --continue

Abort the rebase:
    git rebase --abort

Skip current commit during rebase:
    git rebase --skip

Interactive rebase:
    git rebase -i HEAD~5

Pull with rebase:
    git pull --rebase

======================================================================
4. git cherry-pick
======================================================================

What it does:
`git cherry-pick` copies one or more specific commits and applies them to the current branch.

Example:
    git checkout main
    git cherry-pick abc1234

Meaning:
- take commit `abc1234`
- apply its change on `main`
- create a new commit on `main` with that change

----------------------------------------------------------------------
4.1 Why git cherry-pick exists
----------------------------------------------------------------------

Sometimes you do not want an entire branch.
You only want one small change from another branch.

That is exactly why `git cherry-pick` exists.

It is useful because:
- you can take one bugfix without taking unrelated commits
- you can move a commit that was made on the wrong branch
- you can backport a critical fix to an older release branch
- you can selectively reuse work

----------------------------------------------------------------------
4.2 When to use git cherry-pick
----------------------------------------------------------------------

Use `git cherry-pick` when:
- you need only one or two commits, not the whole branch
- a hotfix must go to production immediately
- you need to backport a fix to a release branch
- someone committed to the wrong branch
- you need selected commits from another feature branch

Common use cases:
- pick one production bugfix from `develop` into `main`
- take one config fix from a feature branch
- move a wrongly placed commit into the correct branch

----------------------------------------------------------------------
4.3 How cherry-pick affects history
----------------------------------------------------------------------

Suppose this history exists:

    main:      A---B---C
    feature:           D---E---F

If only commit E is needed in main:

    git checkout main
    git cherry-pick <commit-E>

Result:
    main:      A---B---C---E'
    feature:           D---E---F

Important:
- E' is a new commit, not the exact same original commit
- Git copies the changes, not the original position in branch history

This means cherry-pick duplicates work in history, which is why it should be used carefully.

----------------------------------------------------------------------
4.4 Cherry-pick conflicts
----------------------------------------------------------------------

Cherry-pick can also create conflicts if the chosen commit depends on surrounding code that is different on the target branch.

Flow:
    git cherry-pick <commit-id>

If conflict occurs:
    git status

Resolve files, then:
    git add .
    git cherry-pick --continue

Abort:
    git cherry-pick --abort

Why this happens:
- the selected commit may assume other commits already exist
- the target branch may have changed the same lines differently

----------------------------------------------------------------------
4.5 Cherry-picking multiple commits
----------------------------------------------------------------------

Cherry-pick one commit:
    git cherry-pick <commit-id>

Cherry-pick multiple commits:
    git cherry-pick <commit1> <commit2>

Cherry-pick a range:
    git cherry-pick <start>^..<end>

Useful when:
- several related fixes need to be backported
- a set of small commits belongs in another branch

----------------------------------------------------------------------
4.6 Pros of git cherry-pick
----------------------------------------------------------------------

- very precise
- useful for hotfixes
- good for backporting
- allows selective reuse of work
- helpful when a commit was made on the wrong branch

----------------------------------------------------------------------
4.7 Cons of git cherry-pick
----------------------------------------------------------------------

- duplicates commits
- can make history confusing
- can be dangerous if you pick dependent commits out of context
- overuse can create maintenance headaches

----------------------------------------------------------------------
4.8 Most useful cherry-pick commands
----------------------------------------------------------------------

Cherry-pick one commit:
    git cherry-pick <commit-id>

Cherry-pick multiple commits:
    git cherry-pick <commit1> <commit2>

Cherry-pick range:
    git cherry-pick <start>^..<end>

Continue after resolving conflicts:
    git cherry-pick --continue

Abort:
    git cherry-pick --abort

Find commit IDs:
    git log --oneline

======================================================================
5. Deep Comparison: What changes in history?
======================================================================

git merge:
- preserves original branch identity
- may create a merge commit
- good for collaboration and true branch history

git rebase:
- rewrites commit IDs
- changes how history looks
- good for linear history and local cleanup

git cherry-pick:
- copies only selected commits
- creates duplicates of the chosen commit or commits
- good for selective transfer of changes

======================================================================
6. When to choose which one
======================================================================

Choose git merge when:
- you want the whole branch
- the feature is complete
- you want safe collaboration
- you want to preserve branch relationships
- you are merging via pull request or team workflow

Choose git rebase when:
- you want a clean history
- you need to update your feature branch from latest main
- you want to clean up your local commits
- your branch is private or local and not yet shared widely

Choose git cherry-pick when:
- you want one specific fix
- you want a hotfix or backport
- a commit is on the wrong branch
- you do not want the entire branch history

======================================================================
7. Real-World Scenarios
======================================================================

Scenario 1: Completed feature branch
- You built a login feature in `feature-login`
- Now the whole feature is ready for main

Best choice:
    git checkout main
    git merge feature-login

Why:
- you want the full work from the branch
- merge preserves feature history cleanly

----------------------------------------------------------------------
Scenario 2: Your feature branch is outdated
----------------------------------------------------------------------

- main has new commits
- you want your feature branch updated before PR

Best choice:
    git checkout feature-login
    git fetch origin
    git rebase origin/main

Why:
- rebasing updates your branch to the latest base
- your history stays cleaner than a merge-from-main

----------------------------------------------------------------------
Scenario 3: Urgent hotfix for production
----------------------------------------------------------------------

- a fix exists in develop
- production main needs only that one fix right now

Best choice:
    git checkout main
    git cherry-pick <fix-commit-id>

Why:
- you want only the urgent fix
- you do not want all unfinished work from develop

----------------------------------------------------------------------
Scenario 4: Wrong branch commit
----------------------------------------------------------------------

- you committed a change on `main` by mistake
- it belongs on `feature-x`

Best choice:
    git checkout feature-x
    git cherry-pick <commit-id>

Why:
- move only the relevant commit

----------------------------------------------------------------------
Scenario 5: Clean up local commit history before PR
----------------------------------------------------------------------

- your branch has many small WIP commits
- you want a clean PR

Best choice:
    git rebase -i HEAD~5

Why:
- combine or reword commits
- make the history easier for reviewers

======================================================================
8. Conflict Handling Summary
======================================================================

Merge conflict flow:
    git merge branch-name
    git status
    resolve files
    git add .
    git commit

Abort merge:
    git merge --abort

Rebase conflict flow:
    git rebase main
    git status
    resolve files
    git add .
    git rebase --continue

Abort rebase:
    git rebase --abort

Cherry-pick conflict flow:
    git cherry-pick <commit-id>
    git status
    resolve files
    git add .
    git cherry-pick --continue

Abort cherry-pick:
    git cherry-pick --abort

======================================================================
9. Best Practices
======================================================================

For git merge:
- use for shared branches
- use for completed features
- good default in team environments
- use `--no-ff` if you want explicit feature merge commits

For git rebase:
- use on local feature branches
- use before opening a PR if your team prefers linear history
- use interactive rebase to clean commits
- avoid rebasing shared branches unless the team agrees

For git cherry-pick:
- use sparingly
- ideal for hotfixes and backports
- double-check whether the selected commit depends on others
- avoid replacing proper branch integration with repeated cherry-picks

======================================================================
10. Most Useful Commands Quick Reference
======================================================================

MERGE
-----
Merge a branch:
    git merge branch-name

Force merge commit:
    git merge --no-ff branch-name

Abort merge:
    git merge --abort

REBASE
------
Rebase onto main:
    git rebase main

Continue rebase:
    git rebase --continue

Abort rebase:
    git rebase --abort

Interactive rebase:
    git rebase -i HEAD~5

Pull with rebase:
    git pull --rebase

CHERRY-PICK
-----------
Pick one commit:
    git cherry-pick <commit-id>

Pick multiple commits:
    git cherry-pick <commit1> <commit2>

Pick range:
    git cherry-pick <start>^..<end>

Continue:
    git cherry-pick --continue

Abort:
    git cherry-pick --abort

======================================================================
11. Interview-Style Summary
======================================================================

git merge:
- Combines full branch history into another branch.
- Preserves branch structure.
- Best for collaborative integration.

git rebase:
- Replays commits on a new base.
- Rewrites history for linear logs.
- Best for local cleanup and updating feature branches.

git cherry-pick:
- Copies selected commits only.
- Does not merge full branch history.
- Best for hotfixes, backports, and specific changes.

======================================================================
12. Final Recommendation
======================================================================

If you want the whole branch, use:
    git merge

If you want cleaner history and are working on your own branch, use:
    git rebase

If you want only one or a few specific commits, use:
    git cherry-pick

A practical day-to-day workflow:
- work on a feature branch
- rebase it on latest main when needed
- open a PR
- merge the feature into main
- cherry-pick only for rare selective fixes

======================================================================
13. Safe Golden Rule
======================================================================

- Merge is safest for shared branches
- Rebase is powerful for local branches
- Cherry-pick is precise for selective commits
- Never rewrite shared history casually
- Always check `git log --oneline --graph --all` if you are unsure

End of document.
