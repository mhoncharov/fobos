require 'cgi'
require 'httparty'

module Fobos
  module GraphAPI
    # Provides generating of access codes and access tokens for working with Facebook API.
    #
    #
    # Need HTTParty for making HTTP calls.
    # More about HTTParty here: https://github.com/jnunemaker/httparty


    class OAuth
      include HTTParty


      # ID of your Facebook App. You can get in your app's manage page.
      attr_accessor :app_id
      # Secret key of your Facebook App. You can get in your app's manage page.
      attr_accessor :app_secret
      # URL for redirecting after FB action on FB server-side. <b>NOTE:</b> callback_url must be the same for get_oauth_url and get_user_access_token_url
      attr_accessor :oauth_callback_url
      # Store long-live access token (set it manually).
      attr_accessor :access_token

      # Store Facebook default URL
      FB_URI = 'https://www.facebook.com'
      # Store Facebook Graph API URL
      GRAPH_URI = 'https://graph.facebook.com'

      # Initialize new object for Facebook OAuth actions.
      def initialize(app_id, app_secret, oauth_callback_url)
        @app_id = app_id
        @app_secret = app_secret
        @oauth_callback_url = oauth_callback_url
      end

      # Generate link for getting user's "access code" (<b>NOT ACCESS TOKEN</b>). After you make call of this link FB redirect you to @oauth_callback_url with "code" in params.
      #
      # <b>Options</b> you can see here https://developers.facebook.com/docs/facebook-login/manually-build-a-login-flow/v2.1#login
      def get_user_access_code_url(oauth_callback_url = @oauth_callback_url, options = {})
        options_part = String.new
        options_part = Options.map_options_to_params(options) unless options.empty?

        query = "/dialog/oauth?client_id=#{@app_id}&redirect_uri=#{oauth_callback_url}#{options_part}"

        (FB_URI.to_s + query.to_s).to_s
      end

      # Generate link for getting user's <b>ACCESS TOKEN</b> by code given with get_user_access_code
      def get_user_access_token_url(oauth_callback_url = @oauth_callback_url, code)
        query = "/oauth/access_token?client_id=#{@app_id}&client_secret=#{@app_secret}&code=#{code}&redirect_uri=#{oauth_callback_url}"

        GRAPH_URI.to_s + query.to_s
      end

      # Provide call of link what is result of get_user_access_token_url. Returned parsed access_token.
      def get_user_access_token(oauth_callback_url = @oauth_callback_url, code)
        response = self.class.get(get_user_access_token_url(oauth_callback_url, code))
        parsed_params = CGI::parse(response.parsed_response)
        parsed_params["access_token"].first
      end

      # Return users access code from params which returned by Facebook
      def get_user_access_code_from_params(params)
        code = params[:code]
        if code.nil?
          raise 'An error has occurred. You code is nil. Please check is your actions is valid.'
        else
          code
        end
      end

      # Generate link for getting long-live token (~60 days) instead short-live token (~1-2 hours)
      def get_user_long_live_access_token_url(access_token)
        query = "/oauth/access_token?grant_type=fb_exchange_token&client_id=#{app_id}&client_secret=#{app_secret}&fb_exchange_token=#{access_token}"

        GRAPH_URI.to_s + query.to_s
      end

      # Provide call of link what is result of get_user_long_live_access_token_url
      def get_user_long_live_access_token(access_token)
        self.class.get(get_user_long_live_access_token_url(access_token))
      end
    end
  end
end