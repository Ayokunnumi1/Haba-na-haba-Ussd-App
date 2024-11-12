module ApplicationHelper
  def display_navbar?
    !(controller_name == 'users' && action_name.in?(%w[new edit show]))
  end

  def form_field(form, field_type, field_name, options = {})
    label_class = 'block mb-2 text-sm font-medium text-gray-900'
    input_class = 'bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg
                   focus:ring-lightGreen focus:border-lightGreen block w-full p-2.5'

    form.label(field_name,
               class: label_class) + send("form_#{field_type}", form, field_name, options.merge(class: input_class))
  end

  private

  def form_text_field(form, field_name, options)
    form.text_field(field_name, options)
  end

  def form_email_field(form, field_name, options)
    form.email_field(field_name, options)
  end

  def form_password_field(form, field_name, options)
    form.password_field(field_name, options)
  end

  def form_telephone_field(form, field_name, options)
    form.telephone_field(field_name, options)
  end

  def form_select(form, field_name, options)
    form.select(field_name, options[:choices], { prompt: options[:prompt] }, options)
  end

  def form_file_field(form, field_name, options)
    file_input_class = 'block w-full text-sm text-gray-900 border border-gray-300 rounded-lg
                        cursor-pointer bg-gray-50 focus:outline-none'
    form.file_field(field_name, options.merge(class: file_input_class))
  end

  def form_collection_select(form, field_name, options)
    form.collection_select(field_name, options[:collection], options[:value_method], options[:text_method],
                           { prompt: options[:prompt] }, options)
  end
end
