class User < ActiveRecord::Base
  require 'openssl'
  require 'base64'
  require 'jwt'

  before_create :generate_uuid
  before_create :generate_password

  before_save :generate_token
  before_save :set_datetime

  # SET NEW TOKEN
  def generate_token
    self.current_token = JWT.encode({ user_id: self.user_id }, ENV['SIMPLE_TOKEN_AUTH_KEY_BASE'])
  end

  # SET DATE TIME
  def set_datetime
    # get current date time
    current_date = Date.current
    self.current_sign_in_at = current_date
    self.last_sign_in_at = current_date
  end

  # CREATE PASSWORD
  def generate_password
    hash = OpenSSL::HMAC.digest('sha256', ENV['SIMPLE_TOKEN_AUTH_KEY_BASE'], self.password)
    self.password = Base64.encode64(hash)
  end

  # CREATE UUID
  def generate_uuid
    # create a user_id uuid
    uuid = UUID.new 
    self.user_id = uuid.generate :compact
  end

end
