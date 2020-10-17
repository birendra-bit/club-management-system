class Api::V1::EventsController < ApplicationController
  before_action :authorized, only: [:create, :update, :destroy]

  def index
    @events = Event.all
    render json: { is_success: true, message: "events fetch successful", data: @events }, status: 201
  end

  def create
    if is_admin
      @events = Event.new(event_params)
      # byebug
      if @events.save!
        @user = User.all

        subject = "New Events"

        body = "There is new event coming up in club management page. Please visit our website and get enrolled for the events\n\nwarm regards\nClub Magement System"

        send_notice_to_all(@user, subject, body)

        render json: { is_ssuccess: true, message: "events creation successful", data: @events }, status: 201
      else
        render json: { is_success: false, message: "events creation not successful" }, status: 400
      end
    else
      render json: { is_success: false, message: "you are not authorised" }, status: 401
    end
  end

  def update
    if is_admin
      event = Event.find(params[:id])

      if event.present?
        event.update(event_params)
        render json: { is_success: true, message: "event update successful" }, status: 202
      else
        render json: { is_success: false, message: "event doesn't exists" }, status: 406
      end
    else
      render json: { is_success: false, message: "You are not authorised" }, status: 401
    end
  end

  def destroy
    if is_admin
      event = Event.find(params[:id])

      if event.present?
        event.destroy
        render json: { is_success: true, message: "event delete successful" }, status: 202
      else
        render json: { is_success: false, message: "event doesn't exist" }, status: 406
      end
    else
      render json: { is_success: false, message: "You are not authorised" }, status: 401
    end
  end

  private

  def event_params
    params.permit(:title, :user_id, :event_time, :venu, :organizer, :entry_fee, :participants)
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
end
