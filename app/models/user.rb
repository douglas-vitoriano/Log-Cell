class User < ApplicationRecord
  include Nanoidable
  include Discard::Model

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :sales
  has_many :movements
  has_many :user_assignments, dependent: :destroy
  has_many :groups, through: :user_assignments
  has_one_attached :avatar

  serialize :complement, type: Hash, coder: JSON

  validates :name, presence: true

  def group_ids=(ids)
    self.groups = Group.where(id: Array(ids).reject(&:blank?))
  end

  def group_codes
    groups.pluck(:code)
  end

  def sysadmin?
    group_codes.include?("sysadmin")
  end

  def super_admin?
    group_codes.include?("super_admin")
  end

  def partner?
    group_codes.include?("partner")
  end

  def admin_protected?
    (group_codes & Group::PROTECTED_CODES).any?
  end

  def self.can_edit_user?(current_user, target_user)
    return false if current_user.nil? || target_user.nil?
    return true  if current_user.sysadmin?
    !target_user.admin_protected?
  end

  def self.can_delete_user?(current_user, target_user)
    return false if current_user.nil? || target_user.nil?
    return false if target_user == current_user
    return true  if current_user.sysadmin?
    !target_user.admin_protected?
  end

  def self.available_groups(current_user)
    return Group.where(enabled: true).where.not(code: Group::PROTECTED_CODES) if current_user.nil?

    if current_user.sysadmin?
      Group.where(enabled: true)
    else
      Group.assignable_by_partner
    end
  end
end
