require 'rest-client'
require 'json'

class KlaviyoService
  BASE_URL = 'https://a.klaviyo.com/api/lists/'.freeze
  REVISION = '2024-02-15'.freeze

  def self.subscribe(phone_number)
    api_key = ENV['KLAVIYO_API_KEY']
    list_id = ENV['KLAVIYO_LIST_ID']

    url = "#{BASE_URL}#{list_id}/members"
    headers = {
      'Authorization': "Klaviyo-API-Key #{api_key}",
      'Content-Type': 'application/json',
      'revision': REVISION
    }
    body = {
      profiles: [{ phone_number: phone_number }]
    }

    response = RestClient.post(url, body.to_json, headers)
    # Handle response
    response_code = response.code
    response_body = JSON.parse(response.body)
    # Return appropriate response based on the response_code and response_body
  rescue RestClient::ExceptionWithResponse => e
    # Handle errors
    puts "Error subscribing phone number: #{e.response}"
    # Return appropriate response based on the error
  end

  def self.subscribed_phone_numbers
    list_id = ENV['KLAVIYO_LIST_ID']
    api_key = ENV['KLAVIYO_API_KEY']

    return [] unless list_id

    url = "#{BASE_URL}#{list_id}/members?status=subscribed"
    headers = {
      'Authorization': "Klaviyo-API-Key #{api_key}",
      'accept': 'application/json',
      'revision': REVISION
    }

    response = RestClient.get(url, headers)
    data = JSON.parse(response.body)

    phone_numbers = data['data'].map { |member| member['profile']['$phone_number'] }
    phone_numbers
  rescue RestClient::ExceptionWithResponse => e
    # Handle errors
    puts "Error fetching subscribed phone numbers: #{e.response}"
    # Return appropriate response based on the error
    []
  end
end
