class PotentialDestination < ApplicationRecord
  belongs_to :city
  belongs_to :trip_participant
  has_many :participant_scores
end