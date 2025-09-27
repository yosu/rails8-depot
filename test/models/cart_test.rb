require "test_helper"

class CartTest < ActiveSupport::TestCase
  test "add unique product" do
    cart = Cart.new
    line_item = cart.add_product(products(:pragprog))

    assert_equal line_item.product, products(:pragprog)
    assert_equal line_item.cart_id, cart.id
  end
end
