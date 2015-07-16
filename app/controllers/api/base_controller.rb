class Api::BaseController < ApplicationController
  # should check for auth'd request here
  # because every resource should be auth'd
  #
  # needs to include a function from tokenize concern
  # tokenize controller concern
  #
  # get the token from the request
  # get the uuid from the request
  # get the user for uuid
  # get the user's current token
  # compare current token vs request token
  # redirect to index if tokens don't match
  #
  # put it here first,
  # then move it to a concern
  before_filter :parse_request, :auth_from_token!

  def parse_request
    # is every request supposed to be a post?
    # what about get requests?
    # can use get params like Ooyala does
    #
    # if this is a post, put or patch api_token should be in body
    # if this is a get api_token should be a query param
    #
    # what if we use an http header for the api_token?
    # anything wrong with that?
    # then it will always be the same ...
    #
    # request.headers["Authorization"]
    # http://stackoverflow.com/questions/8463809/customize-the-authorization-http-header

    if (request.request_method == 'GET')
      # get the param
      @token = request.query_parameters['api_token']
    else
      @json = JSON.parse(request.body.read)
      @token = @json['api_token']
    end
  end

  def auth_from_token!
    @user = nil

    User.find_each do |u|
    end
  end

end
