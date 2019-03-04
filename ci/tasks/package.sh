#!/bin/bash

set -e +x

pushd pcf-springboot-demo-source
  echo "Packaging JAR"
  ./mvnw package
popd

jar_count=`find pcf-springboot-demo-source/target -type f -name *.jar | wc -l`

if [ $jar_count -gt 1 ]; then
  echo "More than one jar found, don't know which one to deploy. Exiting :("
  exit 1
fi

find pcf-springboot-demo-source/target -type f -name *.jar -exec cp "{}" package-output/pcf-springboot-demo.jar \;

echo "Done packaging"
exit 0