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
                      :with => /^[A-Za-z]+\w*$/,
                      :if => Proc.new { |n| !n.name.blank? }

  validates_uniqueness_of :name
  
  validate :tag_list_valid?, :if => Proc.new{ |n| !n.tag_list.blank? }
  
  # OPTIMIZE this search
  def self.search(query = nil, options={})
    with_scope( :find => { :conditions => self.search_conditions(query) }) do
      find :all, options
    end
  end
  
  # Sitemap finder
  def self.find_for_sitemap
    find(:all, :select => "id, updated_at", :order => "updated_at DESC", :limit => 50000)
  end

  # FIXME tag validation for now just on size less than 100 chars
  def tag_list_valid?
    maxsize = 50
    self.tag_list.each do |tag|
      unless tag.size <= maxsize
        errors.add(:tag, "#{tag} is too big (size: #{tag.size}), maximum size is: #{maxsize}")
      end
    end
  end
  
  private
  
  def self.search_conditions(query)
    return nil if query.nil?
    like_frags = Array.new
    value_frags = Array.new
    query.map { |k,v|
      like_frags.push("#{k} LIKE ?")
      value_frags.push("%#{v}%")
    }
    like_string = like_frags.join(" AND ")
    [like_string, *value_frags]
  end
  
end
