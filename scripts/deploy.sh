#! /bin/sh

# REQUIRES

  # AWS_ACCESS_KEY_ID: <YOUR_AWS_ACCESS_KEY_ID>
  # AWS_SECRET_ACCESS_KEY: <YOUR_AWS_SECRET_ACCESS_KEY>
  # BUCKET: <YOUR_BUCKET_NAME>
  # BUILD_DIR: <YOUR_BUILD_DIR>
  # HASHED_FILES: <YOUR_HASHED_FILES_DIR>
  # CDN_DISTRIBUTION_ID: <YOUR_CDN_DISTRIBUTION_ID>
  # INVALIDATE_CACHE: <SHOULD_INVALIDATE_CACHE?>
  # INVALIDATION_PATH: <YOUR_INVALIDATION_PATH>
  # TTL_TIME: <YOUR_TTL_TIME>

# Set low TTL for root files & files without hash.
aws s3 sync "$BUILD_DIR" s3://"$BUCKET" \
  --delete \
  --cache-control max-age=0,no-cache,no-store,must-revalidate

# Set high TTL for hashed & referenced files.
aws s3 cp s3://"$BUCKET"/"$HASHED_FILES" s3://"$BUCKET"/"$HASHED_FILES" \
  --recursive \
  --metadata-directive REPLACE \
  --cache-control max-age="$TTL_TIME",public


# Cache Invalidation?
if [ "$INVALIDATE_CACHE" = true ] ;
then
  echo "Invalidating Cache";

  aws cloudfront create-invalidation \
    --distribution-id "$CDN_DISTRIBUTION_ID" \
    --paths "$INVALIDATION_PATH"
fi
