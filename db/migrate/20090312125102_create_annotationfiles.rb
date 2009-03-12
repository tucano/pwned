class CreateAnnotationfiles < ActiveRecord::Migration
  def self.up
    create_table :annotationfiles do |t|
      t.string :filename
      t.string :content_type
      t.integer :size

      t.timestamps
    end

    add_column :networks, :annotationfile_id, :integer
  
  end

  def self.down
    drop_table :annotationfiles
    remove_column :networks, :annotationfile_id
  end
end
