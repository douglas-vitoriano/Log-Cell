class Group < ApplicationRecord
  include Nanoidable

  has_many :user_assignments
  has_many :users, through: :user_assignments
end
