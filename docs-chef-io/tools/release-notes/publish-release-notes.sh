#!/bin/bash

set -eou pipefail

PRODUCT=inspec-azure
CURRENTDATE=$(date +"%Y-%m-%d")
DOCS_ASSETS_DIR="assets/release-notes/inspec-azure"


git clone "https://github.com/inspec/inspec-azure.wiki.git"

# Append the date to the array of dates in assets/release-notes/inspec-azure/release-dates.json
DATES_FILE="${DOCS_ASSETS_DIR}/release-dates.json"
DATES=$( cat "$DATES_FILE" | jq --arg DATE "$CURRENTDATE" '. |= .+ [$DATE]' )
echo $DATES | jq . > "$DATES_FILE"

pushd ./inspec-azure.wiki
  # Publish release notes to S3
  aws s3 cp Pending-Release-Notes.md "s3://chef-automate-artifacts/release-notes/${PRODUCT}/${CURRENTDATE}.md" --acl public-read --content-type "text/plain" --profile chef-cd

  # Reset "Release Notes" wiki page
  cat >./Pending-Release-Notes.md <<EOH
## New Azure Cloud Resources
-
## Improvements
-
## Bug Fixes
-
EOH

  # Push changes back up to GitHub
  git add .
  git commit -m "Release Notes for published release ${CURRENTDATE}"
  git push origin master
popd

rm -rf inspec-azure.wiki

# Commit changes to inspec-azure/docs-chef-io/static/release-notes/inspec-azure

git add .


# give a friendly message for the commit and make sure it's noted for any future
# audit of our codebase that no DCO sign-off is needed for this sort of PR since
# it contains no intellectual property

git commit -sm "Update release notes ${CURRENTDATE}."
