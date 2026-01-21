#!/bin/bash -e

FROM_R=$1
TO_R=$2

if [ "${FROM_R}" == "" ] || [ "${TO_R}" == "" ] ; then
  echo "Usage: git.repo.move <current-git-url> <new-git-url>"
  echo "Where,"
  echo "- Execute this CLI in any folder, it doesn't matter."
  echo "- Git repo @ current-git-url will be cloned with all remotes in /tmp folder."
  echo "- Removes will be changed to new-git-url for all branches and tags."
  echo "- All branches and tags will be pushed to new-git-url."
  exit 1
fi

TMP_PATH="/tmp/${1##*/}"

if [ -d "${TMP_PATH}" ] ; then
  rm -fr "${TMP_PATH}"
fi

git clone --bare "${FROM_R}" "${TMP_PATH}"
pushd "${TMP_PATH}"
git remote set-url origin "${TO_R}"
git push --all --force
git push --tags --force
popd
