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

    # Set new current token
    def token_reset (model)
      model.last_token = nil
      model.current_token = token_generate(model.user_id)
      model.current_token_expires = Time.now + 10*60
    end

    # Set current and last tokens
    def token_swap (model)
      model.last_token = model.current_token
      model.current_token = token_generate(model.user_id)
      model.current_token_expires = Time.now + 10*60
    end

    # A utility for comparing tokens
    def constant_compare(a, b)
      if (a.length != b.length)
        return false
      end

      @results = 0
      a.bytes.zip(b.bytes) { |x, y|
        @return |= x ^ y
      }

      @results == 0
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
      logger = Logger.new(STDOUT)
      logger.info "auth signin"

      hashed_password = self.password_generate(password + model.user_id)
      @user_by_password = model.class.find_by password: hashed_password


      if (!@user_by_password)
        return nil
      end

      # match internal id's to be sure
      # that this is the same user record
      if (@user_by_password.id === model.id)
        self.token_reset(model)
        self.set_datetime(model)
        model.save
        return model
      else
        return nil
      end
    end

    def auth_token_request (token)
      logger = Logger.new(STDOUT)
      @user = nil
      User.find_each do |u|
        if (self.constant_compare(u.current_token, token))
        logger.info(u.name)
        logger.info(u.current_token_expires)
          if (u.current_token_expires > Time.now)
            self.token_swap(u)
            @user = u;
            @user.save
          end
        elsif (self.constant_compare(u.last_token, token) &&
            u.current_token_expires > Time.now + 10)
          self.token_swap(u)
          @user = u;
          @user.save
        end
      end

      return @user
    end

  end
end
