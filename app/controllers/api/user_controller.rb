class Api::UserController < Api::BaseController
  require 'uuid'

  def index
    render json: { :msg => 'hello index' }
  end

  def create
    # does user exist already?
    # if yes, send user to sign in
    # else create user

    # sanitize everything
    # is everything present?
    # is email good?
    # do passwords match?
    name = params[:name]
    email = params[:email]
    password = params[:password1]
    
    # save user
    safe_params = {
      :name => params[:name],
      :email => params[:email],
      :password => password,
    }

    # create user
    @user = User.new(safe_params);

    # create response
    if (@user.save)
      render json: { :token => @user.current_token }
    else
      render json: { :message => 'unable to save user'}
    end

    # if anything fails, send back crap
    # http code and whatever else
    # redirect to index or error page
  end

end
