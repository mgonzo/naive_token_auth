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
  #
  # create user, will not have a token
  # signin user, will not have a token
  # all other handlers should redirect to index if there is no @user

  before_filter :auth_from_token!

  def auth_from_token!
    # get the request token
    @token = request.headers["Authorization"]

    # return nil if there is no request token
    # this is fine for create and signin requests
    # maybe stop the request here if it is not one of those
      logger = Logger.new(STDOUT)
    if (!@token)
      logger.info "no token"
      return nil
    end

    # set user if token is valid
    @user = User.auth_token_request(@token)

    # if @user is nil then something went wrong
    # probably should redirect to index page
    # or send 500 or 404

    # if (!@user) # redirect to login end
  end
end
