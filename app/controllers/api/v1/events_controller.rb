class Api::V1::EventsController < ApplicationController
  before_action :authorized, only: [:create, :update, :destroy, :event_register]

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

        ApplicationMailer.send_notice_to_all(@user, subject, body)

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

        # subject = "event updates"
        # body = "There is some changes in event title #{event.title}.Please visit our page to update yourslef with updates\n\nWarm regards\nClub Management System"

        # send_notice_to_all()
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

  def event_register
    @user = User.find_by(id: params[:user_id])
    @event = Event.find(params[:id])

    if @user && @event
      event = @event
      puts("events : ", event.title)

      event.participants.push(params[:user_id])

      @event.update(event)

      # subject = "Event Registeration"
      # body = "You are registeration for event title #{@event.title} is successful.\n\nWarm regards\nClub Management System"

      # ApplicationMailer.send_notice_to_all(@user, subject, body)

      render json: { is_success: true, message: "User Registeration for the event is successful" }, status: 200
    else
      render json: { is_success: false, message: "User does not exist or events not found" }, status: 404
    end
  end

  def past
    @events = Event.where("event_time > ? ", date.today)
    if @events
      render json: { is_success: true, message: "Events fetch successful", data: @events }, status: 200
    else
      render json: { is_success: false, message: "Events fetch not successful" }, status: 404
    end
  end

  def current
    @events = Event.where("event_time == ? ", date.today)
    if @events
      render json: { is_success: true, message: "Events fetch successful", data: @events }, status: 200
    else
      render json: { is_success: false, message: "Events fetch not successful" }, status: 404
    end
  end

  def upcoming
    @events = Event.where("event_time < ? ", date.today)
    if @events
      render json: { is_success: true, message: "Events fetch successful", data: @events }, status: 200
    else
      render json: { is_success: false, message: "Events fetch not successful" }, status: 404
    end
  end

  private

  def event_params
    params.permit(:title, :user_id, :event_time, :venu, :organizer, :entry_fee, :participants)
  end
end
