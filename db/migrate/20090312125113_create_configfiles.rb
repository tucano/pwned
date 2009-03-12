class CreateConfigfiles < ActiveRecord::Migration
  def self.up
    create_table :configfiles do |t|
      t.string :filename
      t.string :content_type
      t.integer :size

      t.timestamps
    end

    add_column :networks, :configfile_id, :integer
  
  end

  def self.down
    drop_table :configfiles
    remove_column :networks, :configfile_id
  end
end
