require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "should create user" do
    user = User.new({
      name: "dave",
      email_address: "dave@example.com",
      password: "secret",
      password_confirmation: "secret"
    })

    assert user.save
  end

  test "update password must be different from current" do
    user = users(:one)

    assert_not user.update(password: "password", password_confirmation: "password")
    assert user.update(password: "secret", password_confirmation: "secret")
  end
end
