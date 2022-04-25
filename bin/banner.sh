#!/bin/bash
title=$(npm pkg get name | tr -d '"')
version=$(npm pkg get version | tr -d '"')
copyright=$(cat 'LICENSE' | sed -n -e 's/^.*Copyright //p' | tr '\n' ' ')
license=$(npm pkg get license | tr -d '"')
repoLink=$(npm pkg get repository.url | tr -d '"')
banner=$(echo "/*! ${title^} $version | $copyright | $license License | $repoLink */" | tr -s ' ')
echo "$banner"
