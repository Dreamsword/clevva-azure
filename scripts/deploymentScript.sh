#!/bin/bash

# Install jq if it does not exist
# apt install jq
# 
# LATEST_TAG=$(git describe --tags `git rev-list --tags --max-count=1)
# 
# #Create JSON structure
# output="$( echo "{}" |\
# jq --arg x "${LATEST_TAG}" '.tag=$x')"
# 
# echo "${output}" > "${AZ_SCRIPTS_OUTPUT_PATH}"

curl --location --request POST 'https://digiblu.clevva.com/api/va/start' \
--header 'apikey: j1065753a0e391dfb584963b25c1e987' \
--header 'Content-Type: application/json' \
--data-raw '{
	"va": {
		"code": "COVIDBAN"
	}
}'