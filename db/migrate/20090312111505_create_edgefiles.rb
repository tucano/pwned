class CreateEdgefiles < ActiveRecord::Migration
  def self.up
    create_table :edgefiles do |t|
      
      t.integer :network_id

      t.string :filename
      t.string :content_type
      t.integer :size

      t.timestamps
    end
  end

  def self.down
    drop_table :edgefiles
  end
end
