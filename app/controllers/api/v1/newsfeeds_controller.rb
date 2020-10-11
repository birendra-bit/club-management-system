class Api::V1::NewsfeedsController < ApplicationController
  before_action :authorized, only: [:create]
  begin
    # Get all newsfeeds
    def index
      @news = Newsfeed.all
      render json: { is_success: true, message: "news fetch successful", data: @news }, status: 200
    end

    def create
      @news = Newsfeed.create(newsfeed_params)
      if @news.valid?
        render json: { is_success: true, message: "newsfeeds creation successful", data: @news }, status: 201
      else
        render json: { is_success: false, message: "newsfeeds creation not successful" }, status: 400
      end
    end

    private

    def user_exist
      Newsfeed.exists?(params[:id])
    end

    def newsfeed_params
      params.permit(:user_id, :title, :image_url, :content)
    end
  rescue
    render json: { is_success: false, message: "something went wrong" }, status: 404
  end
end
