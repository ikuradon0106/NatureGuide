require "test_helper"

class Admin::SearchesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_searches_index_url
    assert_response :success
  end

  test "should get show" do
    get admin_searches_show_url
    assert_response :success
  end

  test "should get destroy" do
    get admin_searches_destroy_url
    assert_response :success
  end

  test "should get destroy_all" do
    get admin_searches_destroy_all_url
    assert_response :success
  end
end
