class StaffFormGenerator < Rails::Generators::NamedBase
  source_root File.expand_path("templates", __dir__)

  def generate_file
    # return false if gsub_files == false
    template "new.html.erb", "app/views/staff/#{plural_gen_path}/new.html.erb"
    template "edit.html.erb", "app/views/staff/#{plural_gen_path}/edit.html.erb"
    template "_new_form.html.erb", "app/views/staff/#{plural_gen_path}/_new_form.html.erb"
    template "_edit_form.html.erb", "app/views/staff/#{plural_gen_path}/_edit_form.html.erb"
  end

  private

  def gsub_files
    # klass = name.classify
    # path = "app/models/#{singular_model_name}.rb"
    # begin
    #   self_methods = model_self_methods
    # rescue SearchSelfMethodGenerator::NoModelError => e
    #   puts "--->"
    #   puts e.message
    #   puts "rails g attributes_yml #{singular_model_name}"
    #   return false
    # end
    # inject_into_class(path, klass, self_methods)
    # regex = /private/
    # inject_into_file(path, update_tsvector_code, after: regex)
  end

  def column_names
    names = [:name]
    not_model_class = Kernel.const_defined?(singular_model_camel_name) == false
    return names if not_model_class
    %I[created_at updated_at id]
  end

  def column_symbols
    column_names.map { |column| ":#{column}" }.join(", ")
  end

  def singular_model_name
    if singular_gen_path.include?("/")
      singular_gen_path.split("/").last
    else
      singular_gen_path
    end
  end

  def singular_model_name_capitalize
    singular_model_name.capitalize
  end

  def plural_model_name
    if plural_gen_path.include?("/")
      plural_gen_path.split("/").last
    else
      plural_gen_path
    end
  end

  def file_path
    if singular_gen_path.include?("/")
      namespace = singular_gen_path.split("/").first
      "#{namespace}_#{plural_model_name}_path"
    else
      "#{plural_model_name}_path"
    end
  end

  def singular_gen_path
    name.downcase.singularize
  end

  def plural_gen_path
    name.downcase.pluralize
  end

  def singular_model_camel_name
    singular_model_name.classify
  end

  def camel_controller_name
    name.classify.pluralize
  end

  def underscore_controller_name
    name.underscore.pluralize
  end

  def underscore_model_name
    underscored = name.underscore.singularize
    if underscored.include?("/")
      underscored.split("/").join("_")
    else
      underscored
    end
  end
end
