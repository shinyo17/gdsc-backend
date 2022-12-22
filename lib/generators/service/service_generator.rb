# frozen_string_literal: true

class ServiceGenerator < Rails::Generators::NamedBase
  source_root File.expand_path("templates", __dir__)

  def generate_file
    template "service.rb.erb", "app/services/#{service_file_name}.rb"
    template "service_test.rb.erb", "test/services/#{service_file_name}_test.rb"
    sync = "rails test test/services/#{service_file_name}_test.rb"
    puts ""
    puts sync
    puts ""
    system(sync)
  end

  private
    def service_class_name
      name.classify + "Service"
    end

    def service_file_name
      name.underscore + "_service"
    end
end
