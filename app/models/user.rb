require "bigram_tokenizer"
class User < ApplicationRecord
  has_many :posts
  class << self
    def staff_search(query)
      return all if query.blank?
      tokenizer = BigramTokenizer.new(query)
      template, values = tokenizer.build_tsquery
      where("name_tsvector @@ (#{template})", *values)
        .or(where("username_tsvector @@ (#{template})", *values))
        .or(where("display_address_tsvector @@ (#{template})", *values))
        .or(where("email % ?", query))
        .or(where("phone like ?", "%#{query}%"))
    end

    def display_index_row_attributes
      [:email, :name, :username, :phone, :display_address]
    end
  end

  before_save :update_tsvector

  private

  def update_tsvector
    self.name_tsvector = build_tsvector(name)
    self.username_tsvector = build_tsvector(username)
    self.display_address_tsvector = build_tsvector(display_address)
  end

  def build_tsvector(input)
    return nil if input.blank?
    tokenizer = BigramTokenizer.new(input)
    tokenizer.build_tsvector
  end
end
