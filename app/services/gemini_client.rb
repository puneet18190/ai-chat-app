# app/services/gemini_client.rb

require "net/http"
require "uri"
require "json"

class GeminiClient
  def self.ask(query)
    api_key = ENV["GEMINI_API_KEY"]
    model = "gemini-flash-latest"
    url = URI("https://generativelanguage.googleapis.com/v1beta/models/#{model}:generateContent?key=#{api_key}")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Post.new(url)
    request["Content-Type"] = "application/json"

    request.body = {
      contents: [
        {
          parts: [{ text: query }]
        }
      ]
    }.to_json

    response = http.request(request)
    json = JSON.parse(response.body)

    Rails.logger.info "json: #{json}"

    json.dig("candidates", 0, "content", "parts", 0, "text") || "No response"
  end
end