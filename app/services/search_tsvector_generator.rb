class SearchTsvectorGenerator
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
    <<-RUBY.chomp


  def update_tsvector
    #{update_tsvector_code.join(new_line)}
  end

  def build_tsvector(input)
    return nil if input.blank?
    tokenizer = BigramTokenizer.new(input)
    tokenizer.build_tsvector
  end
RUBY
  end

  def new_line
    '
    '
  end

  def update_tsvector_code
    bigram = []
    searchable_attributes[:bigram].each do |attribute|
      update_tsvector = "self.#{attribute}_tsvector = build_tsvector(#{attribute})"
      bigram << "#{update_tsvector}"
    end
    bigram
  end

  def searchable_attributes
    loaded_attributes[:searchable_attributes]
  end

  def loaded_attributes
    attributes = YAML.load_file('db/attributes.yml')
    model_attributes = attributes[model_name]
    begin
      result = model_attributes.deep_symbolize_keys
    rescue NoMethodError => e
      raise NoModelError.new(model_name)
    end
    result
  end

  class NoModelError < StandardError
    def initialize(model_name)
      @model_name = model_name
    end

    def message
      "index 생성 실패. #{@model_name} 의 정의가 db/attributes.yml 에 있는지 확인해주세요."
    end
  end
end