# == Schema Information
# Schema version: 20080915100905
#
# Table name: request_streams
#
#  id              :integer(4)      not null, primary key
#  user_id         :integer(4)
#  last_request_at :datetime        not null
#  ip_address      :string(255)
#  user_agent      :string(255)
#  referer         :string(255)
#  requests_count  :integer(4)
#  created_at      :datetime
#  updated_at      :datetime
#

class RequestStream < ActiveRecord::Base
  has_many :requests, :dependent => :destroy, :order => "created_at DESC", :class_name => "Request"
  
  validates_presence_of :last_request_at
  
  named_scope :recent, lambda { |*args| {:conditions => ["last_request_at > ?", (args.first || 3.hours.ago)]} }
  named_scope :old, lambda { |*args| {:conditions => ["last_request_at =< ?", (args.first || 3.hours.ago)]} }
  named_scope :with_requests, {:include => [:requests]}
  
  def self.prune(last_request_at = 1.day.ago)
    destroy_all(["last_request_at < ?", last_request_at])
  end
  
  def session_length
    last_request_at - created_at
  end
  
end
