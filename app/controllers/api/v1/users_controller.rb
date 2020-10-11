class Api::V1::UsersController < ApplicationController
    before_action :authorized, only: [:auto_login, :update, :destroy]

    def index

        @users = User.all

        if @users
            render json: { is_success:true, message:'user fetch successfull', data: @users}, status: 200
        else
            render json: {is_success:false, message:'user fetch unsuccessfull'}, status: 400
        end 

    end

    # user sign_up: /users/signup
    def sign_up

        @user = User.where(email: params[:email])

        if @user == nil
            
            @user = User.create(user_params)

            if @user.valid?

            payload = { user_id: @user.id, is_admin: @user.is_admin } 

            token = encode_token(payload)

            render json: {is_success:true, message:'user signup successfully', data: @user, token: token}, status: 201
            
            else

            render json: {is_success:false, message:'Invalid credential'}, status: 400

            end
        else
            render json: {is_success: false, message:'user already exist'}, status: 400

        end

    end


    # LOGGING IN /user/login
    def login

        @user = User.find_by(email: params[:email])
    
        if @user && @user.authenticate(params[:password])

          payload = { user_id: @user.id, is_admin: @user.is_admin }  

          token = encode_token(payload)

          render json: { is_success: true, message: 'login successful', data: @user, token: token}, status: 200

        else

          render json: { is_success: true, message: 'Invalid username or password' }, status: 404

        end

    end
    
    def auto_login

        render json: @user

    end

    
    # update user /users/:id
    def update

        if User.exists?(params[:id])

            @user = User.find(params[:id])

            @user.update(user_params)

            render json: { is_success: true, message: 'user detail updated', data: @user }, status: 200
            
        else

            render json: { is_success: false, message: 'user not found' }, status: 404
        
        end

    end

    # delete user /users/:id
    def destroy

        if User.exists?(params[:id])

            @user = User.find(params[:id])

            @user.destroy

            render json: { is_success: true, message: 'user deleted' }, status: 200

        else

            render json: { is_success: false, message: 'user not found'}, status: 404

        end

    end


    private
    
    def user_params

      params.permit(:name, :email, :contact, :designation, :club, :address, :password)

    end

end