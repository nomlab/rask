require "test_helper"

class DocumentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
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

  test "Should create document with correct data" do
    user = @user_template.clone
    Project.create(name: 'testdata', user_id: users(:one).id)
    document = Document.create(content: 'test', description: 'test', start_at: Time.now,
                                end_at: Time.now + 1.hour, location: 'Test Location',
                                user: User.last, creator: User.last, project: Project.last)
    assert document.valid?
  end

  test "Should not create document without content" do
    assert_not Document.new.save
  end

  test "Should delete document" do
    document = Document.create(content: 'test', description: 'test')
    assert document.destroy
  end

end
