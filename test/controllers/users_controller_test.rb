require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    OmniAuth.config.test_mode = true
  end

  test "should get index" do
    log_in_as(@user)
    get users_url
    assert_response :success
  end

  test "should redirect to get index without login" do
    get users_url
    assert_redirected_to welcome_path
  end

  test "should show user" do
    log_in_as(@user)
    get user_url(@user)
    assert_response :success
  end

  test "should get edit" do
    log_in_as(@user)
    get edit_user_url(@user)
    assert_response :success
  end

  test "should redirect edit to login" do
    get edit_user_url(@user)
    assert_redirected_to welcome_path
  end

  test "should update user" do
    log_in_as(@user)
    patch user_url(@user), params: { user: { name: @user.name } }
    assert_redirected_to user_url(@user)
  end

  test "should redirect update to login" do
    patch user_url(@user), params: { user: { name: @user.name } }
    assert_redirected_to welcome_path
  end

  test "should not destroy user" do
    log_in_as(@user)
    assert_no_difference("User.count") do
      delete user_url(@user)
    end
  end
end
