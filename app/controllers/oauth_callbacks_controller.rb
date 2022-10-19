class OauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    oauth('Github')
  end

  def vkontakte
    oauth('Vkontakte')
  end

  def send_email_confirmation
    byebug
    authorization = Authorization.create!(
      provider: params[:provider],
      uid: params[:uid],
      temporary_email: params[:email],
      confirmation_token: SecureRandom.hex(30),
      confirmed: false
    )

    UserMailer.email_confirmation(authorization).deliver
    redirect_to root_path, flash: { notice: 'Check your email' }
  end

  def email_confirmation
    authorization = Authorization.find_by(confirmation_token: params[:token], confirmed: false)

    unless authorization
      redirect_to(root_path, flash: { error: 'Sorry, invalid confirmation' }) && return
    end

    email = authorization.temporary_email
    user = User.find_by(email: email) || User.generate_user(email)

    authorization.update(confirmed: true, user_id: user.id)

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
