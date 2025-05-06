require "test_helper"

class Admin::GroupsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get admin_groups_new_url
    assert_response :success
  end

  test "should get index" do
    get admin_groups_index_url
    assert_response :success
  end

  test "should get show" do
    get admin_groups_show_url
    assert_response :success
  end

  test "should get create" do
    get admin_groups_create_url
    assert_response :success
  end

  test "should get edit" do
    get admin_groups_edit_url
    assert_response :success
  end

  test "should get update" do
    get admin_groups_update_url
    assert_response :success
  end

  test "should get destroy" do
    get admin_groups_destroy_url
    assert_response :success
  end

  test "should get add_member" do
    get admin_groups_add_member_url
    assert_response :success
  end

  test "should get remove_member" do
    get admin_groups_remove_member_url
    assert_response :success
  end
end
