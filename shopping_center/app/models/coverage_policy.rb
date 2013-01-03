class CoveragePolicy
  include Mongoid::Document
  include Mongoid::Timestamps

  DEFAULT_EXPIRATION = 4320

  ###fields
  field :expiration_duration, type: Integer #stored in minutes

  ###associations
  belongs_to :retailer
  embedded_in :coverage_list, inverse_of: :policies

  ###validations
  validates :retailer, presence: true

  ###methods
  def expiration_duration
    (read_attribute(:expiration_duration) || CoveragePolicy::DEFAULT_EXPIRATION)
  end
end
