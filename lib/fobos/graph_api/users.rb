require 'cgi'
require 'httparty'

module Fobos
  module GraphAPI
    class Users
      include HTTParty

      # You can get access token with Fobos::GraphAPI::Oauth.
      attr_accessor :access_token

      # Store Facebook default URL
      FB_URI = 'https://www.facebook.com'
      # Store Facebook Graph API URL
      GRAPH_URI = 'https://graph.facebook.com'

      # Need access token for making calls.
      def initialize(access_token)
        @access_token = access_token
      end

      # Provides getting user's data with options.
      # Options must be a hash. You can provide value as String or Array.
      #
      # E.g. Fobos::GraphAPI::Users.new(access_token).get_request(fields: 'id,first_name,last_name') will return ID, FIRST NAME and LAST NAME of user.
      def get_request(options = {})
        options_part = ''
        options_part = options.map {|k,v| "#{k}=#{v.kind_of?(Array) ? v.join(',') : v}" }.join('&') unless options.empty?

        query = GRAPH_URI.to_s + '/v2.1' '/me?' + options_part + "&access_token=#{@access_token}"

        self.class.get(query)
      end

      # Provides sending post request (publishing) for user.
      # Options must be a hash. You can provide value as String or Array.
      #
      # E.g. Fobos::GraphAPI::Users.new(access_token).post_request(message: 'This is test message') will post "This is test message" to user's feed.
      def post_request(options = {})
        options_part = ''
        options_part = options.map {|k,v| "#{k}=#{v.kind_of?(Array) ? v.join(',') : v}" }.join('&') unless options.empty?

        query = GRAPH_URI.to_s + '/v2.1' '/me/feed?' + options_part + "&access_token=#{@access_token}"

        encoded_url = URI.encode(query)

        self.class.post(URI.parse(encoded_url))
      end

    end
  end
end