class OauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    oauth('Github')
  end

  def vkontakte
    oauth('Vkontakte')
  end

  def send_email_confirmation
    SendEmailConfirmationService.new(params).call
    
    redirect_to root_path, flash: { notice: 'Check your email' }
  end

  def email_confirmation
    ConfirmationByEmailService.new(params).call

    sign_in_and_redirect user, event: :authentication
    set_flash_message(:notice, :success, kind: 'Vkontakte') if is_navigational_format?
  end


  private

  def oauth(provider)
    @auth = request.env['omniauth.auth']
    return render 'devise/registrations/email_request' unless request.env['omniauth.auth'].info[:email]
    
    @user = User.find_for_oauth(request.env['omniauth.auth'])
    if @user&.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: provider) if is_navigational_format?
    else
      redirect_to root_path, alert: 'Something went wrong'
    end
  end
end
