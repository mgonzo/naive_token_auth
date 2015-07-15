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
end
