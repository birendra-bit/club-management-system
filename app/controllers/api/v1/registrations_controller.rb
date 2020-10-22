class Api::V1::RegistrationsController < ApplicationController
  before_action :authorized, only: [:create]

  def index
    @register = Registeration.all

    render json: { is_success: true, message: "fetch successful", data: @register }, status: 200
  end

  def create
    @register = Registeration.new(register_params)

    if @register.save
      render json: { is_success: true, message: "you are registered" }, status: 200
    else
      render json: { is_success: false, message: "you are not registered" }, status: 401
    end
  end

  def fetch_participants
    @event = Event.find(params[:id])
    @registered_user = @event.registeration
    render json: { data: @registered_user.map { |x| x.user.name } }, status: 200
  end

  private

  def register_params
    params.permit(:user_id, :event_id)
  end
end
