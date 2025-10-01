require "test_helper"

class LineItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @line_item = line_items(:one)
  end

  test "should get index" do
    get line_items_url
    assert_response :success
  end

  test "should get new" do
    get new_line_item_url
    assert_response :success
  end

  test "should create line_item" do
    assert_difference("LineItem.count") do
      post line_items_url, params: { product_id: products(:pragprog).id }
    end

    follow_redirect!

    assert_select "h2", "Your Cart"
    assert_select "td", "The Pragmatic Programmer"
    assert_select "td.quantity", "1"
  end

  test "should create line_item via turbo-stream" do
    assert_difference("LineItem.count") do
      post line_items_url, params: { product_id: products(:pragprog).id },
        as: :turbo_stream
    end

    assert_response :success
    assert_match (/<tr class="line-item-highlight">/), @response.body
  end

  test "should show line_item" do
    get line_item_url(@line_item)
    assert_response :success
  end

  test "should get edit" do
    get edit_line_item_url(@line_item)
    assert_response :success
  end

  test "should update line_item" do
    patch line_item_url(@line_item), params: { line_item: { product_id: @line_item.product_id, quantity: 3 } }
    assert_redirected_to line_item_url(@line_item)

    follow_redirect!

    assert_select "td.quantity", "3"
  end

  test "should destroy line_item" do
    assert_difference("LineItem.count", -1) do
      delete line_item_url(@line_item)
    end

    assert_redirected_to line_items_url
  end

  test "should destroy line_item through decrement" do
    assert_difference("LineItem.count", -1) do
      post decrement_line_item_url(@line_item)
    end

    assert_redirected_to store_index_url
  end

  test "should decrement line_item" do
    patch line_item_url(@line_item), params: { line_item: { product_id: @line_item.product_id, quantity: "3" } }
    assert_redirected_to line_item_url(@line_item)

    follow_redirect!

    assert_select "td.quantity", "3"

    assert_difference("LineItem.count", 0) do
      post decrement_line_item_url(@line_item)
    end

    assert_redirected_to store_index_path

    get line_item_url(@line_item)

    assert_select "td.quantity", "2"
  end
end
