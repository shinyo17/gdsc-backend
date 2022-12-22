
require 'test_helper'

class SearchAttributesGeneratorTest < ActiveSupport::TestCase
  test "search_attributes_generator's first test" do
    puts SearchAttributesGenerator.call("user")
    assert true
  end
end