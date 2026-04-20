class User < ApplicationRecord
  include Nanoidable
  include Discard::Model

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :sales
  has_many :movements
  has_many :user_assignments
  has_many :groups, through: :user_assignments
  has_one_attached :avatar

  serialize :complement, type: Hash, coder: JSON

  validates :name, presence: true

  def sysadmin?
    groups.exists?(code: "sysadmin")
  end
end
