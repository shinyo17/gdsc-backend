class AttributesYmlGenerator < Rails::Generators::NamedBase
  source_root File.expand_path("templates", __dir__)

  def generate_file
    inject_to_yaml
  end

  private

  def inject_to_yaml
    path = "db/attributes.yml"
    regex = /\# injected attributes in models/
    code = SearchAttributesGenerator.call(underscore_model_name)
    inject_into_file(path, code, after: regex)
  end

  def singular_model_name
    if singular_gen_path.include?("/")
      singular_gen_path.split("/").last
    else
      singular_gen_path
    end
  end

  def singular_gen_path
    name.downcase.singularize
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
