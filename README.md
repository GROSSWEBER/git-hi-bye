# git-bye-hi

git aliases to quickly transfer the current branch between machines using private branches on the server.

## Installation

```sh
curl -sL https://git.io/git-bye-hi | sh -

# or
wget -nv -O - https://git.io/git-bye-hi | sh -
```

This will add two aliases `git bye`and `git hi` to your global `.gitconfig`.

## Usage

Run `git bye` to:

* Commit pending changes
  * All untracked and changed files will be added to the commit
  * The commit message will be generated automatically:
    `Commit on <HOSTNAME> at <current date and time>`
  * Commit hooks will not be run (`git commit --no-verify`)
* Force-push the current branch to your `origin` remote as a private branch named `refs/private/<your username>/<current branch name>`

Run `git hi` to:

* Fetch private branches (`refs/private/<your username>/*`) from your `origin` remote
* Update local branches from the private branches on the server
  * `refs/private/<your username>/master` will update your `master` branch
  * Only fast-forwards are allowed
  * New branches not available locally yet will be created

## Example

1. Make some changes to your working copy

  ```sh
  agross@AXL /scratch/workstation @master*
  $ git status
  On branch master
  Your branch is up-to-date with 'origin/master'.
  Changes not staged for commit:
    (use "git add <file>..." to update what will be committed)
    (use "git checkout -- <file>..." to discard changes in working directory)

          modified:   123

  no changes added to commit (use "git add" and/or "git commit -a")
  ```

2. Save them on the server using `git bye`

  ```sh
  agross@AXL /scratch/workstation @master*
  $ git bye
  Saving branch master for user agross
  [master a8d41b1] Commit on AXL at Fri, May 20, 2016 12:01:47 PM
   1 file changed, 1 insertion(+)
  Counting objects: 3, done.
  Writing objects: 100% (3/3), 286 bytes | 0 bytes/s, done.
  Total 3 (delta 0), reused 0 (delta 0)
  To /scratch/workstation/../server.git
   - [new branch]      HEAD -> refs/private/agross/master

  agross@AXL /scratch/workstation @master
  $ git log --oneline --decorate
  a8d41b1 (HEAD -> master) Commit on AXL at Fri, May 20, 2016 12:01:47 PM
  2c553f0 (origin/master) First commit
  ```

3. Open a git shell on another machine and restore with `git hi`

  ```sh
  agross@AXL /scratch/laptop @master
  $ git log --oneline --decorate
  2c553f0 (HEAD -> master, origin/master, origin/HEAD) First commit

  agross@AXL /scratch/laptop @master
  $ git hi
  Fetching private branches for user agross and updating local branches
  remote: Counting objects: 3, done.
  remote: Total 3 (delta 0), reused 0 (delta 0)
  Unpacking objects: 100% (3/3), done.
  From /scratch/laptop/../server
     2c553f0..a8d41b1  refs/private/agross/master -> master

  ± git log --oneline --decorate
  a8d41b1 (HEAD -> master) Commit on AXL at Fri, May 20, 2016 12:01:47 PM
  2c553f0 (origin/master, origin/HEAD) First commit
  ```
