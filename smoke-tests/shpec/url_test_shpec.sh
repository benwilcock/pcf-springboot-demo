#!/bin/bash
describe "pcf-springboot-demo test"
  describe "HTTP code and content"
    http_result=`curl -s -o /dev/null -H 'Accept: application/json' $URL -w "%{http_code},%{content_type}"`
    http_code=`echo $http_result | cut -d, -f1`
    content_type=`echo $http_result | cut -d, -f2`

    it "serves a 200 response"
      assert equal $http_code 200
    end

    it "serves up json"
      assert match $content_type "application/json"
    end
  end

  describe "has messaging and database"
    http_output=`curl -H 'Accept: application/json' $URL`

    it "has messaging flag set to true"
      assert match $http_output '"hasmessaging":true'
    end

    it "has database flag set to true"
      assert match $http_output '"hasdatabase":true'
    end

  end
end
