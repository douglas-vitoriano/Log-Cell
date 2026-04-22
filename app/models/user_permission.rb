class UserPermission < ApplicationRecord
  include Nanoidable

  belongs_to :user_assignment
  belongs_to :rule
  belongs_to :group

  validates :user_assignment_id, uniqueness: { scope: :rule_id }
end
