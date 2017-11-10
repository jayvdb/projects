#!/usr/bin/env bash
set -e # halt script on error

echo REPOSITORY_URL=$REPOSITORY_URL
echo BRANCH=$BRANCH
echo HEAD=$HEAD
echo PULL_REQUEST=$PULL_REQUEST
echo COMMIT_REF=$COMMIT_REF
echo CONTEXT=$CONTEXT

if [[ -n "$PULL_REQUEST" && "$PULL_REQUEST" != "false" ]]; then
  echo PULL_REQUEST is $PULL_REQUEST
else
  export JEKYLL_ENV=production
fi

bundle exec jekyll build
bundle exec htmlproofer ./_site \
	--disable-external \
	--only-4xx
