#!/bin/bash

function version() {
  echo $(cat lib/$PROJECT/version.rb | grep VERSION | sed -e "s/.*'\\(.*\\)'.*/\\1/g")
}

function isTagged() {
  VERSION=$(version)
  TAG=$(git tag | tail -n 1)

  if [ $VERSION = $TAG ]; then
    return 0
  else
    return 1
  fi
}

if $(isTagged); then
  rake build
  VERSION=$(version)
  gem push "pkg/$PROJECT-$VERSION.gem"
else
  echo version did not change
fi
