require_relative '../service/mailchimp_service'

class HomeController < ApplicationController 
  def index
    api_key = 'pk_34cec0528c92d55f4a9862d50f292e36a6'
    list_id = 'S9HTBg'

    @welcome_message = "Welcome to Our Website"
    @current_time = Time.now.strftime("%Y-%m-%d %H:%M:%S")

     @subscribed_emails = MailchimpService.subscribed_emails
     @phone_numbers = KlaviyoService.subscribed_phone_numbers(api_key, list_id)

  end

  def subscribe_to_mailchimp
    email = params[:email]
    list_id = 'a82be852d0' 
    begin
      response = MailchimpService.subscribe(email, list_id)
      flash[:success] = 'Successfully subscribed to Mailchimp list!'
    rescue Gibbon::MailChimpError => e
      if e.title == 'Member Exists'
        flash[:error] = 'You are already subscribed to the Mailchimp list.'
      else
        flash[:error] = 'Failed to subscribe to Mailchimp list. Please try again.'
      end
    end

    redirect_to root_path
  end



  def subscribe_to_klaviyo_sms
    phone_number = params[:phone_number]
    list_id = 'S9HTBg' # Replace 'YOUR_LIST_ID' with your actual Klaviyo list ID
  
    begin
      # Call the method to subscribe the user to the Klaviyo list
      KlaviyoService.subscribe(phone_number, list_id)
      flash[:success] = 'Successfully subscribed to Klaviyo list!'
    rescue StandardError => e
      flash[:error] = 'Failed to subscribe to Klaviyo list. Please try again.'
    end
  
    redirect_to root_path
  end
  

end

