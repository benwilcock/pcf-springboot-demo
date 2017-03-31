#!/bin/bash

apt-get update && apt-get install -y curl

set -ex

if [ -z $ATTENDEE_SERVICE_URL ]; then
  echo "ATTENDEE_SERVICE_URL not set"
  exit 1
fi

pushd attendee-service-source
  echo "Running smoke tests for Attendee Service deployed at $ATTENDEE_SERVICE_URL"
  smoke-tests/bin/test $ATTENDEE_SERVICE_URL
popd

exit 0