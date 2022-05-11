require 'securerandom'

class ApiTokensController < ApplicationController
  before_action :set_api_token, only: %i[ show edit update destroy ]
  before_action :logged_in_user, only: %i[ show new create edit update destroy]

  # GET /api_tokens or /api_tokens.json
  def index
    @api_tokens = ApiToken.where(user: current_user)
  end

  # GET /api_tokens/1 or /api_tokens/1.json
  def show
  end

  # GET /api_tokens/new
  def new
    @api_token = ApiToken.new
  end

  # GET /api_tokens/1/edit
  def edit
  end

  # POST /api_tokens or /api_tokens.json
  def create
    #@api_token = ApiToken.new(api_token_params)
    @api_token = ApiToken.create(secret: "rask-"+ SecureRandom.uuid, description: params[:api_token][:description], expired_at: Time.zone.now.next_year, user_id: current_user.id)

    respond_to do |format|
      if @api_token
        format.html { redirect_to @api_token, notice: "Apiトークンを追加しました．" }
        format.json { render :show, status: :created, location: @api_token }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @api_token.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /api_tokens/1 or /api_tokens/1.json
  def update
    respond_to do |format|
      if @api_token.update(api_token_params)
        format.html { redirect_to @api_token, notice: "Apiトークンを更新しました．" }
        format.json { render :show, status: :ok, location: @api_token }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @api_token.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /api_tokens/1 or /api_tokens/1.json
  def destroy
    @api_token.destroy
    respond_to do |format|
      format.html { redirect_to api_tokens_url, notice: "Apiトークンを削除しました．" }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_api_token
      @api_token = ApiToken.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def api_token_params
      params.require(:api_token).permit(:secret, :description, :expired_at, :user_id)
    end
end
