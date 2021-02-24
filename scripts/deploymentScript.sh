#!/bin/bash

# Install jq if it does not exist
apt install jq

LATEST_TAG=$(git describe --tags `git rev-list --tags --max-count=1)

#Create JSON structure
output="$( echo "{}" |\
jq --arg x "${LATEST_TAG}" '.tag=$x')"

echo "${output}" > "${AZ_SCRIPTS_OUTPUT_PATH}"