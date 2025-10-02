require "test_helper"

class AdminControllerTest < ActionDispatch::IntegrationTest
  test "should get index if loggend in as a admin" do
    login_as users(:one)
    get admin_url
    assert_response :success
  end

  test "should be redirected if not logged in" do
    get admin_url
    assert_redirected_to new_session_url
  end
end
