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

      # Generate link for getting user's data with options.
      # Options must be a hash. You can provide value as String or Array.
      #
      # E.g. Fobos::GraphAPI::Users.new(access_token).get_request_url(fields: 'id') will return "https://graph.facebook.com/v2.1/me?fields=id&access_token=some_token"
      def get_request_url(options = {})
        options.add_access_token_to_options(@access_token)
        options_part = Options.map_options_to_params(options)

        GRAPH_URI.to_s + '/v2.1' '/me?' + options_part
      end


      # Generate link for post request (publishing) for user.
      # Options must be a hash. You can provide value as String or Array.
      #
      # E.g. Fobos::GraphAPI::Users.new(access_token).post_request(message: 'This is test message') will return "https://graph.facebook.com/v2.1/me/feed?message=This is test message&access_token=some_token"
      def post_request_url(options = {})
        options.add_access_token_to_options(@access_token)
        options_part = Options.map_options_to_params(options)

        query = GRAPH_URI.to_s + '/v2.1' '/me/feed?' + options_part
      end



      # Provides call of get_request_url
      def get_request(options = {})
        self.class.get(get_request_url(options))
      end

      # Provides call of post_request_url
      def post_request(options = {})
        encoded_url = URI.encode(post_request_url(options))

        self.class.post(URI.parse(encoded_url))
      end
    end
  end
end