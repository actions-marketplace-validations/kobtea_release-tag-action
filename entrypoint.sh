#!/bin/sh
version=${INPUT_PREFIX}$($INPUT_ONLY_MAJOR_VERSION && (cat ${INPUT_VERSION_FILE} | cut -d. -f1) || cat ${INPUT_VERSION_FILE})${INPUT_SUFFIX}
message=$(echo $INPUT_MESSAGE | sed s/__VERSION__/$version/g)
git config --global --add safe.directory /github/workspace
git config user.name  || git config --local user.name $(git log -1 --pretty=format:'%an')
git config user.email || git config --local user.email $(git log -1 --pretty=format:'%ae')
if $INPUT_FORCE; then
    git tag -af $version -m "$message" && git push -f origin $version
else
    git ls-remote --exit-code --tags origin $version > /dev/null 2>&1 || (git tag -a $version -m "$message" && git push origin $version)
fi
echo "tag=$version" >> $GITHUB_OUTPUT
