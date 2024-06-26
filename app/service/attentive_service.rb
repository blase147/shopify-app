require 'httparty'

class AttentiveService
  include HTTParty
  base_uri 'https://api.attentivemobile.com'

  def self.send_message(subscriber_id, message_id)
    api_key = ENV['ATTENTIVE_API_KEY']
    endpoint = "/messages/#{message_id}/send"

    headers = {
      'Authorization' => "Bearer #{api_key}",
      'Content-Type' => 'application/json'
    }

    body = {
      subscriber_id: subscriber_id
    }

    response = self.class.post(endpoint, {
      headers: headers,
      body: body.to_json
    })

    response.parsed_response
  end
end
