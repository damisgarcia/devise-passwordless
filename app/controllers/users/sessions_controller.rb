# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  before_action :verify_guest, only: %i[generate_token confirm_token]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/generate_token
  def generate_token
    user = User.find_by email: user_params[:email] # Restrict search to confirmed users to prevent spam.

    # MagicLoginMailer.login(user).deliver_later if user.present?

    if user.present?
      @code = user.regenerate_login_token

      puts "Login token: #{@code} - Please remove on production"

      redirect_to users_confirm_token_path, notice: t('devise.login_token.successful.created')
    else
      redirect_to new_user_session_path, notice: t('devise.login_token.failure.email_not_found')
    end
  end

  def confirm_token
    @user = User.new
  end

  # POST /resource/sign_in
  def create
    # search for user by login_token
    user = User.find_by!(login_token: user_params[:login_token])

    if user.login_token_valid? user_params[:login_token]
      sign_in(user) # devise sign_in in application
      user.invalidate_login_token! # remove login_token after successful login

      redirect_to root_path, notice: t('devise.sessions.signed_in')
    else
      redirect_to new_user_session_path, notice: t('devise.login_token.failure.expired')
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to generate_token_path, notice: t('devise.login_token.failure.token_invalid')
  end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end

  private
    def user_params
      params.require(:user).permit(:email, :login_token)
    end

    def verify_guest
      redirect_to root_path if user_signed_in?
    end
end
