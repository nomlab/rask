# coding: utf-8
class TasksController < ApplicationController
  before_action :set_task, only: %i[ show edit update destroy ]
  before_action :get_form_data, only: %i[ new edit ]

  def search_check(param)
    if param.present?
      key_words = param.split(/[\p{blank}\s]+/)
      grouping_hash = key_words.reduce({}) { |hash, word| hash.merge(word => { content_or_assigner_screen_name_or_description_or_project_name_cont: word }) }
    else
      nil
    end
  end

  def sort_check(param)
    if param.present?
      sort_column = []
      sort_column << "state_priority DESC" << param
    else
      "state_priority DESC"
    end
  end

  # GET /tasks or /tasks.json
  def index
    if params[:q].nil?
      @q = Task.joins(:state).ransack(params[:q])
      @q.sorts = ["state_priority DESC", "due_at ASC"]
    else
      @q = Task.joins(:state).ransack({combinator: 'and', groupings: search_check(params[:q][:content_or_assigner_screen_name_or_description_or_project_name_cont])})
      @q.sorts = sort_check(params[:q][:s])
    end
    @tasks = @q.result.page(params[:page]).per(50).includes(:user, :state)

    return unless params[:only_todo] == '1'

    @tasks = @tasks.where(task_state_id: TaskState.find_by(name: 'todo').id)
  end

  # GET /tasks/1 or /tasks/1.json
  def show
  end

  # GET /tasks/new
  def new
    @task = Task.new
    @task.assigner_id = params[:assigner_id] || current_user.id
    @task.content = params[:selected_str]
    @task.description = params[:desc_header]
    @task.due_at = Date.current + 14

    project_id = params[:project_id]
    unless project_id.nil?
      @task.project ||= Project.find(project_id)
    end
  end

  # GET /tasks/1/edit
  def edit
  end

  # POST /tasks or /tasks.json
  def create
    @task = current_user.tasks.build(task_params)
    parse_tag_names(params[:tag_names]) if params[:tag_names]

    if @task.save!
      flash[:success] = "タスクを追加しました"
      matched = task_params[:description].match(/\[AI([0-9]+)\]/)
      if matched != nil
        ActionItem.find(matched[1]).update(task_url: tasks_path + "/" + @task.id.to_s)
      end
      redirect_to tasks_path
    else
      redirect_back fallback_location: new_task_path
    end
  end

  # PATCH/PUT /tasks/1 or /tasks/1.json
  def update
    parse_tag_names(params[:tag_names]) if params[:tag_names]
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

  def get_form_data
    @users = User.where(active: true)
    @projects = Project.all
    @tags = Tag.all
    @task_states = TaskState.all
  end

  # Only allow a list of trusted parameters through.
  def task_params
    params.require(:task).permit(:assigner_id, :due_at, :content, :description, :project_id, :task_state_id)
  end

  def parse_tag_names(tag_names)
    @task.tags = tag_names.split.map do |tag_name|
      tag = Tag.find_by(name: tag_name)
      tag ? tag : Tag.create(name: tag_name)
    end
  end
end
