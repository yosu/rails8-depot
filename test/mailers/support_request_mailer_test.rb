require "test_helper"

class SupportRequestMailerTest < ActionMailer::TestCase
  test "respond" do
    support_request = support_requests(:one)

    mail = SupportRequestMailer.respond(support_request)
    assert_equal "Re: MyString", mail.subject
    assert_equal [ "one@example.org" ], mail.to
    assert_equal [ "support@example.com" ], mail.from
    assert_match "MyText", mail.body.encoded
  end
end
