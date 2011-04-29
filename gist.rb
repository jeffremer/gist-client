# **Gist Client** is a Ruby REST client wrapper for [Github V3 Gist API](http://developer.github.com/v3/gists).
#
# Dependencies
# ============

# We need JSON

# JSON responses are parsed and turned into the core Scrumy objects, key value
# pairs in the JSON hashes become instance variables in the objects.
require 'json'

# Gist Client uses [rest-client](https://github.com/archiloque/rest-client)
# for conveniently retrieving REST resources and handling some of the HTTP at a
# higher level.
require '../rest-client/lib/restclient.rb'

require 'mash'

module Gist
  class Client
    LIST="https://api.github.com/users/:user/gists.json"
    SHOW="https://api.github.com/gists/:id.json"
    CREATE="https://api.github.com/users/:user/gists.json"
    UPDATE="https://api.github.com/gists/:id.json"
    DELETE="https://api.github.com/gists/:id.json"
    
    
    # Every client request sets the `@url` instance variable for easy debugging
    # Just call client.url to see that last requested URL.
    attr_reader :url
    
    # `Gist::Client`s are initialized with a project name and password.
    def initialize(user, password=nil)
      @user, @password = user, password
    end

    # List a users Gists
    def list
      response = get(format(LIST))     
      # Responses are of two types, either arrays of hashes or a single hash
      if response.kind_of? Array
        # If it's array collect a new array by constructing objects based on the resource
        # name capitalized and singularized.
        response.collect do |obj|          
          Mash.new(obj)
        end
      else
        # Otherwise create a single new object of the correct type.
        Mash.new(response)
      end
    end
    
    # Read a single Gist
    def read(id)
      Mash.new(get(format(SHOW, id)))
    end
    
    # Create a Gist
    def create(content, description="Description Here", filename="file.txt", public=true)
      payload = {
        :description => description,
        :public => public,
        :files => {
          :filename => {
            :content => content
          }
        }
      }
      Mash.new(post(format(CREATE), payload))
    end
    
    # Update a Gist
    def update(gist)
      raise "Gist is not saved yet" if !gist.id
      payload = {
        :description => gist.description,
        :public => gist.public,
        :files => gist.files
      }
      puts payload
      Mash.new(patch(format(UPDATE, gist.id), payload))
    end    

    # TODO
    # This grammar should be better
    
    # Currently subresources specify special sybmols in their name,
    # either :project to get @project off the client, or :id to get
    # the argument passed to the client.
    def format(url, id=nil)
      url = url.gsub(':user', @user)
      url = url.gsub(':id', id.to_s) if id
      url
    end
    
    protected
      
      # `#get` retrieves JSON responses objects
      def get(url)
        begin
          # Start by creating a new `RestCLient::Resource` authenticated with
          # the `@project` name and `@password`.
          resource = RestClient::Resource.new(url)
          
          # `GET` the resource
          resource.get {|response, request, result, &block|
            case response.code
            when 200
              JSON.parse(response.body)
            else
              response.return!(request, result, &block)
            end
          }
        rescue => e
          # Rescue and reraise with the current `@url` for debugging purposes          
          raise "Problem fetching #{@url} because #{e.message}"
        end
      end
      
      def post(url, content)
        raise "Password is required for authenticated requests" if !@password
        begin
          resource = RestClient::Resource.new(url, @user, @password)
          resource.post(content.to_json, :content_type => :json, :accept => :json)  {|response, request, result, &block|
            case response.code
            when 201
              JSON.parse(response.body)
            else 
              response.return!(request, result, &block)
            end
          }
        rescue => e
          raise "Problem posting #{url} because #{e.message}"
        end
      end
      
      def patch(url, content)
        raise "Password is required for authenticated requests" if !@password
        begin
          resource = RestClient::Resource.new(url, @user, @password)
          resource.post(content.to_json, :content_type => :json, :accept => :json)  {|response, request, result, &block|
            case response.code
            when 200
              JSON.parse(response.body)
            else 
              response.return!(request, result, &block)
            end
          }
        rescue => e
          raise "Problem posting #{url} because #{e.message}"
        end
      end      
  
  end
end