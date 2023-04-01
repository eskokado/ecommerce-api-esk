class License < ApplicationRecord
  validates :key, presence: true

  belongs_to :user
  belongs_to :game
end
