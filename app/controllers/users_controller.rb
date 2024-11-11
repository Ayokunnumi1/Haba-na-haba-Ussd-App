class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:show, :edit, :update, :destroy, :edit_profile, :update_profile]
  before_action :authorize_user, only: [:edit, :update, :destroy]

  def index
    @users = User.all
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

  def edit_profile
  end

  def update_profile
    if params[:user][:remove_image] == "true"
      @user.image.purge if @user.image.attached?
    end

    if @user.update(user_params)
      flash[:notice] = 'Your profile was successfully updated.'
      redirect_to edit_profile_user_path(@user)
    else
      flash[:alert] = 'There was an error updating your profile.'
      render :edit_profile
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def authorize_user
    redirect_to root_path, alert: 'Not authorized' unless @user == current_user || current_user.admin?
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :phone_number, :role, :email, :password,
                                 :password_confirmation, :branch_id, :image)
  end
end
