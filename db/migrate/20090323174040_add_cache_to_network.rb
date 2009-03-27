class AddCacheToNetwork < ActiveRecord::Migration
  def self.up
    add_column :networks, :cached_tag_list, :text
  end

  def self.down
    remove_column :networks, :cached_tag_list
  end
end
