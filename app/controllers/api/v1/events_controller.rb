class Api::V1::EventsController < ApplicationController
    def index
        events = Event.all.order(:date)
        render json: events.map { |event| 
            {
                id: event.id,
                name: event.name,
                date: event.date,
                capacity: event.capacity,
                available_tickets: event.available_tickets
            }
        }
    end
end