require "test_helper"

class UserTest < ActiveSupport::TestCase
  def setup
    @user_template = {
      name: "Test User",
      screen_name: "test-user",
      provider: "test-provider",
      password_digest: "password",
      uid: "test-uid",
      avatar_url: "test-url",
      active: true
    }
  end

  test "should create user with correct data" do
    user = @user_template.clone
    assert User.new(user).save
  end

  test "should not create user without name" do
    skip ''
    user = @user_template.clone
    user[:name] = nil
    assert_not User.new(user).save
  end

  test "should not create user without screen_name" do
    skip ''
    user = @user_template.clone
    user[:screen_name] = nil
    assert_not User.new(user).save
  end

  test "should not create user without provider" do
    user = @user_template.clone
    user[:provider] = nil
    assert_not User.new(user).save
  end

  test "should not create user without uid" do
    skip ''
    user = @user_template.clone
    user[:uid] = nil
    assert_not User.new(user).save
  end

  test "should create github user with empty password_digest" do
    user = @user_template.clone
    user[:provider] = "github"
    user[:password_digest] = nil
    assert User.new(user).save
  end

  test "should not create local user with empty password_digest" do
    user = @user_template.clone
    user[:provider] = "local"
    user[:password_digest] = nil
    assert_not User.new(user).save
  end

  test "should not create user with_same_name" do
    skip ''
    user = @user_template.clone
    User.create(user)
    user[:screen_name] ="other_screen_name"
    user[:uid] ="other_uid"
    assert_not User.new(user).save
  end

  test "should not create user with_same_screen_name" do
    user = @user_template.clone
    User.create(user)
    user[:name] ="other_name"
    user[:uid] ="other_uid"
    assert_not User.new(user).save
  end

  test "should not create user with_same_uid" do
    skip ''
    user = @user_template.clone
    User.create(user)
    user[:name] ="other_name"
    user[:screen_name] ="other_screen_name"
    assert_not User.new(user).save
  end

  test "should not delete user" do
    skip ''
    user = @user_template.clone
    user = User.create(user)
    assert_not user.destroy
  end
end
