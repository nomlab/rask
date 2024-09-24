require "test_helper"

class DocumentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def setup
    @document_templete = {
      content: 'test',
      description: 'test',
      start_at: Time.now,
      end_at: Time.now + 1.hour,
      location: 'Test Location',
      user: users(:one),
      creator: users(:one),
      project: projects(:one)
    }
  end
  test "Should create document with correct data" do
    document = Document.create(@document_templete)
    assert document.valid?
  end

  test "Should not create document without start_at" do
    document = Document.new(@document_templete)
    document.start_at = nil
    assert_not document.valid?
  end

  test "Should not create document without end_at" do
    document = Document.new(@document_templete)
    document.end_at = nil
    assert_not document.valid?
  end

  test "Should not create document without location" do
    document = Document.new(@document_templete)
    document.location = nil
    assert_not document.valid?
  end

  test "Should not create document without user" do
    document = Document.new(@document_templete)
    document.user = nil
    assert_not document.valid?
  end

  test "Should not create document without creator" do
    document = Document.new(@document_templete)
    document.creator = nil
    assert_not document.valid?
  end

  test "Should not create document without content" do
    document = Document.new(@document_templete)
    document.content = nil
    assert_not document.valid?
  end

  test "Should delete document" do
    document = Document.create(content: 'test', description: 'test')
    assert document.destroy
  end

end
