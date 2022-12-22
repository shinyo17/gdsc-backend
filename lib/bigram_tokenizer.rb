class BigramTokenizer
  def initialize(input)
    @input = input
  end

  def build_tsvector
    postings = tokenize(:index)
    postings.collect {|token, positions| "#{token}:#{positions.join('')}"}.join(" ")
  end

  def build_tsquery
    postings = tokenize(:query)
    template = postings.size.times.collect {"tsquery(?)"}.join(" <-> ")
    [template, postings.keys]
  end

  private
  def tokenize(usage)
    postings = {}
    if @input.is_a?(Array)
      texts = @input
    else
      texts = [@input]
    end
    position = 1
    texts.each do |text|
      chars = text.unicode_normalize(:nfkc).gsub(/\p{Space}/, "").chars
      chars.each_cons(2) do |char1, char2|
        token = "#{char1}#{char2}"
        postings[token] ||= []
        postings[token] << position
        position += 1
      end
      if usage == :index or chars.size == 1
        unless chars.empty?
          postings[chars.last] ||= []
          postings[chars.last] << position
          position += 1
        end
      end
      position += 1
    end
    postings
  end
end