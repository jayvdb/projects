#!/usr/bin/env bash
set -e # halt script on error

if [ -n "$PULL_REQUEST" ]; then
  echo PULL_REQUEST is $PULL_REQUEST
else
  export JEKYLL_ENV=production
fi

bundle exec jekyll build
bundle exec htmlproofer ./_site \
	--disable-external \
	--only-4xx
