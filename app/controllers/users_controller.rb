class UsersController < ApplicationController
  include ErrorHandler
  before_action :authenticate_user!
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :authorize_user!, only: [:create, :update, :destroy]
  before_action :check_admin_access, only: [:edit]

  def index
    @users = User.order(created_at: :desc)
    @roles = User::ROLES
  end

  def show
  end

  def new
    @user = User.new
    authorize! :create, @user
  end

  def create
    @user = User.new(user_params)
    authorize! :create, @user
    if @user.save
      redirect_to users_path, notice: 'User was successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    authorize! :update, @user
    if @user.update(user_params)
      redirect_to user_path(@user), notice: 'User was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    if @user == current_user
      flash[:alert] = 'You cannot delete your own account.'
    else
      authorize! :destroy, @user
      begin
        @user.destroy
        flash[:notice] = 'User was successfully deleted.'
      rescue => e
        flash[:alert] = handle_destroy_error(e)
      end
    end
    redirect_to users_path
  end
  
  private

  def set_user
    @user = User.find(params[:id])
  end


  def check_admin_access
    # Only restrict access to the edit page for admin and super_admin users
    if current_user.role == 'admin' 
      # Prevent admins or super admins from editing themselves or other admin/super_admin users
      if @user.role == 'admin' || @user.role == 'super_admin'
        redirect_to users_path, alert: "You do not have permission to edit this user."
      end
    end
  end
  

  def authorize_user!
    if current_user.role == 'admin'
      if action_name.to_sym == :create
        # Admin should not be able to create super_admin or admin users
        if %w[super_admin].include?(params[:user][:role])
          begin
            raise CanCan::AccessDenied.new("Not authorized to create users with role #{params[:user][:role]}")
          rescue CanCan::AccessDenied => e
            flash[:alert] = e.message  # Set the flash alert message
            redirect_to users_path  # Redirect to the appropriate path (e.g., users list)
          end
        end
      elsif action_name.to_sym == :update || action_name.to_sym == :destroy
        # Admin should not be able to update or destroy super_admin or admin users
        if %w[super_admin admin].include?(@user.role)
          begin
            raise CanCan::AccessDenied.new("Not authorized to #{action_name} users with role #{@user.role}")
          rescue CanCan::AccessDenied => e
            flash[:alert] = e.message  # Set the flash alert message
            redirect_to users_path  # Redirect to the appropriate path (e.g., users list)
          end
        end
      end
    end
  end
  

  def user_params
    params.require(:user).permit(:first_name, :last_name, :phone_number, :role, :email, :password,
                                 :password_confirmation, :branch_id, :image, :gender, :location)
  end
end
