#!/bin/bash

set -ex

pushd pcf-springboot-demo-source
  echo "Fetching Dependencies"
  ./gradlew clean assemble > /dev/null

  echo "Running Tests"
  ./gradlew test
popd

exit 0