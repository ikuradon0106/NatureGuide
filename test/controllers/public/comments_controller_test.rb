require "test_helper"

class Public::CommentsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get public_comments_new_url
    assert_response :success
  end

  test "should get create" do
    get public_comments_create_url
    assert_response :success
  end

  test "should get edit" do
    get public_comments_edit_url
    assert_response :success
  end

  test "should get update" do
    get public_comments_update_url
    assert_response :success
  end

  test "should get destroy" do
    get public_comments_destroy_url
    assert_response :success
  end
end
