#!/bin/bash

if [[ -z $1 ]]; then
    echo "Usage: ./close_gitlab_mrs.sh <search_query>"
    exit 1
fi

SEARCH_QUERY=$1
page=1

echo "Fetching merge request IDs for search: $SEARCH_QUERY"

ids=()
while true; do
  result=$(curl --silent --request GET \
    "https://gitlab.publicplan.cloud/api/v4/projects/706/merge_requests?search=$SEARCH_QUERY&per_page=100&page=$page&state=opened" --header "PRIVATE-TOKEN: $GITLAB_ACCESS_TOKEN")

  current_ids=($(echo "$result" | jq '.[] | .iid'))
  ids+=("${current_ids[@]}")

  if [ "$(echo "$result" | jq 'length')" -lt 100 ]; then
    break
  fi

  page=$((page + 1))
done

if [ ${#ids[@]} -eq 0 ]; then
    echo "No open merge requests found matching query: $SEARCH_QUERY"
    exit 0
fi

echo "Found ${#ids[@]} merge requests. Closing them..."

for id in "${ids[@]}"; do
    echo "Closing MR ID $id..."
    # curl --silent --request PUT "https://gitlab.publicplan.cloud/api/v4/projects/706/merge_requests/$id" --header "PRIVATE-TOKEN: $GITLAB_ACCESS_TOKEN" --form "state_event=close"
done

echo "Done."
