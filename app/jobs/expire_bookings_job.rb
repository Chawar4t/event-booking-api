class ExpireBookingsJob < ApplicationJob
  queue_as :default

  def perform
    expired_bookings = Booking.expired

    expired_bookings.each do |booking|
      booking.update!(status: "cancelled")
    end

    Rails.logger.info "Expired #{expired_bookings.count} bookings"
  end
end