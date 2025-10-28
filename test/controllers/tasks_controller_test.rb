require "test_helper"

class TasksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @task = tasks(:one)
    @user = users(:one)
    @task.user = @user
    OmniAuth.config.test_mode = true
  end

  test "should redirect to get index without login" do
    get tasks_url
    assert_redirected_to welcome_path
  end

  test "should get index with login" do
    log_in_as(@user)
    get tasks_url
    assert_response :success
  end

  test "should get new" do
    log_in_as(@user)
    get new_task_url
    assert_response :success
  end

  test "should redirect new to login" do
    get new_task_url
    assert_redirected_to welcome_path
  end

  test "should create task" do
    log_in_as(@user)
    assert_difference('Task.count') do
      post tasks_url, params: { task: { content: @task.content, creator_id: @task.creator_id, assigner_id: @task.assigner_id , due_at: @task.due_at, description: @task.description, project_id: @task.project_id, task_state_id: @task.task_state_id} }
    end

    assert_redirected_to task_url(Task.last)
  end

  test "should redirect create to login" do
    post tasks_url, params: { task: { content: @task.content, creator_id: @task.creator_id, assigner_id: @task.assigner_id , due_at: @task.due_at, description: @task.description} }
    assert_redirected_to welcome_path
  end

  test "should redirect edit to login" do
    get edit_task_url(@task)
    assert_redirected_to welcome_path
  end

  test "should get edit" do
    log_in_as(users(:one))
    get edit_task_url(@task)
    assert_response :success
  end

  test "should update task" do
    log_in_as(@user)
    patch task_url(@task), params: { task: { content: @task.content, creator_id: @task.creator_id, task_state_id: @task.task_state_id } }
    assert_redirected_to task_url(@task)
  end

  test "should redirect update to login" do
    patch task_url(@task), params: { task: { content: @task.content, creator_id: @task.creator_id } }
    assert_redirected_to welcome_path
  end

  test "should destroy task" do
    log_in_as(users(:one))
    assert_difference('Task.count', -1) do
      delete task_url(@task)
    end

    assert_redirected_to tasks_url
  end

  test "should redirect destroy to login" do
    delete task_url(@task)
    assert_redirected_to welcome_path
  end
end
