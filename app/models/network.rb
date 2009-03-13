class Network < ActiveRecord::Base
  
  has_one :edgefile, :dependent => :destroy
  has_one :annotationfile, :dependent => :destroy
  has_one :configfile, :dependent => :destroy

  validates_presence_of :name, :description

  validates_format_of :name,
                      :with => /^\w+$/

  validates_uniqueness_of :name, :on => :create

  validates_presence_of :edgefile, :configfile
  validates_associated :edgefile, :configfile

  # TODO validate annotation files (AnnotationService)

end
