class MailchimpService
  API_KEY = ENV['MAILCHIMP_API_KEY']

  def self.subscribe(email, list_id)
    begin
      gibbon = Gibbon::Request.new(api_key: API_KEY)
      list = gibbon.lists(list_id)
  
      # Check if the email is already subscribed
      response = list.members(email).retrieve
      if response.body['status'] == 'subscribed'
        Rails.logger.debug "Member is already subscribed."
      else
        # Subscribe the email
        Rails.logger.debug "Member is not subscribed. Subscribing now..."
        list.members.create(body: { email_address: email, status: 'subscribed' })
      end
    rescue Gibbon::MailChimpError => e
      if e.status_code == 404
        # Member not found, so subscribe the email
        Rails.logger.debug "Member not found. Subscribing now..."
        list.members.create(body: { email_address: email, status: 'subscribed' })
      else
        Rails.logger.error "Mailchimp error: #{e.message}"
        # Handle the error here as needed
      end
    end
  end
  
  def self.subscribed_emails
    list_id = 'a82be852d0' 
    begin
      gibbon = Gibbon::Request.new(api_key: API_KEY)
      response = gibbon.lists(list_id).members.retrieve(params: { status: 'subscribed' })
      members = response.body['members']
      members.map { |member| member['email_address'] }
    rescue Gibbon::MailChimpError => e
      Rails.logger.error "Mailchimp error: #{e.message}"
      []
    end
  end
end
