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

# Make sure the homepage shows there is a DataBase Service bound...

if curl -s "$URL" | grep "MySQL"
then
    echo "The website [$URL] shows 'MySQL' (as expected)."
else
    echo "Error. Not showing 'MySQL' on [$URL]"
    exit 1
fi

# Make sure the homepage shows there is a Messaging Service bound...

if curl -s "$URL" | grep "Rabbit MQ"
then
    echo "The website [$URL] shows 'Rabbit MQ' (as expected)."
else
    echo "Error. Not showing 'Rabbit MQ' on [$URL]"
    exit 1
fi

# Make sure the homepage shows there is a Cache Service bound...

if curl -s "$URL" | grep "Redis"
then
    echo "The website [$URL] shows 'Redis' (as expected)."
else
    echo "Error. Not showing 'Redis' on [$URL]"
    exit 1
fi

# Make sure the homepage shows there is a Registry Service bound...

# if curl -s "$URL" | grep "Service Registry"
# then
#     echo "The website [$URL] shows 'Registry' (as expected)."
# else
#     echo "Error. Not showing 'Registry' on [$URL]"
#     exit 1
# fi

# Make sure the homepage shows there is a Config Service bound...

# if curl -s "$URL" | grep "Config Server"
# then
#     echo "The website [$URL] shows 'Config' (as expected)."
# else
#     echo "Error. Not showing 'Config' on [$URL]"
#     exit 1
# fi

# Make sure the homepage shows there is a Circuit Breaker Dashboard bound...

# if curl -s "$URL" | grep "Circuit Breaker Dashboard"
# then
#     echo "The website [$URL] shows 'Circuit Breaker Dashboard' (as expected)."
# else
#     echo "Error. Not showing 'Circuit Breaker Dashboard' on [$URL]"
#     exit 1
# fi

# Make sure the homepage shows there is a Cloud Platform present...

if curl -s "$URL" | grep "Instance GUID"
then
    echo "The website [$URL] shows 'Instance GUID' (as expected)."
else
    echo "Error. Not showing 'Instance GUID' on [$URL]"
    exit 1
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