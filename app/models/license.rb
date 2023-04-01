class License < ApplicationRecord
  include Paginatable
  validates :key, presence: true

  belongs_to :user
  belongs_to :game
end
