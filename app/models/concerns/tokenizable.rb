module Tokenizable 
  extend ActiveSupport::Concern
  require 'jwt'

  included do
    after_create  :generate_token
  end

  def generate_token
    self.token = JWT.encode({ user_id: self.user_id }, ENV['SIMPLE_TOKEN_AUTH_KEY_BASE'])
  end

end
