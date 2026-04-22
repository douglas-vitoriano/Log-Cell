class Group < ApplicationRecord
  include Nanoidable

  has_many :user_assignments, dependent: :destroy
  has_many :users, through: :user_assignments
  has_many :rules, dependent: :destroy

  PROTECTED_CODES = %w[sysadmin super_admin admin master].freeze

  scope :enabled,               -> { where(enabled: true) }
  scope :assignable_by_partner, -> { enabled.where.not(code: PROTECTED_CODES) }

  validates :name, presence: true
  validates :code, presence: true, uniqueness: true

  def protected?
    PROTECTED_CODES.include?(code)
  end
end
