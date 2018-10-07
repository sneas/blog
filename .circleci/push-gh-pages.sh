#!/bin/sh

[ ! -z "$GH_NAME" ] && git config user.email $GH_NAME
[ ! -z "$GH_EMAIL" ] && git config user.email $GH_EMAIL

MAIN_BRANCH=$(git symbolic-ref --short HEAD)

git stash
git branch --delete --force gh-pages
git checkout --orphan gh-pages
git add -f dist
git commit -m "Rebuild GitHub pages [ci skip]"
git filter-branch -f --prune-empty --subdirectory-filter dist && git push -f origin gh-pages
git checkout $MAIN_BRANCH
git stash apply
