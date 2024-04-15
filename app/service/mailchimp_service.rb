class MailchimpService
  API_KEY =  ENV['MAILCHIMP_API_KEY']

  def self.subscribe(email, list_id)
    begin
      gibbon = Gibbon::Request.new(api_key: API_KEY)
      list = gibbon.lists(list_id)
      response = list.members(email).retrieve

      Rails.logger.debug "Response body: #{response.body.inspect}"

      if response.body['status'] == 'subscribed'
        Rails.logger.debug "Member is already subscribed."
      else
        Rails.logger.debug "Member is not subscribed. Subscribing now..."
        list.members(email).upsert(body: { status: 'subscribed' })
      end
    rescue Gibbon::MailChimpError => e
      Rails.logger.error "Mailchimp error: #{e.message}"
      # Handle the error here as needed
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
