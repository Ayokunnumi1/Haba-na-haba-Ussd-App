# app/helpers/application_helper.rb

module ApplicationHelper
  def impact_item(image, size, alt, title, description)
    content_tag :div, class: "impact-grid-item" do
      concat image_tag(image, size: size, alt: alt)
      concat content_tag(:h3, title, class: "font-bold text-xl")
      concat content_tag(:p, description, class: "font-normal text-sm")
    end
  end
end
