#!/bin/bash

if [[ -z $1 ]]
then
    echo "Usage: ./close_gitlab_mrs.sh <search_query>"
    exit 1
fi

SEARCH_QUERY=$1
page=1
while true; do
  result=$(curl --silent --request GET \
    "https://gitlab.publicplan.cloud/api/v4/projects/706/merge_requests?search=$SEARCH_QUERY&per_page=100&page=$page&state=opened" --header "PRIVATE-TOKEN: $GITLAB_ACCESS_TOKEN")
  
  echo "$result" | jq '.[] | .iid'

  if [ "$(echo "$result" | jq 'length')" -lt 100 ]; then
    break
  fi

  page=$((page + 1))
done
