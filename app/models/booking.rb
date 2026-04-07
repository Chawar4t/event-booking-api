class Booking < ApplicationRecord
  belongs_to :event

  MAX_TICKETS_PER_BOOKING = 10

  validates :email, presence: true
  validates :quantity, numericality: { 
    greater_than: 0, 
    less_than_or_equal_to: MAX_TICKETS_PER_BOOKING 
  }

  validate :sufficient_tickets_available

  private

  def sufficient_tickets_available
    return unless event && quantity
    if quantity > event.available_tickets
      errors.add(:quantity, "exceeds available tickets")
    end
  end
end