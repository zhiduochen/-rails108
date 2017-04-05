class Movie < ApplicationRecord
  belongs_to :user
  has_many :reviews
  validates :title, :description, presence: true
  has_many :group_relationships
  has_many :members, through: :movie_relationships, source: :user
end
