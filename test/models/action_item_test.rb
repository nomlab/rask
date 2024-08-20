require "test_helper"

class ActionItemTest < ActiveSupport::TestCase
  test "Should create with correct data" do
    id = ActionItem.maximum(:id).to_i.next
    assert ActionItem.new(id: id, task_url: '/github.com').save
  end

  test "Should create action_item without task_url" do
    id = ActionItem.maximum(:id).to_i.next
    assert ActionItem.new(id: id).save
  end

  test "Should be existed uid to created action_item" do
    id = ActionItem.maximum(:id).to_i.next
    ActionItem.new(id: id).save
    item = ActionItem.find(id)
    assert item.uid.present?
  end

  test "Should be added task_url to created action_item" do
    assert ActionItem.last.update(task_url: '/localhost:3000')
  end

  test "Should delete action_item" do
    assert ActionItem.last.destroy
  end

  test "Should not update uid" do
    assert_not ActionItem.last.update(uid: 1)
  end

  test "Should not update task_url with string other than URL" do
    assert_not ActionItem.last.update(task_url: '#This is not url#')
  end
end
