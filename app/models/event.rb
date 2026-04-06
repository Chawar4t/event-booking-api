class Event < ApplicationRecord
  has_many :bookings, dependent: :destroy

  validates :name, presence: true
  validates :date, presence: true
  validates :capacity, numericality: { greater_than: 0 }

  def available_tickets
    capacity - bookings.sum(:quantity)
  end
end