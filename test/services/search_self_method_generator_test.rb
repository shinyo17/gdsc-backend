
require 'test_helper'

class SearchSelfMethodGeneratorTest < ActiveSupport::TestCase
  test "search_postgres_helper's first test" do
    puts SearchSelfMethodGenerator.call('staff_comment')
    assert true
  end

  test "wrong_model_name 넣었을 때" do
    assert_raises SearchSelfMethodGenerator::NoModelError do
      SearchSelfMethodGenerator.call('wrong_model_name')
    end
  end
end