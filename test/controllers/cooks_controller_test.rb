require 'test_helper'

class CooksControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get cooks_index_url
    assert_response :success
  end

  test "should get show" do
    get cooks_show_url
    assert_response :success
  end

  test "should get create" do
    get cooks_create_url
    assert_response :success
  end

  test "should get edit" do
    get cooks_edit_url
    assert_response :success
  end

  test "should get update" do
    get cooks_update_url
    assert_response :success
  end

  test "should get destroy" do
    get cooks_destroy_url
    assert_response :success
  end

end
