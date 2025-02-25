#!/bin/bash

file=src/test/resources/results.sarif
filtered=src/test/resources/results-filtered.sarif
licenseFindingIds=$(jq -r '[ .runs[0].tool.driver.rules[] | select(.name == "license_finding").id ]' $file)

jq --argjson ids "$licenseFindingIds" '
  .runs[] |= (
    .results |= map(
      select(.ruleId | IN($ids[]) | not)
    )
  )
' $file > $filtered
