Gibbon::Request.api_key = ENV['MAILCHIMP_API_KEY']
class MailchimpService
  BASE_URL = "https://us10.api.mailchimp.com/3.0/".freeze
  LIST_ID = ENV['MAILCHIMP_LIST_ID'].freeze

  def self.subscribe(email, status)
    url = "#{BASE_URL}lists/#{LIST_ID}/members"
    body = {
      email_address: email,
      status: "subscribed"
    }
    headers = {
      "Authorization": "Bearer #{ENV['MAILCHIMP_API_KEY']}",
      "Content-Type": "application/json"
    }
    
    begin
      response = RestClient.post(url, body.to_json, headers)
    rescue RestClient::ExceptionWithResponse => e
      error_message = JSON.parse(e.response.body)["detail"]
      Rails.logger.error "Mailchimp API Error: #{error_message}"
    end
  end
  
  def self.subscribed_emails
    list_id = ENV['MAILCHIMP_LIST_ID'] 
    begin
      gibbon = Gibbon::Request.new
      response = gibbon.lists(list_id).members.retrieve(params: { status: 'subscribed' })
      members = response.body['members']
      members.map { |member| member['email_address'] }
    rescue Gibbon::MailChimpError => e
      Rails.logger.error "Mailchimp error: #{e.message}"
      []
    end
  end
end
