#! /bin/sh

# REQUIRES

  # AWS_ACCESS_KEY_ID: <YOUR_AWS_ACCESS_KEY_ID>
  # AWS_SECRET_ACCESS_KEY: <YOUR_AWS_SECRET_ACCESS_KEY>
  # BUCKET: <YOUR_BUCKET_NAME>
  # BUILD_DIR: <YOUR_BUILD_DIR>
  # HASHED_FILES: <YOUR_HASHED_FILES_DIR>
  # INVALIDATION_PATH: <YOUR_INVALIDATION_PATH>
  # TTL_TIME: <YOUR_TTL_TIME>

# Leave no Files behind!
aws s3 rm s3://"$BUCKET" --recursive

# Set low TTL for root files & files without hash.
aws s3 sync "$BUILD_DIR" s3://"$BUCKET" \
  --delete \
  --cache-control max-age=0,no-cache,no-store,must-revalidate

# Set high TTL for hashed & referenced files.
aws s3 cp s3://"$BUCKET"/"$HASHED_FILES" s3://"$BUCKET"/"$HASHED_FILES" \
  --recursive \
  --metadata-directive REPLACE \
  --cache-control max-age="$TTL_TIME",public
