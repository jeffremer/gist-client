module Net
  class HTTP
    class Patch < HTTPRequest
      METHOD = 'PATCH'
      REQUEST_HAS_BODY = true
      RESPONSE_HAS_BODY = true
    end
  end
end

# Monkey patching rest-client to allow for patch method
module RestClient
  def self.patch(url, payload, headers={}, &block)
    Request.execute(:method => :patch, :url => url, :payload => payload, :headers => headers, &block)
  end
  class Resource
    def patch(payload, additional_headers={}, &block)
      headers = (options[:headers] || {}).merge(additional_headers)
      Request.execute(options.merge(
              :method => :patch,
              :url => url,
              :payload => payload,
              :headers => headers), &(block || @block))
    end      
  end
end