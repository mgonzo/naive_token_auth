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
  before_filter :auth_from_token!

  def auth_from_token!
    @token = request.headers["Authorization"]

    if (!@token) 
      return 
    end

    @user = nil;
    Users.each do |u|
      if (self.constant_compare(u.current_token, @token))
        @user = u;
      elseif (self.constant_compare(u.last_token, @token))
        @user = u;
      end
    end

    # if (!@user) # redirect to login end

  end

  def constant_compare(a, b)
    #return false
    ############
    
    if (a.length != b.length)
      return false
    end

    @results = 0
    a.zip(b) { |x, y|
      @return |= x ^ y
    }

    @results == 0
  end


end
