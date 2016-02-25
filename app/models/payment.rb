class Payment < ActiveRecord::Base
  belongs_to :entity

  VALID_GATEWAYS = [
    'braintree'
  ]

  SUBSCRIPTION_OPTIONS = [
    { text: '1 Month', price: 24.99, price_per_month: 24.99, duration: 1.month },
    { text: '3 Months', price: 59.97, price_per_month: 19.99, duration: 3.months },
    { text: '6 Months', price: 89.94, price_per_month: 14.99, duration: 6.months },
    { text: '1 Year', price: 119.88, price_per_month: 9.99, duration: 12.months }
  ]

  validates_presence_of :entity, on: :create
  validates_presence_of :uuid
  validates_inclusion_of :gateway, in: VALID_GATEWAYS
  validates_inclusion_of :state, in: %w(initiated processed failed)
  validates_numericality_of :amount
  validates_inclusion_of :amount, in: SUBSCRIPTION_OPTIONS.map { |v| v[:price] }

  serialize :parameters, Hash

  scope :failed, -> { where(state: :failed) }
  scope :processed, -> { where(state: :processed) }
  scope :initiated, -> { where(state: :initiated) }

  after_initialize do
    # Failsafe: Mark payments as failed if they remain in an initiated state for more than 2 days
    if created_at && created_at < 2.days.ago && state == 'initiated'
      self.state = 'failed'
      save
    end
  end

  before_validation do
    self.uuid ||= SecureRandom.uuid
    self.state ||= :initiated
    self.gateway ||= 'braintree'
  end

  def mark_as_processed!
    if subscription = SUBSCRIPTION_OPTIONS.find { |v| v[:price] == amount }
      entity.update_subscription subscription[:duration]
    end
    update state: 'processed'
  end

  def mark_as_failed!
    update state: 'failed'
  end
end
