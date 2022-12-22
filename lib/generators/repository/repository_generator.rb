# frozen_string_literal: true

class RepositoryGenerator < Rails::Generators::NamedBase
  source_root File.expand_path("templates", __dir__)

  def generate_file
    template "repository.rb.erb", "app/repositories/#{repository_file_name}.rb"
    template "repository_spec.rb.erb", "spec/repositories/#{repository_file_name}_spec.rb"
  end

  private
    def repository_class_name
      name.classify + "Repository"
    end

    def repository_file_name
      name.underscore + "_repository"
    end

    def collections_name
      name.underscore.pluralize
    end

    def model_class_name
      name.classify
    end
end
