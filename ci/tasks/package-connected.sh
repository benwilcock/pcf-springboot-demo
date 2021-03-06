#!/bin/bash

set -e +x

pushd code
  echo "Building and packaging the application JAR with Maven..."
  mvn package -Pcloud -DskipTests=true
popd

jar_count=`find code/target -type f -name *.jar | wc -l`

if [ $jar_count -gt 1 ]; then
  echo "More than one jar found, don't know which one to deploy. Exiting :("
  exit 1
fi

find code/target -type f -name *.jar -exec cp "{}" package-output/pcf-springboot-demo.jar \;

echo "Done packaging"
exit 0