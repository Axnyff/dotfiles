squash_commit_in_branch() {
  BRANCH_NAME=`git rev-parse --abbrev-ref HEAD`
  COMMIT_NAME=`git log master..$BRANCH_NAME --oneline | tail -1`
  git reset master
  git add -A
  git commit -m "$COMMIT_NAME"
}
