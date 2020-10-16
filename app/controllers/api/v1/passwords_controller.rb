class Api::V1::PasswordsController < ApplicationController
  before_action :authorized, only: [:update], except: [:forgot, :reset]

  def forgot
    if params[:email].blank?
      return render json: { is_success: false, error: "Email not present" }, status: 400
    end

    user = User.find_by(email: params[:email].downcase)

    if user.present?
      token = user.generate_password_token!

      # send token in email
      subject = "Token"

      body = "Dear #{user.name}\n This is your TOKEN to reset your password #{token} use it before it expires\n\n\nwarm regards"

      ApplicationMailer.send_email(user, subject, body).deliver_now

      render json: { is_success: true, message: "OTP has sent to your registered email" }, status: 200
    else
      render json: { is_success: false, error: "Email address not found. Please check and try again." }, status: 404
    end
  end

  def reset
    token = params[:token].to_s

    if params[:email].blank?
      return render json: { is_success: false, error: "Token not present" }, status: 404
    end

    user = User.find_by(reset_password_token: token)

    if user.present? && user.password_token_valid?
      if user.reset_password!(params[:password])
        render json: { is_success: true, message: "Password reset successfull" }, status: 200
      else
        render json: { is_success: false, error: user.errors.full_messages }, status: 422
      end
    else
      render json: { is_success: false, error: "Link not valid or expired. Try generating a new link." }, status: 404
    end
  end

  def update
    if !params[:password].present?
      render json: { is_success: false, error: "Password not present" }, status: 422
      return
    end

    current_user = User.find_by(email: params[:email])

    if current_user.reset_password!(params[:password])
      body = "Dear #{current_user.name} \nYour update password for club management system is successful\n\nwarm regards"
      ApplicationMailer.send_email(current_user, "Password update", body).deliver_now
      render json: { is_success: true, message: "Password update successful" }, status: 200
    else
      render json: { is_success: false, errors: current_user.errors.full_messages }, status: 422
    end
  end
end
