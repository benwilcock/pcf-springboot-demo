#!/bin/bash

set -ex

pushd pcf-springboot-demo-source
  echo "Fetching Dependencies & Building Code..."
  ./mvnw compile > /dev/null

  echo "Running Tests..."
  ./mvnw test
popd

exit 0