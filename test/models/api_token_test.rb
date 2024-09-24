require "test_helper"
require 'securerandom'

class ApiTokenTest < ActiveSupport::TestCase
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

  test "should create with correct data" do
    user = @user_template.clone
    assert ApiToken.create(secret: "rask-"+ SecureRandom.uuid, user_id: User.last.id).valid?
  end

  test "should not create api_token without secret" do
    assert_not ApiToken.new(user_id: 1).valid?
  end

  test "should not create api_token without user_id" do
    assert_not ApiToken.new(secret: "rask-"+ SecureRandom.uuid).valid?
  end

  test "should update description" do
    user = @user_template.clone
    ApiToken.create(secret:"rask-"+ SecureRandom.uuid, user_id: User.last.id)
    assert ApiToken.last.update(description: "Test")
  end

  test "should delete api_token" do
    ApiToken.create(secret:"rask-"+ SecureRandom.uuid, user_id: 1)
    assert ApiToken.last.destroy
  end

end
