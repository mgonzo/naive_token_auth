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

    # Generate a hashed password
    def password_generate (password)
      Base64.encode64(OpenSSL::HMAC.digest('sha256', ENV['SIMPLE_TOKEN_AUTH_KEY_BASE'], password))
    end

    # Generate a new token
    def token_generate (id)
      JWT.encode({ user_id: id }, ENV['TOKENIZE_KEY'])
    end

    # pass the full user in here
    # ...
    # maybe can figure out how to alter the model
    # from an instance method later
    def token_swap (model)
      model.last_token = model.current_token
      model.current_token = token_generate(model.user_id)
    end

  end
end
