class Api::UserController < Api::BaseController
  require 'uuid'
  require 'jwt'
  require 'openssl'
  require 'base64'

  def index
    render json: { :msg => 'hello index' }
  end

  def create
    name = params[:name]
    email = params[:email]
    password1 = params[:password1]
    password2 = params[:password2]

    # sanitize everything
    # is everything present?
    # is email good?
    # do passwords match?
    
    # does user exist already?
    # if yes, just sign user in
    # else create user

    # USER
    # create a user_id uuid
    uuid = UUID.new 
    user_id = uuid.generate :compact

    # get hashed password
    hash = OpenSSL::HMAC.digest('sha256', ENV['SIMPLE_TOKEN_AUTH_KEY_BASE'], params[:password1])
    hashed_password = Base64.encode64(hash)

    #TOKEN
    # generate token
    token = JWT.encode({ user_id: user_id }, ENV['SIMPLE_TOKEN_AUTH_KEY_BASE'])

    # DATE TIME
    # get current date time
    current_date = Date.current

    # save user
    safe_params = {
      :name => params[:name],
      :email => params[:email],
      :user_id => user_id,
      :password => hashed_password,
      :current_token => token,
      :current_sign_in_at => current_date,
      :last_sign_in_at => current_date
    }

    @user = User.new(safe_params);

    if (@user.save)
      # create response
      render json: { :token => token }
    else
      render json: { :message => 'unable to save user'}
    end



    # if anything fails, send back crap
    # http code and whatever else
    # redirect to index or error page
  end

  private 
    def user_params
    end

end
