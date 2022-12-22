class SearchAttributesGenerator
  attr_reader :model_name

  def initialize(model_name)
    @model_name = model_name
  end

  def self.call(*args, &block)
    new(*args, &block).call
  end

  def call
    result
  end

  private

  def result
    yamled_hash.gsub(/^---/, '')
  end

  def yamled_hash
    result = {}
    display_attributes = { "display_attributes" => all_attributes }
    base_attributes = ["id", "created_at", "updated_at"]
    bigram = { "bigram" => all_attributes - base_attributes }
    trigram = { "trigram" => ["someting"] }
    number_attributes = { "number_attributes" => ["someting"] }
    search = { "searchable_attributes" => {}.merge(bigram, trigram, number_attributes) }
    { model_name => result.merge(display_attributes, search) }.to_yaml
  end

  def new_line
    '
'
  end

  def all_attributes
    begin
      result = model_name.classify.constantize.new.attributes.keys
    rescue NameError => e
      raise NoModelError.new(model_name)
    end
    result
  end

  class NoModelError < StandardError
    def initialize(model_name)
      @model_name = model_name
    end

    def message
      "생성 실패. #{@model_name} -> 이 모델은 없는 것 같다."
    end
  end
end