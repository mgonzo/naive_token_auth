class Api::TestController < Api::BaseController
  def test
    if (!@user)
      raise ActionController::RoutingError.new('Not Found')
    else
      render json: {
        :msg => 'test data sent ...',
        :token => @user.current_token,
        :token_expire => @user.current_token_expires
       }
    end
  end
end
