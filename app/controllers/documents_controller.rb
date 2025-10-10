# coding: utf-8
class DocumentsController < ApplicationController
  before_action :set_document, only: %i[ show edit update destroy ]
  protect_from_forgery :except => [:api_markdown]

  def search_check(param)
    if param.present?
      key_words = param.split(/[\p{blank}\s]+/)
      grouping_hash = key_words.reduce({}) {|hash, word| hash.merge(word => {content_or_creator_screen_name_or_description_or_project_name_or_location_cont: word})}
    else
      nil
    end
  end

  def sort_check(param)
    if param.present?
      sort_column = []
      sort_column << param
    else
      "start_at DESC"
    end
  end

  # GET /documents or /documents.json
  def index
    if params[:q].nil?
      @q = Document.ransack(params[:q])
      @q.sorts = "start_at DESC"
    else
      @q = Document.ransack({combinator: 'and', groupings: search_check(params[:q][:content_or_creator_screen_name_or_description_or_project_name_or_location_cont])})
      @q.sorts = sort_check(params[:q][:s])
    end  
    @documents = @q.result.page(params[:page]).per(50).includes(:user)
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
      flash[:success] = "文書を追加しました"
      redirect_to documents_path
    else
      redirect_back fallback_location: new_document_path
    end
  end

  # PATCH/PUT /documents/1 or /documents/1.json
  def update
    parse_tag_names(params[:tag_names]) if params[:tag_names]
    if @document.update(document_params)
      flash[:success] = "文書を更新しました"
      redirect_to @document
    else
      redirect_back fallback_location: edit_document_path(@document)
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

end
