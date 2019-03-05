#!/bin/bash

apt-get update && apt-get install -y curl --allow-unauthenticated

set -ex

if [ -z $URL ]; then
  echo "The URL to test has not been set."
  exit 1
fi

# Make sure the homepage shows...

if curl -sL -w %{http_code} "$URL" -o /dev/null | grep "200"
then
    echo "The website [$URL] shows 'HTTP/1.1 200 OK' (as expected)."
else
    echo "Error. Not showing '200 OK' on [$URL]"
    exit 1
fi

# Make sure the /actuator/info endpoint shows...

if curl -sL -w %{http_code} "$URL/actuator/info" -o /dev/null | grep "200"
then
    echo "The website [$URL/actuator/info] shows 'HTTP Status 200 OK' (as expected)."
else
    echo "Error. Not showing '200 OK' on [$URL/actuator/info]"
    exit 1
fi

# Make sure the /actuator/env endpoint shows...

if curl -sL -w %{http_code} "$URL/actuator/env" -o /dev/null | grep "200"
then
    echo "The website [$URL/actuator/env] shows 'HTTP Status 200 OK' (as expected)."
else
    echo "Error. Not showing '200 OK' on [$URL/actuator/env]"
    exit 1
fi

# Make sure the homepage shows there is a Spring Application Name present...

if curl -s "$URL/rest" | grep "pcf-springboot-demo"
then
    echo "The website [$URL/rest] shows 'pcf-springboot-demo' (as expected)."
else
    echo "Error. Not showing 'pcf-springboot-demo' on [$URL/name]"
    exit 1
fi

# Make sure there the homepage shows there is a Cloud Platform present...

if curl -s "$URL" | grep "Instance GUID"
then
    echo "The website [$URL] shows an 'Instance GUID' (this was expected)."

else
    echo "The website [$URL] does not show 'Instance GUID' (this was unexpected)."
    exit 1
fi

# Make sure there the homepage shows there is NO MySQL Service bound...

if curl -s "$URL" | grep "MySQL"
then
    echo "Error. Unexpected MySQL Service is bound to [$URL]"
    exit 1
else
    echo "The website [$URL] has no 'MySQL' service (as expected)."
fi

# Make sure there the homepage shows there is NO Redis Service bound...

if curl -s "$URL" | grep "Redis"
then
    echo "Error. Unexpected Redis Service is bound to [$URL]"
    exit 1
else
    echo "The website [$URL] has no 'Redis' service (as expected)."
fi

# Make sure there the homepage shows there is NO Rabbit MQ Service bound...

if curl -s "$URL" | grep "Rabbit MQ"
then
    echo "Error. Unexpected Rabbit MQ Service is bound to [$URL]"
    exit 1
else
    echo "The website [$URL] has no 'Rabbit MQ' service (as expected)."
fi

# Make sure there the homepage shows there is NO Registry Service bound...

if curl -s "$URL" | grep "Service Registry"
then
    echo "Error. Unexpected Registry Service is bound to [$URL]"
    exit 1
else
    echo "The website [$URL] has no 'Registry' service (as expected)."
fi

# Make sure there the homepage shows there is NO Circuit Breaker Dash bound...

if curl -s "$URL" | grep "Circuit Breaker Dashboard"
then
    echo "Error. Unexpected Circuit Breaker Dashboard is bound to [$URL]"
    exit 1
else
    echo "The website [$URL] has no 'Circuit Breaker Dashboard' service (as expected)."
fi

# Make sure there the homepage shows there is NO Config Service bound...

if curl -s "$URL" | grep "Config Server"
then
    echo "Error. Unexpected Config Service is bound to [$URL]"
    exit 1
else
    echo "The website [$URL] has no 'Config' service (as expected)."
fi

exit 0