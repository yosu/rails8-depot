require "test_helper"

class StoreControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_as users(:one)
  end

  test "should get index" do
    get store_index_url
    assert_response :success
    assert_select "nav a", minumum: 4
    assert_select "main ul li", minumum: 3
    assert_select "h2", "The Pragmatic Programmer"
    assert_select "div", /\$[,\d]+\.\d\d/
  end
end
