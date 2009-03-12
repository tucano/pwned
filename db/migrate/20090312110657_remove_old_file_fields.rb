class RemoveOldFileFields < ActiveRecord::Migration
  def self.up
    remove_column :networks, :edgefile 
    remove_column :networks, :annotationfile 
    remove_column :networks, :config 
  end

  def self.down
    add_column :networks, :edgefile 
    add_column :networks, :annotationfile 
    add_column :networks, :config 
  end
end
