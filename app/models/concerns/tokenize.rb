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
    def password_generate (string_to_hash)
      Base64.encode64(OpenSSL::HMAC.digest('sha256', ENV['SIMPLE_TOKEN_AUTH_KEY_BASE'], string_to_hash))
    end

    # Generate a new token
    def token_generate (id)
      JWT.encode({ user_id: id }, ENV['SIMPLE_TOKEN_AUTH_KEY_BASE'])
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
      model.password = self.password_generate(model.password + model.user_id)
      model.current_token = self.token_generate(model.user_id)
    end

    # SET DATE TIME
    def set_datetime (model)
      model.last_sign_in_at = model.current_sign_in_at
      model.current_sign_in_at = Date.current
    end

    # handle password verification
    # authentication, 
    # and token set
    def auth_signin (model, password)
      hashed_password = self.password_generate(password + model.user_id)
      @user_by_password = model.class.find_by password: hashed_password

      if (!@user_by_password)
        return nil
      end

      # match internal id's to be sure
      # that this is the same user record
      if (@user_by_password.id === model.id)
        self.token_swap(model)
        self.set_datetime(model)
        model.save
        return model
      else
        return nil
      end

    end

  end
end
