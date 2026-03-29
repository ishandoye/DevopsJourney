Git Commands: Reverting and Changing Commits
--------------------------------------------

### View commit history
<pre>git log --oneline</pre>

### Checkout a previous commit (read-only, detached HEAD)
<pre>git checkout {commit-id} </pre>
or (modern)
<pre>git switch --detach {commit-id} </pre>

Return to branch:
<pre>git switch main </pre>

### Revert a commit (safe, keeps history)

<pre>git revert {commit-id} </pre>

Undo last commit safely:
<pre>git revert HEAD </pre>

### Reset (rewrite history - use carefully)

Soft reset (keep changes staged):
<pre>git reset --soft {commit-id} </pre>

Mixed reset (default - keep changes unstaged):
<pre>git reset {commit-id} </pre>

Hard reset (delete changes and commits):
<pre>git reset --hard {commit-id} </pre>

Examples:
<pre>git reset --soft HEAD~2
git reset --hard HEAD~2 </pre>

### 5. Force push after reset (dangerous)
<pre>git push --force </pre>

### Create a new branch from old commit

<pre>git checkout -b new-branch {commit-id} </pre>

## 7. Restore a file from a previous commit
<pre>git checkout {commit-id} -- {file-name} </pre>

Notes:
-----
- revert = safe (adds new commit)
- reset = rewrites history
- checkout = view or restore
- Avoid force push on shared branches
