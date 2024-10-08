require "test_helper"

class UssdControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get ussd_index_url
    assert_response :success
  end
end
