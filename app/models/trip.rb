class Trip < ApplicationRecord
  belongs_to :lead_user, class_name: "User", foreign_key: "user_id"
  belongs_to :city, optional: true

  has_many :trip_participants, dependent: :destroy
  has_many :users, through: :trip_participants

  validates :name, presence: true
end
