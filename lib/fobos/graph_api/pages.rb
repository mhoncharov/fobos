require 'cgi'
require 'httparty'
require 'hash'

module Fobos
  module GraphAPI
    class Pages
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

      # Return list of user's accounts.
      #
      # Use access_token from Fobos::GraphAPI::Pages.new
      def get_accounts
        user = Fobos::GraphAPI::Users.new(@access_token)
        user.get_request(fields: 'accounts')
      end

      # Publishing post to the page wall.
      #
      # If you call it with <b>USER_ACCESS_TOKEN</b> it will publish post from user!
      #
      # If you want publish something from Page you need call it with <b>PAGE_ACCESS_TOKEN</b>. You can get it from list of user's account returned by Fobos::GraphAPI::Pages.get_accounts.
      def post_to_page(page_id, page_access_token, options = {})
        options_part = String.new
        options_part = Options.map_options_to_params(options) unless options.empty?

        query = GRAPH_URI.to_s + "/#{page_id}" + "/feed?#{options_part}&access_token=#{page_access_token}"

        encoded_url = URI.encode(query)

        puts encoded_url

        self.class.post(URI.parse(encoded_url))
      end

      # Return feed list of page.
      #
      # Use access_token from Fobos::GraphAPI::Pages.new
      def get_feed(page_id, options = {})
        options.add_access_token_to_options(@access_token)
        options_part = Options.map_options_to_params(options)

        query = GRAPH_URI.to_s + "/#{page_id}" + "/feed?#{options_part}"

        self.class.get(query)
      end
    end
  end
end