class Api::V1::NewsfeedsController < ApplicationController
  before_action :authorized, only: [:create, :update, :destroy]

  begin
    # Get all newsfeeds
    # /newsfeeds
    def index
      @news = Newsfeed.order("created_at DESC")
      render json: { is_success: true, message: "news fetch successful", data: @news }, status: 200
    end

    # Create newsfeed
    # /newsfeeds
    def create
      if is_admin
        @news = Newsfeed.create(newsfeed_params)
        if @news.valid?
          @user = User.all
          subject = "News update"
          body = "There is news update in club management system. Please visit our page to update yourslef with current news\n\nWarm regards\nClub Management System"

          send_notice_to_all(@user, subject, body)

          render json: { is_success: true, message: "newsfeeds creation successful", data: @news }, status: 201
        else
          render json: { is_success: false, message: "newsfeeds creation not successful" }, status: 400
        end
      else
        render json: { is_success: false, message: "you are not authorised" }, status: 401
      end
    end

    # update newsfeeds
    # /newsfeeds
    def update
      if is_admin
        if newsfeed_exist
          @news = Newsfeed.find(params[:id])

          @news.update(newsfeed_params)
          render json: { is_success: true, message: "newsfeed updated", data: @news }, status: 200
        else
          render json: { is_success: false, message: "newsfeed not found" }, status: 404
        end
      else
        render json: { is_success: false, message: "you are not authorised" }, status: 401
      end
    end

    # delete newsfeed
    # /newsfeeds/:id
    def destroy
      if is_admin
        if newsfeed_exist
          @news = Newsfeed.find(params[:id])
          @news.destroy
          render json: { is_success: true, message: "newsfeed deleted" }, status: 200
        else
          render json: { is_success: false, message: "newsfeed not found" }, status: 404
        end
      else
        render json: { is_success: false, message: "you are not authorised" }, status: 401
      end
    end

    private

    def newsfeed_exist
      Newsfeed.exists?(params[:id])
    end

    def newsfeed_params
      params.permit(:user_id, :title, :image_url, :content)
    end

    def send_notice_to_all(user, subject, body)
      @user = user

      for u in @user
        if !u.is_admin
          msg = ""
          msg = "Dear #{u.name}\n\n" + body
          ApplicationMailer.send_email(u, subject, msg).deliver_later(wait: 1.minute)
        end
      end
    end
  rescue
    render json: { is_success: false, message: "something went wrong" }, status: 404
  end
end
