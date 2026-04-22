Rails.configuration.to_prepare do
  [ ActiveStorage::Blob, ActiveStorage::Attachment, ActiveStorage::VariantRecord ].each do |model|
    model.before_create do
      self.id = Nanoid.generate(size: 21) if id.blank?
    end
  end
end
