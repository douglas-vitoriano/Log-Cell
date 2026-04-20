class UserAssignment < ApplicationRecord
  include Nanoidable

  belongs_to :user
  belongs_to :group
end
