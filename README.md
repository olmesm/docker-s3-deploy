# [AWS S3] Deploy

Super simple image for easy [AWS S3] deploy. [Gitlab] and [Create React App] in mind, but should work with any pipeline or framework.

## Why use it?

- Quick
- No local dependencies
- Configured for [Create React App]
- Easy to fork
- Ready to integrate into [Gitlab]

## Integrating with [Gitlab]

See `./example.gitlab-ci.yml` for gitlab pipeline details.

## Running locally

```sh
export BUILD_DIR=<YOUR_BUILD_DIR> # build
export HASHED_FILES=<YOUR_HASHED_FILES> # static
export LOCAL_BUILD_DIR=<YOUR_LOCAL_BUILD_DIR> # local-build

docker run \
  -e AWS_ACCESS_KEY_ID=<YOUR_AWS_ACCESS_KEY_ID> \
  -e AWS_SECRET_ACCESS_KEY=<YOUR_AWS_SECRET_ACCESS_KEY> \
  -e BUCKET=<YOUR_BUCKET> \ # my-bucket-name
  -e BUILD_DIR=<YOUR_BUILD_DIR> \ # build
  -e HASHED_FILES=$HASHED_FILES \
  -e CDN_DISTRIBUTION_ID=<YOUR_CDN_DISTRIBUTION_ID> \
  -e INVALIDATE_CACHE=<SHOULD_INVALIDATE_CACHE?> \ # true/false
  -e INVALIDATION_PATH=$HASHED_FILES \
  -e TTL_TIME=<YOUR_MAX_TTL_TIME> \ # 31536000
  -v $(pwd)/"$LOCAL_BUILD_DIR":/usr/app/"$BUILD_DIR" \
  --rm \
  olmesm/s3-deploy
```

## Resources

Inspired by [s3Sync.sh]

<!-- References -->

[Gitlab]: https://gitlab.com/
[AWS S3]: https://aws.amazon.com/s3/
[s3Sync.sh]: https://gist.github.com/kellyrmilligan/e242d3dc743105fe91a83cc933ee1314
[Create React App]: https://github.com/facebook/create-react-app
