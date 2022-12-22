
require 'test_helper'

class SearchTsvectorGeneratorTest < ActiveSupport::TestCase
  test "search_tsvector_generator's first test" do
    puts SearchTsvectorGenerator.call("user")
    assert true
  end
end