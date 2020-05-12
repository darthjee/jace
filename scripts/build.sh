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

ACTION=$1

case $ACTION in
  "build")
    if $(isTagged); then
      rake build
    else
      echo version did not change
    fi
    ;;
  "push")
    if $(isTagged); then
      VERSION=$(version)
      gem push "pkg/$PROJECT-$VERSION.gem"
    else
      echo version did not change
    fi
    ;;
  *)
    echo Usage:
    echo "$0 build # builds gem"
    echo "$0 push # pushes gem"
    ;;
esac
