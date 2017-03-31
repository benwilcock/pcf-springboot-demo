#!/bin/bash
describe "pcf-springboot-demo test"
  describe "GET /"
    http_result=`curl -s -o /dev/null -H 'Accept: application/json' $URL -w "%{http_code},%{content_type}"`
    http_code=`echo $http_result | cut -d, -f1`
    content_type=`echo $http_result | cut -d, -f2`

    it "serves a 200 response"
      assert equal $http_code 200
    end

    it "serves up json"
      assert match $content_type "application/json"
    end

    it "has messaging flag set to false"
      assert present $http_result '"hasmessaging": false'
    end

    it "has database flag"
      assert present $http_result '"hasdatabase": false'
    end
  end
end
