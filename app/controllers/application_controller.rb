class ApplicationController < ActionController::Base
  include CanCan::ControllerAdditions
  def after_sign_in_path_for(_resource)
    authenticated_root_path
  end
end
