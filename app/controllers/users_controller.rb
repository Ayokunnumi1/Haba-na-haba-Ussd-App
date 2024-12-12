class UsersController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

  def index
    @users = User.order(created_at: :desc)
    @roles = User::ROLES
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to users_path, notice: 'user was successfully created.'
    else
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    authorize! :update, User  
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(@user), notice: 'User was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:id])

    if @user == current_user
      flash[:alert] = 'You cannot delete your own account.'
    else
      @user.destroy
      flash[:notice] = 'User was successfully deleted.'
    end
    redirect_to users_path
  end

  rescue_from CanCan::AccessDenied do |exception|
    flash[:alert] = "You are not authorized to perform this action."
    redirect_back(fallback_location: users_path)
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :phone_number, :role, :email, :password,
                                 :password_confirmation, :branch_id, :image, :gender, :location)
  end
end
