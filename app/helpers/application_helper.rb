module ApplicationHelper
  def display_navbar?
    !(controller_name == 'users' && action_name.in?(%w[new edit show]))
  end

  def form_field(form, field_type, field_name, options = {})
    label_class = 'block mb-2 text-sm font-medium text-gray-900'
    input_class = 'bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-lightGreen focus:border-lightGreen block w-full p-2.5'

    case field_type
    when :text_field
      form.label(field_name, class: label_class) +
        form.text_field(field_name, options.merge(class: input_class))
    when :email_field
      form.label(field_name, class: label_class) +
        form.email_field(field_name, options.merge(class: input_class))
    when :password_field
      form.label(field_name, class: label_class) +
        form.password_field(field_name, options.merge(class: input_class))
    when :telephone_field
      form.label(field_name, class: label_class) +
        form.telephone_field(field_name, options.merge(class: input_class))
    when :select
      form.label(field_name, class: label_class) +
        form.select(field_name, options[:choices], { prompt: options[:prompt] }, class: input_class)
    when :file_field
      form.label(field_name, class: label_class) +
        form.file_field(field_name,
                        class: 'block w-full text-sm text-gray-900 border border-gray-300 rounded-lg cursor-pointer bg-gray-50 focus:outline-none')
    when :collection_select
      form.label(field_name, class: label_class) +
        form.collection_select(field_name, options[:collection], options[:value_method], options[:text_method],
                               { prompt: options[:prompt] }, class: input_class)
    else
      ''
    end
  end
end
