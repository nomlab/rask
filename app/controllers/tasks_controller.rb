# coding: utf-8
class TasksController < ApplicationController
  before_action :set_task, only: %i[ show edit update destroy ]
  before_action :logged_in_user, only: %i[ new create edit update destroy]

  # GET /tasks or /tasks.json
  def index
    @tasks = Task.all.includes(:user)
  end

  # GET /tasks/1 or /tasks/1.json
  def show
  end

  # GET /tasks/new
  def new
    @task = Task.new
    @users = User.all
    @projects = Project.all
    @states = State.all

    project_id = params[:project_id]
    unless project_id.nil?
      @task.project ||= Project.find(project_id)
    end
  end

  # GET /tasks/1/edit
  def edit
    @users = User.all
    @projects = Project.all
    @states = State.all
  end

  # POST /tasks or /tasks.json
  def create
    @task = current_user.tasks.build(task_params)

    if @task.save!
      flash[:success] = "タスクを追加しました"
      redirect_to tasks_path
    else
      redirect_back fallback_location: new_task_path
    end
  end

  # PATCH/PUT /tasks/1 or /tasks/1.json
  def update
    if @task.update(task_params)
      flash[:success] = "タスクを更新しました"
      redirect_to tasks_path
    else
      redirect_back fallback_location: edit_task_path(@task)
    end
  end

  # DELETE /tasks/1 or /tasks/1.json
  def destroy
    @task.destroy
    respond_to do |format|
      format.html { redirect_to tasks_url, notice: "タスクを削除しました" }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_task
    @task = Task.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def task_params
    params.require(:task).permit(:assigner_id, :due_at, :content, :description, :project_id, :status)
  end
end
