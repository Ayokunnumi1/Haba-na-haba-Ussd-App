class UsersController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  include ErrorHandler

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
    if current_user.admin? && user_params[:role] == 'super_admin'
      flash[:alert] = 'Admins cannot update users to the role of super_admin.'
      redirect_to users_path and return
    end

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

    if current_user.admin? && user_params[:role] == 'super_admin'
      flash[:alert] = 'Admins cannot update users to the role of super_admin.'
      redirect_to users_path and return
    end

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
  rescue StandardError => e
    redirect_to users_path, alert: handle_destroy_error(e)
  end

  rescue_from CanCan::AccessDenied do |_|
    flash[:alert] = 'You are not authorized to perform this action.'
    redirect_to users_path
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :phone_number, :role, :email, :password,
                                 :password_confirmation, :branch_id, :image, :gender, :location)
  end
end
