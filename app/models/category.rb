class Category < ApplicationRecord
  include Nanoidable

  has_many :products, dependent: :restrict_with_error
  has_one_attached :image

  validates :name, presence: true, uniqueness: { case_sensitive: false }

  scope :active, -> { where(active: true) }
  scope :ordered, -> { order(:name) }
end
