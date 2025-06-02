require "test_helper"

class Admin::NoticesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_notices_index_url
    assert_response :success
  end

  test "should get new" do
    get admin_notices_new_url
    assert_response :success
  end

  test "should get create" do
    get admin_notices_create_url
    assert_response :success
  end

  test "should get edit" do
    get admin_notices_edit_url
    assert_response :success
  end

  test "should get update" do
    get admin_notices_update_url
    assert_response :success
  end

  test "should get destroy" do
    get admin_notices_destroy_url
    assert_response :success
  end
end
