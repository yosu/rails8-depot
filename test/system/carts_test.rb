
require "application_system_test_case"

class CartsTest < ApplicationSystemTestCase
  test "check carts reveal and hide" do
    visit store_index_url

    assert has_no_field? "Your Cart"

    click_on "Add to Cart", match: :first

    assert has_content? "Your Cart"

    click_on "Empty Cart"

    assert has_no_content? "Your Cart"
  end

  test "check highlight line item" do
    visit store_index_url

    click_on "Add to Cart", match: :first

    assert has_css? "table tr.line-item-highlight"
  end
end
