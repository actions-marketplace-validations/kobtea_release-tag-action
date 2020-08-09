#!/bin/sh
version=${INPUT_PREFIX}$($INPUT_ONLY_MAJOR_VERSION && (cat VERSION | cut -d. -f1) || cat VERSION)${INPUT_SUFFIX}
git config user.name  || git config --local user.name $(git log -1 --pretty=format:'%an')
git config user.email || git config --local user.email $(git log -1 --pretty=format:'%ae')
git ls-remote --exit-code --tags origin $version > /dev/null 2>&1 || (git tag -a $version -m "release $version" && git push origin $version)
echo "::set-output name=tag::$version"
