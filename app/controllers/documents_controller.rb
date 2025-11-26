# coding: utf-8
class DocumentsController < ApplicationController
  before_action :set_document, only: %i[ show edit update destroy ]
  protect_from_forgery :except => [:api_markdown]

  # GET /documents or /documents.json
  def index
    search_query = { combinator: "and", groupings: split_into_search_queries(params.dig(:q, :text_cont)) }
    search_query.merge!({ tags_id_eq: params[:tag_id] }) if params[:tag_id].present?

    @q = Document.ransack(search_query)
    @q.sorts = build_sort_query_with_default(params.dig(:q, :s))
    @documents = @q.result.page(params[:page]).per(50).includes(:user, :creator, :project, :tags)
    @tags = Tag.all
  end

  # GET /documents/1 or /documents/1.json
  def show
    respond_to do |format|
      format.html {}
      format.json {}
      format.text {render plain: JayFlavoredMarkdownToPlainTextConverter.new(@document.description).content}
    end
  end

  # GET /documents/new
  def new
    @document = Document.new
    @users = User.where(active: true)
    @projects = Project.all
    @tags = Tag.all
    # TODO: バージョン7.1以降では datetime_field に include_seconds オプションが導入されるため，以下の秒を0にする記述は不要になる
    @document.start_at = DateTime.current.change(sec: 0)
    @document.end_at = DateTime.current.change(sec: 0)

    project_id = params[:project_id]
    unless project_id.nil?
      @document.project ||= Project.find(project_id)
    end
  end

  # GET /documents/1/edit
  def edit
    @users = User.where(active: true)
    @projects = Project.all
    @tags = Tag.all
  end

  # POST /documents or /documents.json
  def create
    @document = current_user.documents.build(document_params)
    parse_tag_names(params[:tag_names]) if params[:tag_names]

    if @document.save #XXX: save! => save
      respond_to do |format|
        format.html { redirect_to @document, notice: "文書を追加しました" }
        format.json { render :show, status: :created, location: @document }
      end
    else
      respond_to do |format|
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @document.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /documents/1 or /documents/1.json
  def update
    parse_tag_names(params[:tag_names]) if params[:tag_names]
    if @document.update(document_params)
      flash[:success] = "文書を更新しました"
      redirect_to @document
    else
      respond_to do |format|
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @document.errors, status: :unprocessable_entity }
      end
    end
  end

  def api_markdown
    data = ::JayFlavoredMarkdownConverter.new(params[:text]).content
    render json: {text: data}
  end

  # DELETE /documents/1 or /documents/1.json
  def destroy
    @document.destroy
    respond_to do |format|
      format.html { redirect_to documents_url, notice: "文書を削除しました" }
      format.json { head :no_content }
    end
  end
  
  private

  # Use callbacks to share common setup or constraints between actions.
  def set_document
    @document = Document.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def document_params
    params.require(:document).permit(:creator_id, :content, :description, :project_id, :start_at, :end_at, :location, :text,)
  end

  def parse_tag_names(tag_names)
    @document.tags = tag_names.split.map do |tag_name|
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
    if param.present?
      param
    else
      "start_at DESC"
    end
  end
end
