#!/usr/bin/env bash
set -e # halt script on error

echo REPOSITORY_URL=$REPOSITORY_URL
echo BRANCH=$BRANCH
echo HEAD=$HEAD
echo PULL_REQUEST=$PULL_REQUEST
echo COMMIT_REF=$COMMIT_REF
echo CONTEXT=$CONTEXT

if [[ -n "$DEPLOY_URL" && "${DEPLOY_URL/netlify//}" != "$DEPLOY_URL" ]]; then
  CI=netlify
  rvm use ruby 2.2.3
  echo PULL_REQUEST=$PULL_REQUEST >> .env
  echo COMMIT_REF=$COMMIT_REF >> .env
fi

# Netlify builds are deploys which can be previewed,
# and need to have a different UI except on master.
if [[ "$CI" == netlify && -z "$JEKYLL_ENV" ]]; then
  if [[ "$BRANCH" == master ]]; then
    export JEKYLL_ENV=production
  fi
elif [[ -z "$JEKYLL_ENV" ]]; then
  # Default to production builds
  export JEKYLL_ENV=production
fi

bundle exec jekyll build
bundle exec htmlproofer ./_site \
	--disable-external \
	--only-4xx
