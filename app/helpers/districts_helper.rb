module DistrictsHelper
  # Helper method to add new fields dynamically for counties and sub-counties
  def link_to_add_fields(name, form, association)
    new_object = form.object.send(association).klass.new
    id = new_object.object_id
    fields = form.fields_for(association, new_object, child_index: id) do |builder|
      if association == :counties
        render_inline_county_fields(builder)
      elsif association == :sub_counties
        render_inline_sub_county_fields(builder)
      end
    end
    # Return a link to add fields with the generated HTML for new fields
    link_to(name, '#', class: "add_fields text-white bg-lightGreen font-bold py-3 px-6 rounded-md hover:bg-lightGreen-dark focus:outline-none focus:ring-2 focus:ring-lightGreen-dark active:bg-lightGreen-dark", data: { association: association, fields: fields.delete("\n") })
  end

  private

  # Render the inline fields for counties
  def render_inline_county_fields(builder)
    content_tag(:div, class: "nested-fields mt-5") do
      concat builder.label :name,"County Name", class: "block text-gray-700 text-sm font-bold mb-2" 
      concat builder.text_field :name, class: "shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline"
      concat builder.check_box :_destroy
      concat builder.label :_destroy, "Remove County", class: "text-red-500 ml-2"
      concat content_tag(:h4, "Sub-Counties" , class:"text-xl font-bold mb-4") do
        builder.fields_for :sub_counties do |sub_county_fields|
          render_inline_sub_county_fields(sub_county_fields)
        end
      end
      
      concat link_to_add_fields("Add Sub-County", builder, :sub_counties)
      
    end
  end

  # Render the inline fields for sub-counties
  def render_inline_sub_county_fields(builder)
    content_tag(:div, class: "nested-fields mb-5") do
      concat builder.label :name, "Sub-County Name" ,class: "block text-gray-700 text-sm font-bold mb-2"
      concat builder.text_field :name, class: "shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline"
      concat builder.check_box :_destroy
      concat builder.label :_destroy, "Remove Sub-County", class: "text-red-500 ml-2"
    end
  end
end
