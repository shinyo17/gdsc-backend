class FormAttributesGenerator
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
    form_attributes.each do |attribute|
      form_type = "default"
      form_type = attribute.values[0] if attribute.is_a? Hash
      begin
        puts send("#{form_type}_attribute", attribute)
      rescue NoMethodError => e
        raise FormTypeError.new(form_type)
      end
    end
  end

  def form_attributes
    loaded_attributes[:form_attributes]
  end

  def default_attribute(attribute)
    <<-HTML
    <div>
        <%= f.label :#{attribute}, class: "block text-sm font-medium mb-1" %>
        <%= f.text_field :#{attribute}, class: "form-input w-full" %>
    </div>
HTML
  end

  def required_attribute(attribute)
    attribute_name = attribute.keys[0]
    <<-HTML
    <div>
        <%= f.label :#{attribute_name}, class: "block text-sm font-medium mb-1" %>
        <%= f.text_field :#{attribute_name}, class: "form-input w-full", required: true %>
    </div>
HTML
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

  class FormTypeError < StandardError
    def initialize(form_type)
      @form_type = form_type
    end

    def message
      "[#{@form_type}] 형태의 form type 은 정의되지 않았음. 오타 확인 해보세요."
    end
  end
end