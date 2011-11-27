class CreateAttachments < ActiveRecord::Migration
  def self.up
    create_table :attachments do |t|
      t.string :title
      t.string :file
      t.integer :object_id
      t.string :object_type
      t.string :code

      t.timestamps
    end
    
    add_index :attachments, [:object_id, :object_type]
    add_index :attachments, :code
  end

  def self.down
    drop_table :attachments
  end
end
