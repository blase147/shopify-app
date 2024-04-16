require_relative '../service/mailchimp_service'

class HomeController < ApplicationController 
  def index
    @welcome_message = "Welcome to Our Website"
    @current_time = Time.now.strftime("%Y-%m-%d %H:%M:%S")

    @subscribed_emails = MailchimpService.subscribed_emails
    @subscribed_phone_numbers = KlaviyoService.subscribed_phone_numbers
  end

  def subscribe_to_mailchimp
    email = params[:email]
    list_id = ENV['MAILCHIMP_LIST_ID']
    success, message = MailchimpService.subscribe(email, list_id)
    
    if success
      flash[:notice] = message
    else
      flash[:alert] = message
    end
    
    redirect_to root_path
  end



  def subscribe_to_klaviyo_sms
    phone_number = params[:phone_number]
    list_id = ENV['KLAVIYO_LIST_ID']

    # Subscribe the phone number using the KlaviyoService
    result, message = KlaviyoService.subscribe(phone_number)
    
    if result
      flash[:success] = message
    else
      flash[:error] = message
    end
    
    redirect_to root_path
  end


  def send_message
    subscriber_id = params[:subscriber_id]
    message_id = params[:message_id]

    response = AttentiveService.send_message(subscriber_id, message_id)

    if response['success']
      flash[:success] = "Message sent successfully!"
    else
      flash[:error] = "Failed to send message. Error: #{response['error_message']}"
    end

    redirect_to root_path
  end
  
end
