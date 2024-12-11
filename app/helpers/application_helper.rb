# app/helpers/application_helper.rb

module ApplicationHelper
  def impact_item(image, size, alt, title, description)
    content_tag :div, class: 'impact-grid-item' do
      concat image_tag(image, size: size, alt: alt)
      concat content_tag(:h3, title, class: 'font-bold text-xl lg:text-3.8xl lg:mt-4')
      concat content_tag(:p, description, class: 'font-normal text-sm lg:text-base lg:mt-4')
    end
    def display_navbar?
      controller_name == 'users' && action_name.in?(%w[new edit show]) &&
      !(controller_name == 'requests' && action_name.in?(%w[new edit show]))
    end
  end
end
