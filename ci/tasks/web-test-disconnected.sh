#!/bin/bash

apt-get update && apt-get install -y curl --allow-unauthenticated

set -ex

if [ -z $URL ]; then
  echo "The URL to test has not been set."
  exit 1
fi

# Make sure there the homepage shows there is NO Data Service bound...

if curl -s "$URL" | grep "No Data Service"
then
    echo "The website [$URL] shows 'No Data Service' (as expected)."
else
    echo "Error. Unexpected Data Service bound to [$URL]"
    exit 1
fi

# Make sure there the homepage shows there is NO Messaging Service bound...

if curl -s "$URL" | grep "No Messaging Service"
then
    echo "The website [$URL] shows 'No Messaging Service' (as expected)."
else
    echo "Error. Unexpected Messaging Service bound to [$URL]"
    exit 1
fi

# Make sure there the homepage shows there is NO Registry Service bound...

if curl -s "$URL" | grep "No Registry Service"
then
    echo "The website [$URL] shows 'No Registry Service' (as expected)."
else
    echo "Error. Unexpected Registry Service bound to [$URL]"
    exit 1
fi

# Make sure there the homepage shows there is NO Config Service bound...

if curl -s "$URL" | grep "No Config Service"
then
    echo "The website [$URL] shows 'No Config Service' (as expected)."
else
    echo "Error. Unexpected Config Service bound to [$URL]"
    exit 1
fi

# Make sure there the homepage shows there is a Cloud Platform present...

if curl -s "$URL" | grep "No Cloud Platform"
then
    echo "The website [$URL] shows 'No Cloud Platform' (this was unexpected)."
    exit 1
else
    echo "The website [$URL] does not show 'No Cloud Platform' (this was expected)."
fi

# Make sure the homepage shows there is a String Application Name present...

if curl -s "$URL/rest" | grep "pcf-springboot-demo"
then
    echo "The website [$URL/rest] shows 'pcf-springboot-demo' (as expected)."
else
    echo "Error. Not showing 'pcf-springboot-demo' on [$URL/name]"
    exit 1
fi

exit 0