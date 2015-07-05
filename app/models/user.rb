class User < ActiveRecord::Base
  include Tokenize

  validates_uniqueness_of :name

  before_create :setup_auth

  def setup_auth
    self.class.create_user(self)
  end

  # SET DATE TIME
  def set_datetime
    self.last_sign_in_at = self.current_sign_in_at
    self.current_sign_in_at = Date.current
  end

  # instance signin
  def signin
    # just passing the user instance right in
    self.class.token_swap(self)
    self.set_datetime
    self.save
    return self
  end

  # is a class function
  # probably belongs in the mixin
  def self.signin (name_or_email, password)
    # if password is nil give up
    # passwd hash
    hashed_password = self.password_generate(password)

    # find a user by name, email and by password
    @user_by_password = self.find_by password: hashed_password
    if (!@user_by_password)
      return nil
    end

    @user_by_name = self.find_by name: name_or_email
    @user_by_email = self.find_by name: name_or_email
    if (!@user_by_name && !@user_by_email)
      return nil
    end

    # did all of these return a User?
    # match internal id on either name/password or email/password
    case @user_by_password.id
    when @user_by_name.id
      return @user_by_name.signin

    when @user_by_email.id
      return @user_by_email.signin

    else
      return nil
    end
  end

end
