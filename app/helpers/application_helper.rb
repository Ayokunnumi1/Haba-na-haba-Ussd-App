module ApplicationHelper
  def display_navbar?
    controller_name == 'users' && action_name.in?(%w[new edit show])
    !(controller_name == 'requests' && action_name.in?(%w[new edit show]))
  end

  def link_to_add_fields(name, form, association)
    new_object = form.object.send(association).build
    id = new_object.object_id
    fields = form.fields_for(association, new_object, child_index: id) do |builder|
      render("#{association.to_s.singularize}_fields", f: builder)
    end
    link_to(name, '#', class: "add_fields", data: { id: id, fields: fields.delete("\n"), association: association })
  end
end
