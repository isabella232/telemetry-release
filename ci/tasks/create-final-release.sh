#!/usr/bin/env bash

set -euo pipefail

TASK_DIR="$PWD"
BOSH_CLI=("$PWD"/bosh-cli-github-release/bosh-cli-*-linux-amd64)
chmod 755 "$BOSH_CLI"

VERSION=$(cat version/version)

apt-get update
apt-get -y install git
pushd telemetry-release

cat > private.yml <<EOM
---
blobstore:
  options:
    credentials_source: static
    json_key: |
      $GCS_SERVICE_ACCOUNT_KEY
EOM

"$BOSH_CLI" create-release --final --version "$VERSION"
git add .
git commit -m "Create final release $VERSION"
cp -R . "$TASK_DIR"/final-release-repo