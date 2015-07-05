module Tokenize extend ActiveSupport::Concern
  require 'jwt'
  require 'openssl'
  require 'base64'

  module ClassMethods

    # Generate a new user_id 
    def uuid_generate
      uuid = UUID.new 
      uuid.generate :compact
    end

    # Generate a hashed password from plain text
    def password_generate (password)
      Base64.encode64(OpenSSL::HMAC.digest('sha256', ENV['SIMPLE_TOKEN_AUTH_KEY_BASE'], password))
    end

    # Generate a new token
    def token_generate (id)
      JWT.encode({ user_id: id }, ENV['TOKENIZE_KEY'])
    end

    # Set current and last tokens
    def token_swap (model)
      model.last_token = model.current_token
      model.current_token = token_generate(model.user_id)
    end

    # Generate necessary stuff for a new user
    # user id, hashed password, current token
    def create_user (model)
      model.user_id = self.uuid_generate
      model.password = self.password_generate(model.password)
      model.current_token = self.token_generate(model.user_id)
    end

  end
end
