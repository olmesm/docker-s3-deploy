#!/bin/sh

# REQUIRES

  # CDN_DISTRIBUTION_ID: <YOUR_CDN_DISTRIBUTION_ID>
  # INVALIDATE_CACHE: <SHOULD_INVALIDATE_CACHE?>
  # INVALIDATION_PATH: <YOUR_INVALIDATION_PATH>


# If cache invalidation has NOT been requested exit early
if [ "$INVALIDATE_CACHE" = false ] ;
then
  echo "Skipping Cache Invalidation Check"
  exit 0;
fi

echo "Invalidating Cache";

aws cloudfront create-invalidation \
  --distribution-id "$CDN_DISTRIBUTION_ID" \
  --paths "$INVALIDATION_PATH"

# Get last invalidation from aws-cli
LATEST_INVALIDATION=$(aws cloudfront list-invalidations --distribution-id "$CDN_DISTRIBUTION_ID" | grep -m1 "Id" | sed -r 's/.*("Id": ")([0-9A-Z]+)(",).*/\2/')

echo "Checking Cache Invalidation status for ID: $LATEST_INVALIDATION";
echo "See https://docs.aws.amazon.com/cli/latest/reference/cloudfront/wait/invalidation-completed.html"

echo "
Please wait...
";

aws cloudfront wait invalidation-completed \
  --distribution-id "$CDN_DISTRIBUTION_ID" \
  --id "$LATEST_INVALIDATION"

# Results
if [ $? -eq 0 ]
then
  echo "Cache Invalidation verification completed"
else
  echo "Could not complete Cache Invalidation verification" >&2
  exit 1
fi
