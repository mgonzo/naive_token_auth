class User < ActiveRecord::Base
  include Tokenize
  validates_uniqueness_of :name
  before_create :setup_auth

  #
  # setup_auth
  #
  # call module create_user
  # to setup password, user_id, tokens
  def setup_auth
    self.class.create_user(self)
  end

  #
  # User.signin
  #
  # find a user and
  # try to signin the user
  # with the auth module
  def self.signin (name_or_email, password)
    # find a user by name or by email
    # to match up with the password
    @user = self.find_by name: name_or_email

    if (!@user) 
      @user = self.find_by email: name_or_email
    end

    if (!@user) 
      return nil
    end

    return self.auth_signin(@user, password)
  end

end
