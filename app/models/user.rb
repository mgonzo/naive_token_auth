class User < ActiveRecord::Base
  include Tokenizable
  require 'jwt'

  before_save :generate_token

  def generate_token
    self.current_token = JWT.encode({ user_id: self.user_id }, ENV['SIMPLE_TOKEN_AUTH_KEY_BASE'])
  end
end
