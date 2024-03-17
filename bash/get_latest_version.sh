#! /bin/bash

##########################################################################
# Description:
#   This script retrieves the latest version number of a GitHub repository
#
# Usage:
#   bash get_latest_version.sh <owner> <repo>
#
# Input Parameters:
#   <owner>: The owner of the GitHub repository.
#   <repo>: The name of the GitHub repository.
#
# Output:
#   The latest version number of the specified GitHub repository.
#   Such as v14.5.1
###########################################################################

# args
if [ $# -ne 2 ]; then
    echo "Usage: $0 <owner> <repo>"
    exit 1
fi

owner="$1"
repo="$2"

api_url="https://api.github.com/repos/$owner/$repo/releases/latest"
response=$(curl -sSL "$api_url")


# get api failed
if [ $? -ne 0 ]; then
    echo "Failed to fetch latest version for $owner/$repo."
    exit 1
fi

# if repo has no releases
error_message=$(echo "$response" | jq -r ".message")
if [ "$error_message" == "Not Found" ]; then
    documentation_url=$(echo "$response" | jq -r ".documentation_url")
    echo "Error: $error_message. May the repo has no releases"
    exit 1
fi

# check version
latest_version=$(echo "$response" | jq -r ".tag_name")
if [ -z "$latest_version" ]; then
    echo "Failed to fetch latest version for $owner/$repo."
    exit 1
fi

echo "$latest_version"
