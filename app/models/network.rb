class Network < ActiveRecord::Base
  
  acts_as_taggable
  
  has_one :edgefile, :dependent => :destroy
  has_one :annotationfile, :dependent => :destroy
  has_one :configfile, :dependent => :destroy

  has_many :comments

  validates_presence_of :name, :description

  validates_format_of :name,
                      :with => /^\w+$/,
                      :if => Proc.new { |n| !n.name.blank? }

  validates_uniqueness_of :name
  
  
  def self.search(search)
    if search then
      if search.has_key? 'name' then
        find(:all, :conditions => ['name LIKE ?', "%#{search['name']}%"])
      end
    else
      find(:all)
    end
  end

end
