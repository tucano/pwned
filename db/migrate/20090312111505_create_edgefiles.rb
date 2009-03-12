class CreateEdgefiles < ActiveRecord::Migration
  def self.up
    create_table :edgefiles do |t|
      t.string :filename
      t.string :content_type
      t.integer :size

      t.timestamps
    end

    add_column :networks, :edgefile_id, :integer

  end

  def self.down
    drop_table :edgefiles
    remove_column :networks, :edgefile_id
  end
end
