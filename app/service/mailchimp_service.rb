class MailchimpService
  def self.subscribe(email, list_id)
    begin
      Gibbon::Request.lists(list_id).members.create(body: { email_address: email, status: 'subscribed' })
    rescue Gibbon::MailChimpError => e
      if e.status_code == 404
        Rails.logger.error("Mailchimp 404 Error: #{e.raw_body}")
        raise StandardError.new("Mailchimp list not found. Please check the list ID.")
      else
        raise e
      end
    end
  end

  def self.subscribed_emails
    list_id = 'a82be852d0' 
    begin
      response = Gibbon::Request.lists(list_id).members.retrieve(params: { status: 'subscribed' })
      members = response.body['members']
      members.map { |member| member['email_address'] }
    rescue Gibbon::MailChimpError => e
      []
    end
  end
end


