class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy ]
  before_action :correct_user,   only: %i[ edit update destroy]

  # GET /users or /users.json
  def index
    @users = User.all
  end

  # GET /users/1 or /users/1.json
  def show
    @api_tokens = ApiToken.all
    @assigned_tasks = @user.assigned_tasks.active.desc(5)
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users or /users.json
  def create
    @user = User.new(user_params)

    if @user.save
      log_in(@user)
      flash[:success] = "ユーザ登録が完了しました"
      redirect_to tasks_path
    else
      respond_to do |format|
        format.html { redirect_to users_url }
        format.json { render status: :bad_request, json: {status: 400, message: "Bad Request"} }
      end
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: "ユーザ情報を更新しました" }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    @user.destroy
    log_out
    flash[:success] = "退会しました"
    redirect_to projects_url
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :screen_name, :active)
    end

    def correct_user
      if ! current_user?(@user)
        respond_to do |format|
          format.html { redirect_to users_url }
          format.json { render status: 404, json: { status: 404, message: 'Not Found'  }}
        end
      end
    end
end
