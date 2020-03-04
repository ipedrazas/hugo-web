#!/bin/bash

set -euox pipefail

SOURCE="hugo-web"
TARGET="ipedrazas.github.io"
TARGET_REPO="git@github.com:ipedrazas/${TARGET}.git"
GITHUB_SHA=$(git rev-parse --verify HEAD)


function cleanup(){
  # clean up
  if [ -d "./public" ]; then 
    rm -rf "./public"
  fi
  if [ -d "./dist" ]; then 
    rm -rf "./dist"
  fi
}

cleanup

# Clone the target repo
git clone --depth=1 --single-branch --branch master ${TARGET_REPO} dist
hugo --minify
cp -r ./public/* ./dist

pushd dist

# If there are any changes, commit & push
if [[ $(git status --porcelain --untracked-files=no) ]]; then 
  git add .
  git commit -m "Automated deployment: $(date -R) ${GITHUB_SHA}"
  git push origin master
fi

popd
cleanup
