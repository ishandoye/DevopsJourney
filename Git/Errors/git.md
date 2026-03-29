## 1] While doing the commit, you can consider it as an error or a warning
<pre>
	# git commit -m "README.md file updated with first interaction."
	Author identity unknown
	
	*** Please tell me who you are.
	
Run
		git config --global user.email "you@example.com"
  		git config --global user.name "Your Name"

	to set your account's default identity.
		Omit --global to set the identity only in this repository.

	fatal: unable to auto-detect email address (got 'root@node.(none)')
</pre>

## 2] Issue while doing a git push, even though your key has been added to GitHub.
<pre>
	# git push
	Username for 'https://github.com': ******
	Password for 'https://******@github.com':
	remote: Invalid username or token. Password authentication is not supported for Git operations.
	fatal: Authentication failed for 'https://github.com/******/DevopsJourney.git/'
</pre>

- Your GitHub login password is not valid for git push over HTTPS. 
- GitHub only allows Git over HTTPS with a personal access token (PAT), or Git over SSH with an SSH key. 
- That is why GitHub is prompting for a username and password and then rejecting it with Invalid username or token. 
- Password authentication is not supported for Git operations.
	
- In your case, you already created an SSH key and added it to GitHub, but your local repository is still using an HTTPS remote URL.
- And not an SSH remote URL. That is why git push is asking for a username for 'https://github.com' instead of using your SSH key.
	
- GitHub’s docs show that remotes can use either an HTTPS URL, like
<pre> https://github.com/OWNER/REPO.git</pre>
or an SSH URL like 
<pre>git@github.com:OWNER/REPO.git</pre>

- You can switch between them with "git remote set-url"
	
  - Check what remote you currently have
	<pre># git remote -v</pre>
			
  - If it is HTTPS, it is self-explanatory.
  - Change it to SSH 
	<pre># git remote set-url origin git@github.com:&lt;yourUsername&gt;/DevopsJourney.git</pre>
			
  - Verify it using "git remote -v"
  - Now you will be able to do push using ssh.
	<pre># git push -u origin main</pre>

	OR 
	<pre># git push -u origin master</pre>

  - Now, if you want to use HTTPS as your original method.
    - You will need to create a Token first.
	- https://github.com/settings/tokens
	- Create a new token classic.
	- add expiration and then uise repo for full control.
	- Generate and copy the token.
	- Use that token while logging in as described [here](https://github.com/ishandoye/DevopsJourney/blob/main/Git/Errors/git.md#2-issue-while-doing-a-git-push-even-though-your-key-has-been-added-to-github).
