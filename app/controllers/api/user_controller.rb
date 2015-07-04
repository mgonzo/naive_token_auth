class Api::UserController < Api::BaseController

  def index
    render json: { :msg => 'hello index' }
  end

  def create
    # if anything fails, send back crap
    # http code and whatever else
    # redirect to index or error page
    
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
      render json: { 
        :error => 'Unable to create user.',
      }, status: 500
      return
    end

  end

  def signin
    # lookup user by name or email
    # if there is no user send error 
    name_or_email = params[:name]
    password = params[:password]

    @user = User.signin(name_or_email, password)

    if (!@user)
      render json: { 
        :error => 'Failed to sign in.',
      }, status: 500
      return
    end

    render json: {
      :user => @user,
      :token => @user.current_token
    }

  end

end
