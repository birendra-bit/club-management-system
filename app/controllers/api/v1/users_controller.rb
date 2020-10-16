class Api::V1::UsersController < ApplicationController
  before_action :authorized, only: [:auto_login, :update]
  # before_action :authorized, :isadmin, only: [:destroy]

  begin
    def index
      @users = User.all

      if @users
        render json: { is_success: true, message: "user fetch successfull", data: @users }, status: 200
      else
        render json: { is_success: false, message: "user fetch unsuccessfull" }, status: 400
      end
    end

    # user sign_up: /users/signup
    def sign_up
      @user = User.create(user_params)

      if @user.valid?
        payload = { user_id: @user.id, is_admin: @user.is_admin }

        token = encode_token(payload)

        subject = "Registeration"

        body = "Dear #{@user.name}\n Your sign up successful in football club management system. Here you can enrolled in upcoming events\n\nwarm regards"

        ApplicationMailer.send_email(@user, subject, body).deliver_now

        render json: { is_success: true, message: "user signup successfully", data: @user, token: token }, status: 201
      else
        render json: { is_success: false, message: "Invalid credential or user already exist" }, status: 400
      end
    end

    # LOGGING IN /user/login
    def login
      @user = User.find_by(email: params[:email])

      if @user && @user.authenticate(params[:password])
        payload = { user_id: @user.id, is_admin: @user.is_admin }

        token = encode_token(payload)

        render json: { is_success: true, message: "login successful", data: @user, token: token }, status: 200
      else
        render json: { is_success: false, message: "Invalid username or password" }, status: 404
      end
    end

    def auto_login
      render json: @user
    end

    # update user /users/:id
    def update
      if user_exist
        @user = User.find(params[:id])

        @user.update(user_params)

        render json: { is_success: true, message: "user detail updated", data: @user }, status: 200
      else
        render json: { is_success: false, message: "user not found" }, status: 404
      end
    end

    # delete user /users/:id
    def destroy
      if is_admin
        if user_exist
          @user = User.find(params[:id])

          @user.destroy

          render json: { is_success: true, message: "user deleted" }, status: 200
        else
          render json: { is_success: false, message: "user not found" }, status: 404
        end
      else
        render json: { is_success: false, message: "you are not authorised" }, status: 401
      end
    end

    private

    def user_exist
      User.exists?(params[:id])
    end

    def user_params
      params.permit(:name, :is_admin, :email, :contact, :designation, :club, :address, :password)
    end
  rescue
    render json: { is_success: false, message: "something went wrong" }, status: 404
  end
end
