#!/bin/sh

git config --global alias.bye !"function _() { echo -e \"Saving branch \\e[0;32m\$(git symbolic-ref --short HEAD)\\e[0m for user \\e[0;32m\$USER\\e[0m\"; git add --all && git commit --no-verify -m \"Commit on \$HOSTNAME at \$(date)\"; git push --force origin HEAD:refs/private/\$USER/$(git symbolic-ref --short HEAD); }; _"

git config --global alias.hi !"function _() { echo -e \"Fetching private branches for user \\e[0;32m\$USER\\e[0m and updating local branches\" && git fetch --update-head-ok origin refs/private/\$USER/*:refs/heads/*; if [ $? -ne 0 ]; then echo -e \"\\e[0;31mFailed to update some branches.\\e[0m Run 'git fetch origin refs/private/\$USER/*:refs/heads/private/*' and integrate manually.\"; fi; }; _"

echo -e 'Successfully installed \e[0;32mgit bye\e[0m and \e[0;32mgit hi\e[0m.'
echo -e '\n  * Back up your current branch with \e[0;32mgit bye\e[0m.'
echo -e '  * Restore it later with \e[0;32mgit hi\e[0m (possibly on another machine).'
echo -e '\nYour branches are kept partially private. That means nobody will fetch them by default, but they are visible when you (or somebody else) runs \e[0;32mgit ls-remote\e[0m.'
