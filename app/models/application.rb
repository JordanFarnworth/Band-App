class Application < ActiveRecord::Base
  has_many :entities, through: :application_joiners
  has_many :application_joiners
  after_create :infer_values

  def infer_values
    self.status = 'pending'
  end

end
