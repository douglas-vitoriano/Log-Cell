class Rule < ApplicationRecord
  include Nanoidable

  belongs_to :group

  RESOURCES = %w[
    users groups rules
    products categories suppliers
    sales sale_items customers
    movements accounts_payable accounts_receivable
  ].freeze

  ACTIONS = %w[read create update destroy].freeze

  validates :resource, presence: true, inclusion: { in: RESOURCES }
  validates :action,   presence: true, inclusion: { in: ACTIONS }
  validates :resource, uniqueness: { scope: [ :group_id, :action ] }

  scope :enabled, -> { where(enabled: true) }

  def self.allowed?(group_ids, resource, action)
    where(group_id: group_ids, resource: resource.to_s, action: action.to_s, enabled: true).exists?
  end
end
