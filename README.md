# Fobos

[![Gem Version](https://badge.fury.io/rb/fobos.svg)](http://badge.fury.io/rb/fobos)
[![Build Status](https://travis-ci.org/mxgoncharov/fobos.svg?branch=master)](https://travis-ci.org/mxgoncharov/fobos)
[![Dependency Status](https://gemnasium.com/mxgoncharov/fobos.svg)](https://gemnasium.com/mxgoncharov/fobos)

Fobos is a easy to use, based on HTTParty gem for working with Facebook Graph and REST API.


It's Ruby based, so it compatible with any frameworks like Rails, Sinatra, etc. (<b>NOTE:</b> Please use latest version of Fobos. All versions use API v2.1, but latest version have no bugs and have more features.)

In current version it works only with basic Facebook Graph API features. In next versions REST API and new features for Graph API will be added.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'fobos'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fobos

## Usage
At first you need to initialize OAuth.

```ruby
oauth = Fobos::GraphAPI::OAuth.new(app_id, app_secret, oauth_callback_url)
```

Then call method which generate URL for getting access code.

```ruby
access_code_url = oauth.get_user_access_code_url
```

**THEN**, you need make HTTP request.

```ruby
redirect_to access_code_url
```

Now you can get access token from access code.

```ruby
oauth.get_user_access_token(access_code)
```

On oauth_callback_url facebook will send token in params.


With access token you can make requests to Facebook Graph API.

Use Fobos::GraphAPI::Users for working with user's data and Fobos::GraphAPI::Pages for working with Facebook Pages.

## Contributing

1. Fork it ( https://github.com/mxgoncharov/fobos/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
