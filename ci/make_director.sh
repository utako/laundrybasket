#!/usr/bin/env bash

set -ex

source ${HOME}/.bashrc

echo "Installing bosh bootloader"
go get github.com/pivotal-cf-experimental/bosh-bootloader/bbl

mkdir tmp
mkdir job_output

echo "Deploying a new director"

bbl --aws-access-key-id="${AWS_ACCESS_KEY_ID}" \
  --aws-secret-access-key="${AWS_SECRET_ACCESS_KEY}" \
  --state-dir="tmp" \
  --aws-region=us-east-1 \
  unsupported-deploy-bosh-on-aws-for-concourse --lb-type=none | tee ./tmp/bbl_output

DIRECTOR_IP=$(grep "Director Address" ./tmp/bbl_output  | awk 'BEGIN { FS = ":" } ; { print $2 }')

DIRECTOR_UUID=$(curl -k "https://${DIRECTOR_IP}:25555/info" | sed -n 's/.*"uuid":"\([^"]*\)".*/\1/p' | sed -e 's/ //g')

echo ${DIRECTOR_UUID} > "job_output/name"
echo '---' > "job_output/metadata"
grep Director ./tmp/bbl_output >> "job_output/metadata"
echo "$(cat tmp/state.json)" >> "job_output/metadata"
