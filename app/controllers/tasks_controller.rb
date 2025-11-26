# coding: utf-8
class TasksController < ApplicationController
  before_action :set_task, only: %i[ show edit update destroy ]
  before_action :get_form_data, only: %i[ new edit ]

  # GET /tasks or /tasks.json
  def index
    search_query = { combinator: "and", groupings: split_into_search_queries(params.dig(:q, :text_cont)) }

    session[:show_all] = params[:all] == 'true' if params[:all].present?
    search_query.merge!({ assigner_id_eq: current_user.id }) unless session[:show_all]

    session[:only_todo] = params[:only_todo] if params[:only_todo].present?
    search_query.merge!({ task_state_id_eq: TaskState.todo.id }) if session[:only_todo] == "1"

    search_query.merge!({ tags_id_eq: params[:tag_id] }) if params[:tag_id].present?

    @q = Task.ransack(search_query)
    @q.sorts = build_sort_query_with_default(params.dig(:q, :s))
    @tasks = @q.result.page(params[:page]).per(50).includes(:user, :project, :tags, :assigner, :state)
    @tags = Tag.all
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
      matched = task_params[:description].match(/\[AI([0-9]+)\]/)
      if matched != nil
        ActionItem.find(matched[1]).update(task_url: tasks_path + "/" + @task.id.to_s)
      end
      respond_to do |format|
        format.html { redirect_to @task, notice: "タスクを追加しました" }
        format.json { render :show, status: :created, location: @task }
      end
    else
      respond_to do |format|
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tasks/1 or /tasks/1.json
  def update
    parse_tag_names(params[:tag_names]) if params[:tag_names]
    if @task.update(task_params)
      respond_to do |format|
        format.html { redirect_to @task, notice: "タスクを更新しました．" }
        format.json { render :show, status: :ok, location: @task }
      end
    else
      respond_to do |format|
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
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

  # Build ransack AND search query from params
  # Example: { text_cont: "foo bar" } => [{ text_cont: "foo" }, { text_cont: "bar" }]
  def split_into_search_queries(param)
    return nil if param.nil? || param.blank?

    # Split keyword and build AND search condition
    queries = []
    words = param.split(/[\p{blank}\s]+/)
    words.each do |word|
      queries << { text_cont: word }
    end

    queries
  end

  def build_sort_query_with_default(param)
    query = ["state_priority DESC"]
    if param.present?
      query << param
    else
      query << "due_at ASC"
    end
    query
  end
end
