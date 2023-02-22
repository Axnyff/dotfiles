squash_commit_in_branch() {
  BRANCH_NAME=`git rev-parse --abbrev-ref HEAD`
  COMMIT_NAME=`git log develop..$BRANCH_NAME --oneline | tail -1 | awk '{for (i=2; i<NF; i++) printf $i " "; print $NF}'`
  git reset `git merge-base develop $BRANCH_NAME`
  git add -A
  git commit -m "$COMMIT_NAME"
}
