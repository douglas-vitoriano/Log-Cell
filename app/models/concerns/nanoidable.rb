module Nanoidable
  extend ActiveSupport::Concern

  included do
    before_validation :generate_ids, on: :create

    validates :nanoid, presence: true, uniqueness: true, if: -> { respond_to?(:nanoid) }

    def to_param
      respond_to?(:nanoid) ? nanoid : id
    end
  end

  private

  def generate_ids
    if respond_to?(:nanoid)
      self.nanoid ||= Nanoid.generate(size: 21)
    end

    if self.class.primary_key == "id" && id.blank?
      self.id = Nanoid.generate(size: 21)
    end
  end
end
