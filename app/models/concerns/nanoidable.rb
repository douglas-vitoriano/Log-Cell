module Nanoidable
  extend ActiveSupport::Concern

  included do
    before_validation :generate_ids, on: :create
    validates :nanoid, presence: true, uniqueness: true
  end

  def to_param
    nanoid.presence || id
  end

  private

  def generate_ids
    self.nanoid ||= Nanoid.generate(size: 21)

    if self.class.primary_key == "id" && id.blank?
      self.id = Nanoid.generate(size: 21)
    end
  end
end
