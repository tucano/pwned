class Network < ActiveRecord::Base
  validates_presence_of :name, :description, :edgefile, :config
  validates_uniqueness_of :name
  validates_format_of :edgefile, :annotationfile,
    :with => %r{\.txt}i,
    :message => "Must be a .txt file"
  validates_format_of :config,
    :with => %r{\.xml}i,
    :message => "Must be an xml file"
end
