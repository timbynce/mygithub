class SendEmailConfirmationService < ApplicationService

  def initialize(params)
    @params = params
  end

  def call
    authorization = Authorization.create!(
      provider: @params[:provider],
      uid: @params[:uid],
      temporary_email: @params[:email],
      confirmation_token: SecureRandom.hex(30),
      confirmed: false
    )

    UserMailer.email_confirmation(authorization).deliver
  end

end
