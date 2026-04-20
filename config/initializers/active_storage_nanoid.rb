Rails.configuration.to_prepare do
  [ ActiveStorage::Blob, ActiveStorage::Attachment, ActiveStorage::VariantRecord ].each do |model|
    model.include Nanoidable
  end
end
