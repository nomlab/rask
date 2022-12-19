# coding: utf-8
class DocumentsController < ApplicationController
  before_action :set_document, only: %i[ show edit update destroy ]
  before_action :logged_in_user, only: %i[ new create edit update destroy]
  protect_from_forgery :except => [:api_markdown]
  before_action :search

  def search
    # q is the value entered in the search form
    @q = Document.ransack(params[:q])
  end

  # GET /documents or /documents.json
  def index
  #  @documents = Document.page(params[:page]).per(50).includes(:user).order(start_at: "DESC")
    @documents = @q.result.page(params[:page]).per(50).includes(:user).order(start_at: "DESC")
  end

  # GET /documents/1 or /documents/1.json
  def show
  end

  # GET /documents/new
  def new
    @document = Document.new
    @users = User.all
    @projects = Project.all
    @tags = Tag.all

    project_id = params[:project_id]
    unless project_id.nil?
      @document.project ||= Project.find(project_id)
    end
  end

  # GET /documents/1/edit
  def edit
    @users = User.all
    @projects = Project.all
    @tags = Tag.all
  end

  # POST /documents or /documents.json
  def create
    @document = current_user.documents.build(document_params)
    parse_tag_names(params[:tag_names]) if params[:tag_names]

    if @document.save #XXX: save! => save
      Document.find_by(id: @document.id).update(keyword: "#{@document.content}" + "#{@document.assigner.name}" + @document.project.name)
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
      Document.find_by(id: @document.id).update(keyword: "#{@document.content}" + "#{@document.assigner.name}" + @document.project.name)
      flash[:success] = "文書を更新しました"
      redirect_to documents_path
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
    params.require(:document).permit(:assigner_id, :content, :description, :project_id, :start_at, :end_at, :location, :text,)
  end

  def parse_tag_names(tag_names)
    @document.tags = tag_names.split.map do |tag_name|
      tag = Tag.find_by(name: tag_name)
      tag ? tag : Tag.create(name: tag_name)
    end
  end
end
