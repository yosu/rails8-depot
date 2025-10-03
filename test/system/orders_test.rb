require "application_system_test_case"

class OrdersTest < ApplicationSystemTestCase
  include ActiveJob::TestHelper

  test "check dynamic fields" do
    visit store_index_url

    click_on "Add to Cart", match: :first

    click_on "Checkout"

    assert has_no_field? "Routing #"
    assert has_no_field? "Account #"
    assert has_no_field? "CC #"
    assert has_no_field? "Expiry"
    assert has_no_field? "PO #"

    select "Check", from: "Pay with"

    assert has_field? "Routing #"
    assert has_field? "Account #"
    assert has_no_field? "CC #"
    assert has_no_field? "Expiry"
    assert has_no_field? "PO #"

    select "Credit Card", from: "Pay with"

    assert has_no_field? "Routing #"
    assert has_no_field? "Account #"
    assert has_field? "CC #"
    assert has_field? "Expiry"
    assert has_no_field? "PO #"

    select "Purchase Order", from: "Pay with"

    assert has_no_field? "Routing #"
    assert has_no_field? "Account #"
    assert has_no_field? "CC #"
    assert has_no_field? "Expiry"
    assert has_field? "PO #"
  end

  test "check order and delivery" do
    LineItem.delete_all
    Order.delete_all

    visit store_index_url

    click_on "Add to Cart", match: :first

    click_on "Checkout"

    fill_in "Name", with: "Dave Thomas"
    fill_in "Address", with: "123 Main Street"
    fill_in "Email", with: "dave@example.com"

    select "Check", from: "Pay with"
    fill_in "Routing #", with: "123456"
    fill_in "Account #", with: "987654"

    click_button "Place Order"
    assert_text "Thank you for your order"

    perform_enqueued_jobs
    perform_enqueued_jobs
    assert_performed_jobs 2

    orders = Order.all
    assert_equal 1, orders.size

    order = orders.first
    assert_equal "Dave Thomas", order.name
    assert_equal "123 Main Street", order.address
    assert_equal "dave@example.com", order.email
    assert_equal "Check", order.pay_type
    assert_equal 1, order.line_items.size

    mail = ActionMailer::Base.deliveries.last
    assert_equal [ "dave@example.com" ], mail.to
    assert_equal "Sam Ruby <depot@example.com>", mail[:from].value
    assert_equal "Pragmatic Store Order Confirmation", mail.subject
  end

  test "check ship order" do
    LineItem.delete_all
    Order.delete_all

    visit store_index_url

    click_on "Add to Cart", match: :first

    click_on "Checkout"

    fill_in "Name", with: "Dave Thomas"
    fill_in "Address", with: "123 Main Street"
    fill_in "Email", with: "dave@example.com"

    select "Check", from: "Pay with"
    fill_in "Routing #", with: "123456"
    fill_in "Account #", with: "987654"

    click_button "Place Order"
    assert_text "Thank you for your order"

    perform_enqueued_jobs
    perform_enqueued_jobs
    assert_performed_jobs 2

    orders = Order.all
    assert_equal 1, orders.size

    order = orders.first

    user = users(:one)

    visit new_session_url

    fill_in "email_address", with: user.email_address
    fill_in "password", with: "password"

    click_on "Sign in"

    assert_text "Welcome"

    visit order_url(order)

    assert_text "Showing order"

    click_on "Ship this order"

    assert_text "Order was successfully shipped."

    visit order_url(order)

    assert_text Date.today.to_s
  end
end
