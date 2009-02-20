class CreateNetworks < ActiveRecord::Migration
  def self.up
    create_table :networks do |t|
      t.string :name
      t.text :description
      t.string :edgefile
      t.string :annotationfile
      t.string :config

      t.timestamps
    end
  end

  def self.down
    drop_table :networks
  end
end
