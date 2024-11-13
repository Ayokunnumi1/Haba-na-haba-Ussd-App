module ApplicationHelper
  def display_navbar?
    !(controller_name == 'users' && action_name.in?(%w[new edit show]))
    !(controller_name == 'requests' && action_name.in?(%w[new edit show]))
  end
end
