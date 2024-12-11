class ApplicationController < ActionController::Base
  include CanCan::ControllerAdditions
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to authenticated_root_path, alert: "Sorry, you don't have permission to perform this action."
  end
  def after_sign_in_path_for(_resource)
    authenticated_root_path
  end
end
