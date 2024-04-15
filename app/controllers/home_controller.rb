require_relative '../service/mailchimp_service'

class HomeController < ApplicationController 
  def index
    @welcome_message = "Welcome to Our Website"
    @current_time = Time.now.strftime("%Y-%m-%d %H:%M:%S")

    @subscribed_emails = MailchimpService.subscribed_emails
  end

  def subscribe_to_mailchimp
    email = params[:email] # Ensure that the email parameter is correctly obtained from the form
    list_id = 'a82be852d0' 
    MailchimpService.subscribe(email, list_id)  
    redirect_to root_path
  end
  
end
