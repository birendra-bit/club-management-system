class Api::V1::UsersController < ApplicationController
    before_action :authorized, only: [:auto_login]

    def index

        @users = User.all

        if @users
            render json: { is_success:true, message:'user fetch successfull', data: @users}, status: 200
        else
            render json: {is_success:false, message:'user fetch unsuccessfull'}, status: 400
        end 
    end

    def sign_up

        @user = User.create(user_params)

        if @user.valid?
          token = encode_token({user_id: @user.id})
          render json: {is_success:true, message:'user signup successfull', data: @user, token: token}, status: 201
        else
          render json: {is_success:false, message:'Invalid credential'}, status: 400
        end
    end

    def auto_login
        render json: @user
    end


    private
    
    def user_params
      params.permit(:name, :email, :contact, :designation, :club, :address, :password)
    end
end