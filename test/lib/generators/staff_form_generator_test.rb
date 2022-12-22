require "test_helper"
require "generators/staff_form/staff_form_generator"

class StaffFormGeneratorTest < Rails::Generators::TestCase
  tests StaffFormGenerator
  destination Rails.root.join("tmp/generators")
  setup :prepare_destination

  # test "generator runs without errors" do
  #   assert_nothing_raised do
  #     run_generator ["arguments"]
  #   end
  # end
end
