require "application_system_test_case"

class UsersTest < ApplicationSystemTestCase
  setup do
    @user = users(:one)

    visit new_session_url

    fill_in "email_address", with: @user.email_address
    fill_in "password", with: "password"

    click_on "Sign in"

    assert_text "Welcome"
  end

  test "visiting the index" do
    visit users_url
    assert_selector "h1", text: "Users"
  end

  test "should create user" do
    visit users_url
    click_on "New user"

    assert_text "User"

    fill_in "Email address", with: "test@example.com"
    fill_in "Name", with: "Test User"
    fill_in "Password", with: "secret"
    fill_in "Password confirmation", with: "secret"
    click_on "Create User"

    assert_text "User was successfully created"
  end

  test "should update User" do
    visit user_url(@user)
    click_on "Edit this user", match: :first

    assert_text "User"

    fill_in "Email address", with: "update@example.com"
    fill_in "Name", with: "Updated User"
    fill_in "Password", with: "secret"
    fill_in "Password confirmation", with: "secret"
    click_on "Update User"

    assert_text "User was successfully updated"
  end

  test "should destroy User" do
    users(:two)

    visit user_url(@user)
    accept_confirm { click_on "Destroy this user", match: :first }

    assert_text "User was successfully destroyed"
  end
end
