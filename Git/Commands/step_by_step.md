# A practical, step-by-step Git guide with commonly used commands and one-line explanations.

## 1. Setup Git
- Check the installed Git version.
<pre>git --version</pre>

- Set your identity for commits.
<pre>git config --global user.name "Your Name"
git config --global user.email "you@example.com"</pre>

- To change the remote to use SSH instead of HTTPS (Check Errors folder for the issue that was encountered initially)
<pre>git remote set-url origin git@github.com:ishandoye/DevopsJourney.git </pre>

- View all Git configurations.
<pre>git config --list</pre>

- Set default branch name.
<pre>git config --global init.defaultBranch main</pre>

------------------------------------------------------------------

## 2. Initialize Repository

- Create and enter the project directory.
<pre>mkdir my-project
cd my-project</pre>

- Initialize a new Git repository.
<pre>git init</pre>

- Check current repo status.
<pre>git status</pre>

------------------------------------------------------------------

## 3. Add and Commit Files

- Create a new file.
<pre>touch README.md</pre>

- Stage a specific file.
<pre>git add README.md</pre>

- Stage all changes.
<pre>git add .</pre>

- Save staged changes with a message.
<pre>git commit -m "Initial commit"</pre>

- View compact commit history.
<pre>git log --oneline</pre>

------------------------------------------------------------------

## 4. Ignore Files
- Create ignore file.
<pre>touch .gitignore</pre>

Example:
<pre>node_modules/
.env
*.log
dist/</pre>

- Track ignore rules.
<pre>git add .gitignore
git commit -m "Add gitignore"</pre>

------------------------------------------------------------------

## 5. Daily Workflow

- Check modified files.
<pre>git status</pre>

- See changes before staging.
<pre>git diff</pre>

- Stage all updates.
<pre>git add .</pre>

- Commit changes.
<pre>git commit -m "Update code"</pre>

------------------------------------------------------------------

## 6. Branching

- List branches
<pre>git branch</pre>

- Create and switch to new branch.
<pre>git checkout -b feature-branch</pre>

- Switch to main branch.
<pre>git switch main</pre>

- Merge the branch into the current branch.
<pre> git merge feature-branch</pre>

- Delete merged branch.
<pre>git branch -d feature-branch</pre>

------------------------------------------------------------------

## 7. Remote Repository

- View remote repositories.
<pre>git remote -v</pre>

- Add remote repository.
<pre>git remote add origin https://github.com/user/repo.git</pre>

- Push code and set upstream.
<pre>git push -u origin main</pre>

- Push changes.
<pre>git push</pre>

- Pull latest changes.
<pre>git pull</pre>

- Download changes without merging.
<pre>git fetch</pre>

------------------------------------------------------------------

## 8. Clone Repository

- Copy remote repository locally.
<pre>git clone https://github.com/user/repo.git</pre>


------------------------------------------------------------------

## 9. Undo Changes

- Discard file changes.
<pre>git restore filename</pre>

- Unstage a file.
<pre>git restore --staged filename</pre>

- Modify last commit.
<pre>git commit --amend</pre>

- Undo the commit but keep the changes.
<pre>git reset --soft HEAD~1</pre>

- Remove the commit and changes completely.
<pre>git reset --hard HEAD~1</pre>

- Safely undo a commit.
<pre>git revert {commit_id}</pre>

- View the history of HEAD for recovery.
<pre>git reflog</pre>


------------------------------------------------------------------

## 10. Stashing

- Save work temporarily.
<pre>git stash</pre>

- List saved stashes.
<pre>git stash list</pre>

- Apply and remove stash.
<pre>git stash pop</pre>

------------------------------------------------------------------

## 11. Tags

- Create version tag.
<pre>git tag v1.0.0</pre>

- Push all tags.
<pre>git push --tags</pre>

------------------------------------------------------------------

## 12. File Operations

- Rename file.
<pre>git mv old.txt new.txt</pre>

- Delete file from repo.
<pre>git rm file.txt</pre>

- Remove file from Git but keep locally.
<pre>git rm --cached file.txt</pre>

------------------------------------------------------------------

## 13. SSH Setup

- Generate SSH key.
<pre>ssh-keygen -t ed25519 -C "you@example.com"</pre>

- Add key to SSH agent.
<pre>ssh-add ~/.ssh/id_ed25519</pre>

- Test SSH connection.
<pre>ssh -T git@github.com</pre>

------------------------------------------------------------------

## 14. Complete Workflow Example

- Feature development flow.
<pre>git clone &lt;repo_url&gt;
cd repo
git checkout main
git pull origin main
git checkout -b feature-new
git add .
git commit -m "Add new feature"
git push -u origin feature-new</pre>

- Merge and cleanup flow.
<pre>git checkout main
git pull origin main
git merge feature-new
git push origin main
git branch -d feature-new</pre>

------------------------------------------------------------------

## 15. Most Used Commands
  
<pre>
git init              - Initialize repo
git clone &lt;url&gt;       - Clone repo
git status            - Check status
git add .             - Stage changes
git commit -m ""      - Commit changes
git push              - Push code
git pull              - Pull updates
git branch            - List branches
git checkout -b name  - Create branch
git merge name        - Merge branch
git diff              - Show changes
git stash             - Save temp work
git revert &lt;id&gt;       - Undo commit safely &lt;/id&gt; </pre>

------------------------------------------------------------------

## Best Practices

- Use meaningful commit messages
- Always pull before starting work
- Work on branches (not main)
- Commit small logical changes
- Use revert instead of reset on shared branches
