class Booking < ApplicationRecord
  belongs_to :event

  MAX_TICKETS_PER_BOOKING = 10

  STATUSES = %w[pending confirmed cancelled].freeze
  EXPIRY_MINUTES = 15

  validates :email, presence: true
  validates :quantity, numericality: { 
    greater_than: 0, 
    less_than_or_equal_to: MAX_TICKETS_PER_BOOKING 
  }
  validates :status, inclusion: { in: STATUSES }

  validate :sufficient_tickets_available

  before_create :set_expiry

  scope :expired, -> { where(status: "pending").where("expires_at < ?", Time.current) }
  scope :active,  -> { where(status: "confirmed") }

  def expired?
    expires_at < Time.current && status == "pending"
  end

  def confirm!
    update!(status: "confirmed", expires_at: nil)
  end

  private

  def set_expiry
    self.status     = "pending"
    self.expires_at = EXPIRY_MINUTES.minutes.from_now
  end

  def sufficient_tickets_available
    return unless event && quantity
    if quantity > event.available_tickets
      errors.add(:quantity, "exceeds available tickets")
    end
  end
end