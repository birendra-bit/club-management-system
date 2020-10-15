class Api::V1::EventsController < ApplicationController
  before_action :authorized, only: [:create, :update]

    begin
        def index
            @events = Event.all
            render json: {is_success: true, message:'events fetch successful', data: @events}, status: 201
        end

        def create
            if is_admin
                @events = Event.create(event_params)
                if @events.valid?
                  render json: { is_ssuccess: true, message: "eventsfeeds creation successful", data: @events }, status: 201
                else
                  render json: { is_success: false, message: "eventsfeeds creation not successful" }, status: 400
                end
              else
                render json: { is_success: false, message: "you are not authorised" }, status: 401
              end
        end

        def update
            
        end


        private

        
        def event_params
            params.permit(:title, :user_id, :event_time, :venu, :organizer, :entry_fee, :participants)
            
        end


    rescue => exception
        render json: {is_success: false, message:'something went wrong'}, status: 404
    end
end
