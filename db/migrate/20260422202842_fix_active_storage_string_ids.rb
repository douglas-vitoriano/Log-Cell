# Nova migration
class FixActiveStorageStringIds < ActiveRecord::Migration[8.1]
  def change
    change_column_default :active_storage_attachments, :id, from: nil, to: -> { "nanoid(21)" }
    change_column_default :active_storage_blobs, :id, from: nil, to: -> { "nanoid(21)" }
    change_column_default :active_storage_variant_records, :id, from: nil, to: -> { "nanoid(21)" }
  end
end
