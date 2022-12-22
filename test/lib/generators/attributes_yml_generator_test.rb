require "test_helper"
require "generators/attributes_yml/attributes_yml_generator"

class AttributesYmlGeneratorTest < Rails::Generators::TestCase
  tests AttributesYmlGenerator
  destination Rails.root.join("tmp/generators")
  setup :prepare_destination

  # test "generator runs without errors" do
  #   assert_nothing_raised do
  #     run_generator ["arguments"]
  #   end
  # end
end
