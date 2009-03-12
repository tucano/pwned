class CreateAnnotationfiles < ActiveRecord::Migration
  def self.up
    create_table :annotationfiles do |t|
      
      t.integer :network_id

      t.string :filename
      t.string :content_type
      t.integer :size

      t.timestamps
    end

  end

  def self.down
    drop_table :annotationfiles
  end
end
