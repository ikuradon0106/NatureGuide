require "test_helper"

class Admin::CommentsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_comments_index_url
    assert_response :success
  end

  test "should get create" do
    get admin_comments_create_url
    assert_response :success
  end

  test "should get edit" do
    get admin_comments_edit_url
    assert_response :success
  end

  test "should get update" do
    get admin_comments_update_url
    assert_response :success
  end

  test "should get destroy" do
    get admin_comments_destroy_url
    assert_response :success
  end
end
