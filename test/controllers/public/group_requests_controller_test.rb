require "test_helper"

class Public::GroupRequestsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get public_group_requests_create_url
    assert_response :success
  end

  test "should get update" do
    get public_group_requests_update_url
    assert_response :success
  end

  test "should get destroy" do
    get public_group_requests_destroy_url
    assert_response :success
  end
end
