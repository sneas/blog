#!/bin/sh

git config user.email $GH_EMAIL
git config user.name $GH_NAME
git commit -am "Save uncommited changes (WIP)"
git branch --delete --force gh-pages
git checkout --orphan gh-pages
git add -f dist
git commit -m "Rebuild GitHub pages [ci skip]"
git filter-branch -f --prune-empty --subdirectory-filter dist && git push -f origin gh-pages && git checkout -
