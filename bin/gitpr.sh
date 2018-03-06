#!/usr/bin/env bash
REPO=`git remote -v | cut -d ":" -f 2 | sed 's/\..*//g' | uniq`
FROM=`git branch | grep "^\*" | cut -f 2 -d ' '`
TO=${1:-master}

if [ "$1" == '-h' ] || [ "$1" == '--help' ]; then
  echo "Usage: $0 [to_branch]"
  echo "  Opens a github 'Create Pull Request' page between the current branch and to_branch, which defaults to 'develop'"
  exit 0
fi

open https://github.com/$REPO/compare/$TO...$FROM?expand=1
