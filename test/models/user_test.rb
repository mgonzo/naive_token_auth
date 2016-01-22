require 'test_helper'

class UserTest < ActiveSupport::TestCase

  # User name should be unique
  test "should have unique name" do
    @params = {
      :name => 'mgonzo4',
      :email => 'mgonzo@mail.com',
      :password => 'pass1'
    }
    user = User.create(@params)
    assert user.valid?, "user name is not unique"
  end

  # test user signin
  # should return nil if wrong password
  test "signin should return nil wrong password" do
    @name = 'mgonzo1',
    @password = 'wrongpassword'
    assert_nil User.signin(@name, @password)
  end

  # test user signin
  # should return nil if no user found
  test "signin should return nil no user" do
    @name = 'mgonzo_not_created',
    @password = 'password'
    assert_nil User.signin(@name, @password)
  end

  # test user signout
  test "signout" do
    assert false
  end
end
