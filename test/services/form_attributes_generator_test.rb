
require 'test_helper'

class FormAttributesGeneratorTest < ActiveSupport::TestCase
  test "search_postgres_helper's first test" do
    FormAttributesGenerator.call('staff_comment')
    assert true
  end
end