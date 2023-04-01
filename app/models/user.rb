# frozen_string_literal: true

class User < ActiveRecord::Base
  include NameSearchable
  include Paginatable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  include DeviseTokenAuth::Concerns::User

  validates :name, presence: true
  validates :email, presence: true
  validates :profile, presence: true

  has_many :licenses

  enum profile: { admin: 0, client: 1 }
end
