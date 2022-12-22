class StaffComment < ApplicationRecord
  require "bigram_tokenizer"

  include StaffAuditable

  class << self
    def staff_search(query)
      return all if query.blank?
      tokenizer = BigramTokenizer.new(query)
      template, values = tokenizer.build_tsquery
      where("staff_name_tsvector @@ (#{template})", *values)
        .or(where("body_tsvector @@ (#{template})", *values))
        .or(where("path % ?", query))
    end

    def display_index_row_attributes
      [:id, :staff_name, :body, :path, :created_at, :updated_at]
    end

    def form_attributes
      {
        editable: [{:body=>"required"}, {:path=>"optional"}],
        uneditable: ["id", "staff_name", "created_at", "updated_at"]
      }
    end
  end

  belongs_to :staff_user
  before_save :update_tsvector

  private

  def update_tsvector
    self.staff_name_tsvector = build_tsvector(staff_name)
    self.body_tsvector = build_tsvector(body)
  end

  def build_tsvector(input)
    return nil if input.blank?
    tokenizer = BigramTokenizer.new(input)
    tokenizer.build_tsvector
  end

end
