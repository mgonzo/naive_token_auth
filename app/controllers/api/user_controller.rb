class Api::UserController < Api::BaseController
  require 'uuid'

  def index
    render json: { :msg => 'hello index' }
  end

  def create
    # sanitize everything
    # is everything present?
    # is email good?
    name = params[:name]
    email = params[:email]

    # do passwords match?
    password = params[:password1]

    # else create user
    safe_params = {
      :name => params[:name],
      :email => params[:email],
      :password => password,
    }

    # create user
    @user = User.new(safe_params);

    # save user
    # create response
    if (@user.save)
      render json: { :token => @user.current_token }
    else
      render json: { :message => 'Unable to create user.'}
    end

    # if anything fails, send back crap
    # http code and whatever else
    # redirect to index or error page
  end

  def signin
    # no token
    # lookup user by name or email
    name_or_email = params[:name]
    password = params[:password]

    # if password is nil give up
    # passwd hash
    hashed_password = User.generate_password(password)

    # find a user by name, email and by password
    @user_by_password = User.find_by password: hashed_password
    if (!@user_by_password)
      render json: { :error => 'Failed to signin.' }
      return
    end

    @user_by_name = User.find_by name: name_or_email
    @user_by_email = User.find_by name: name_or_email
    if (!@user_by_name && !@user_by_email)
      render json: { :error => 'Failed to signin.' }
      return
    end

    # did all of these return a User?
    # match internal id on either name/password or email/password
    case @user_by_password.id
    when @user_by_name.id
      # token swap
      @user_by_name.token_swap
      # send token to user
      render json: {
        :token => @user_by_name.current_token,
        :message => 'matched user by name',
        :user_by_name => @user_by_name.user_id
      }
      return
    when @user_by_email.id
      # token swap
      @user_by_name.token_swap
      # send token to user
      render json: {
        :token => @user_by_name.current_token,
        :message => 'matched user by email',
        :user_by_email => @user_by_email.user_id
      }
      return
    else
      render json: { :error => 'Could not find user' }
      return
    end


    # if there is no user for any of these
    # or if nothing matches up
    # send error 

  end

end
