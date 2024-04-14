require 'rest-client'
require 'json'

class KlaviyoService
  def self.subscribe(phone_number)
    klaviyo_list_id = 'S9HTBg'
    Klaviyo::List.subscribe(klaviyo_list_id, { profiles: [{ phone_number: phone_number }] })
  end

  BASE_URL = 'https://a.klaviyo.com/api/lists/'
  REVISION = '2024-02-15'

  def self.subscribed_phone_numbers(api_key, list_id)
    api_key = 'pk_34cec0528c92d55f4a9862d50f292e36a6'
    list_id = 'S9HTBg'


    url = "#{BASE_URL}#{list_id}/members?status=subscribed"
    headers = {
      'Authorization': "Klaviyo-API-Key #{api_key}",
      'accept': 'application/json',
      'revision': REVISION
    }

    response = RestClient.get(url, headers)
    data = JSON.parse(response.body)

    phone_numbers = data['data'].map do |member|
      member['profile']['$phone_number']
    end

    phone_numbers
  rescue RestClient::ExceptionWithResponse => e
    # Handle errors
    puts "Error fetching subscribed phone numbers: #{e.response}"
    []
  end

end
