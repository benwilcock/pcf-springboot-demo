#!/bin/bash

apt-get update && apt-get install -y curl --allow-unauthenticated

set -ex

if [ -z $URL ]; then
  echo "The URL to test has not been set."
  exit 1
fi

# Make sure the homepage shows there is NO Data Service bound...

if curl -s "$URL" | grep "Ident: mysql"
then
    echo "The website [$URL] shows 'Ident: mysql' (as expected)."
else
    echo "Error. Not showing 'Ident: mysql' on [$URL]"
    exit 1
fi

# Make sure the homepage shows there is NO Messaging Service bound...

if curl -s "$URL" | grep "Ident: rabbit"
then
    echo "The website [$URL] shows 'Ident: rabbit' (as expected)."
else
    echo "Error. Not showing 'Ident: rabbit' on [$URL]"
    exit 1
fi

# Make sure the homepage shows there is a Cloud Platform present...

if curl -s "$URL" | grep "API: https://api.run.pivotal.io"
then
    echo "The website [$URL] shows 'API: https://api.run.pivotal.io' (as expected)."
else
    echo "Error. Not showing 'API: https://api.run.pivotal.io' on [$URL]"
    exit 1
fi

# Make sure the homepage shows there is a String Application Name present...

if curl -s "$URL/name" | grep "pcf-springboot-demo"
then
    echo "The website [$URL/name] shows 'pcf-springboot-demo' (as expected)."
else
    echo "Error. Not showing 'pcf-springboot-demo' on [$URL/name]"
    exit 1
fi

exit 0