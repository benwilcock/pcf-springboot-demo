#!/bin/bash

apt-get update && apt-get install -y curl --allow-unauthenticated

set -ex

if [ -z $URL ]; then
  echo "URL not set"
  exit 1
fi

if curl -s "$URL" | grep "No Data Service"
then
    # if the keyword is in the conent
    echo " the website is working fine"
    exit 0
else
    echo "Error"
    exit 1
fi