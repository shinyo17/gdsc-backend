module SolapiRequest
  def message_post(body)
    path = '/messages/v4/send'
    uri = get_uri(path)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    req = Net::HTTP::Post.new(uri.path, 'Content-Type' => 'application/json')
    req.add_field('Authorization', header)
    from = config["from"]
    from = body[:message][:from] if body[:message][:from].present?
    base_body = { from: from }
    base_country = config["country"]
    country = base_country
    country = body[:message][:country] if body[:message][:country].present?
    base_body = base_body.merge({ country: country} )
    message = {message: base_body}
    body[:message] = body[:message].merge(base_body)
    req.body = body.to_json
    res = http.request(req)
    JSON.parse(res.body)
  end

  private

  def config
    YAML.load_file('config/solapi.yml')
  end

  def get_uri(path)
    str = "#{config['protocol']}://#{config['domain']}#{config['prefix']}"
    uri = URI(str + path)
  end

  def header
    api_key = config['api_key']
    api_secret = config['api_secret']
    date = Time.now.strftime('%Y-%m-%dT%H:%M:%S.%L%z')
    salt = SecureRandom.hex
    signature = OpenSSL::HMAC.hexdigest('SHA256', api_secret, date + salt)
    'HMAC-SHA256 apiKey=' + api_key + ', date=' + date + ', salt=' + salt + ', signature=' + signature
  end
end