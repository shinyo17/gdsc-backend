class SearchSelfMethodGenerator
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
    <<-RUBY
  require "bigram_tokenizer"
  class << self
    def staff_search(query)
      return all if query.blank?
      tokenizer = BigramTokenizer.new(query)
      template, values = tokenizer.build_tsquery
      #{query_code}
    end

    def display_index_row_attributes
      #{display_index_row_attributes_code}
    end

    def form_attributes
      #{form_attributes_code.strip}
    end
  end

  before_save :update_tsvector

  private
RUBY
  end

  def searchable_attributes
    loaded_attributes[:searchable_attributes]
  end

  def display_attributes
    loaded_attributes[:display_attributes]
  end

  def form_attributes
    attributes = []
    loaded_attributes[:form_attributes].each do |attribute|
      if attribute.is_a? String
        attributes << { attribute.to_sym => "optional" }
      else
        attributes << attribute
      end
    end
    attributes
  end

  def form_attributes_code
    keys = []
    form_attributes.each do |attribute|
      keys << attribute.keys[0].to_s
    end
    uneditable = display_attributes - keys
    editable = form_attributes
<<~RUBY
{
        editable: #{editable},
        uneditable: #{uneditable}
      }
RUBY
  end

  def display_index_row_attributes_code
    symbolized_attributes = []
    display_attributes.each do |attribute|
      symbolized_attribute = attribute.to_sym
      symbolized_attributes << symbolized_attribute
    end
    symbolized_attributes.to_s
  end

  def query_code
    queries = []

    searchable_attributes[:bigram].each do |attribute|
      query = "where(\"#{attribute}_tsvector @@ (\#{template})\", *values)"
      queries << "#{query}"
    end if searchable_attributes[:bigram]

    searchable_attributes[:trigram].each do |attribute|
      query = "where(\"#{attribute} % ?\", query)"
      queries << "#{query}"
    end if searchable_attributes[:trigram]

    searchable_attributes[:number_attributes].each do |attribute|
      query = "where(\"phone like ?\", \"%\#{query}%\")"
      queries << "#{query}"
    end if searchable_attributes[:number_attributes].present?

    first_query = queries[0]
    bracketed_query = queries.map{ |query| "(#{query})" }
    bracketed_query[0] = first_query

    query_string = bracketed_query.join(or_str)
  end

  def or_str
    <<-RUBY.gsub(/\n$/, '')

        .or
    RUBY
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