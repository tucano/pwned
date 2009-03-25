class Network < ActiveRecord::Base
  
  # TODO taggable doesn't have any model so no validation
  acts_as_taggable

  has_one :edgefile, :dependent => :destroy
  has_one :annotationfile, :dependent => :destroy
  has_one :configfile, :dependent => :destroy

  has_many :comments

  # TODO validate description in some way
  validates_presence_of :name, :description

  validates_format_of :name,
                      :with => /^[A-Za-z]+\w+$/,
                      :if => Proc.new { |n| !n.name.blank? }

  validates_uniqueness_of :name
  
  # OPTIMIZE this search
  def self.search(search = nil)
    if search then
      if search.has_key? 'name' then
        find(:all, :conditions => ['name LIKE ?', "%#{search['name']}%"])
      end
    else
      find(:all)
    end
  end
end
