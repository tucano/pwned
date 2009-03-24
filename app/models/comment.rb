class Comment < ActiveRecord::Base
  belongs_to :network
  validates_presence_of :network_id, :on => :save
  validates_length_of :body, :within => 1..1000
end
