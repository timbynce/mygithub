class ConfirmationByEmailService < ApplicationService

  def initialize(params)
    @params = params
  end
  
  def call
    authorization = Authorization.find_by(confirmation_token: @params[:token], confirmed: false)

    email = authorization.temporary_email
    user = User.find_by(email: email) || User.generate_user(email)

    authorization.update(confirmed: true, user_id: user.id)
  end


end
