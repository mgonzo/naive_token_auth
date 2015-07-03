class User < ActiveRecord::Base
  require 'openssl'
  require 'base64'
  require 'jwt'

  validates_uniqueness_of :name

  before_create :set_uuid
  before_create :set_password

  before_save :set_token
  before_save :set_datetime

  # SET NEW TOKEN
  def set_token
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
  def set_password
    self.password = self.class.generate_password(self.password)
  end

  # CREATE UUID
  def set_uuid
    # create a user_id uuid
    uuid = UUID.new 
    self.user_id = uuid.generate :compact
  end

  # TOKEN SWAP
  def token_swap
    # change last token
    self.last_token = self.current_token

    # generate new token
    # set it to current token
    self.set_token
    self.save
  end

  #
  # CLASS METHODS
  #
  def self.generate_password(password)
    Base64.encode64(OpenSSL::HMAC.digest('sha256', ENV['SIMPLE_TOKEN_AUTH_KEY_BASE'], password))
  end

end
