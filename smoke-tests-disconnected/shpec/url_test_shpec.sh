#!/bin/bash
describe "pcf-springboot-demo - Test the DISCONNECTED App"
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

  describe "does not have messaging or a database"
    http_output=`curl -s -H 'Accept: application/json' $URL`

    it "outputs something"
        assert present $http_output
    end
    it "messaging not present"
      assert no_match $http_output 'hasmessaging'
      assert no_match $http_output 'messaging'
    end

    it "database not present"
      assert no_match $http_output 'hasdatabase'
      assert no_match $http_output 'database'
    end

  end
end
