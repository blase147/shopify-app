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
      # Handle successful response
      Rails.logger.debug "Mailchimp API Response: #{response}"
      return [true, "Successfully subscribed to Mailchimp list!"]
    rescue RestClient::ExceptionWithResponse => e
      # Handle error response
      error_message = JSON.parse(e.response.body)["detail"]
      Rails.logger.error "Mailchimp API Error: #{error_message}"
      if e.response.code == 400 && error_message.include?("already subscribed")
        return [true, "Email is already subscribed."]
      else
        return [false, "Email is already subscribed."]
      end
    end
  end
  
  
  def self.subscribed_emails
    list_id = ENV['MAILCHIMP_LIST_ID']
    subscribed_emails = []
  
    begin
      gibbon = Gibbon::Request.new(api_key: ENV['MAILCHIMP_API_KEY'])
  
      # Initialize pagination parameters
      offset = 0
      count = 100 # Number of emails to retrieve per request (adjust as needed)
      total = count # Initialize total to enter the loop
  
      while offset < total
        # Retrieve a batch of subscribed emails with pagination parameters
        response = gibbon.lists(list_id).members.retrieve(params: { status: 'subscribed', count: count, offset: offset })
        members = response.body['members']
        
        # Update total with the total number of subscribed members
        total = response.body['total_items']
  
        # Add retrieved emails to the subscribed_emails array
        subscribed_emails += members.map { |member| member['email_address'] }
  
        # Increment offset for the next batch
        offset += count
      end
    rescue Gibbon::MailChimpError => e
      Rails.logger.error "Mailchimp error: #{e.message}"
    end
  
    subscribed_emails
  end
  
end

