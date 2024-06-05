require "test_helper"

class TaskTagTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "Should create task_tags with correct data" do
    Task.create(content: "test task")
    Tag.create(name: "test tag")
    assert TaskTag.new(task_id: Task.last.id, tag_id: Tag.last.id).valid?
  end

  test "Should not create task_tags without task_id" do
    Tag.create
    assert TaskTag.new(tag_id: Tag.last.id).invalid?
  end

  test "Should not create task_tags without tag_id" do
    Task.create
    assert TaskTag.new(task_id: Task.last.id).invalid?
  end

  test "Should delete tag which has no tasks" do
    Task.create
    Tag.create
    TaskTag.create(task_id: Task.last.id, tag_id: Tag.last.id)
    Task.last.delete
    assert Tag.last.destroy
  end

  test "Should not delete tag which has tasks" do
    skip ''
    Task.create
    Tag.create
    TaskTag.create(task_id: Task.last.id, tag_id: Tag.last.id)
    assert TaskTag.last.destroy.invalid?
  end
end
