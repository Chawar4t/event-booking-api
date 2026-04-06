class Api::V1::BookingsController < ApplicationController
  def create
    event = Event.find(params[:event_id])

    event.with_lock do
      booking = event.bookings.build(booking_params)

      if booking.save
        render json: {
          message: "Booking successful",
          booking: {
            id: booking.id,
            event: event.name,
            email: booking.email,
            quantity: booking.quantity
          }
        }, status: :created
      else
        render json: {
          errors: booking.errors.full_messages
        }, status: :unprocessable_entity
      end
    end
  end

  private

  def booking_params
    params.require(:booking).permit(:email, :quantity)
  end
end