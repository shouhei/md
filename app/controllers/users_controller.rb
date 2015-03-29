class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :login_check, only: [:index, :show, :update, :destroy, :logout]

  # GET /users/1
  # GET /users/1.json
  def show
    @num_posts = Post.where(user_id: session[:id]).count;
    logger.debug(@num_posts);
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def login
    if !request.post?
      return
    end
    user = User.find_by_name params[:name]
    if user && user.authenticate(params[:pass])
      session[:user_id] = user.id
      redirect_to '/posts'
    else
      flash.now.alert = "Invalid"
    end
  end

  def logout
    session[:user_id] = nil
    redirect_to '/users/login'
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:name, :password, :password_confirmation)
  end

  def is_your_data?
    if session[:user_id] != params[:id]
      redirect_to posts_path, notice: "That page is not your's "
    end
  end

end
