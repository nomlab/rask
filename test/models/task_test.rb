require "test_helper"

class TaskTest < ActiveSupport::TestCase
  def setup
    @task_template = {
      creator_id: users(:one).id,
      assigner_id: users(:two).id,
      due_at: Time.zone.now,
      project_id: projects(:one).id,
      task_state_id: task_states(:todo).id,
      content: "test_task",
      description: "This is test task"
    }
  end

  test "should create task with correct data" do
    task = @task_template.clone
    assert Task.new(task).save
  end

  test "should not create task without creator_id" do
    task = @task_template.clone
    task[:creator_id] = nil
    assert_not Task.new(task).save
  end

  test "should not create task without content" do
    task = @task_template.clone
    task[:content] = nil
    assert_not Task.new(task).save
  end

  test "should not create task without task_state_id" do
    task = @task_template.clone
    task[:task_state_id] = nil
    assert_not Task.new(task).save
  end

  test "should delete task" do
    task = @task_template.clone
    task = Task.create(task)
    assert task.destroy
  end

  test "should return false for completed? method of todo task" do
    task = @task_template.clone
    task[:task_state_id] = task_states(:todo).id
    task = Task.create(task)
    assert task.completed? == false
  end

  test "should return true for completed? method of done task" do
    task = @task_template.clone
    task[:task_state_id] = task_states(:done).id
    task = Task.create(task)
    assert task.completed? == true
  end
end
