# == Schema Information
# Schema version: 20081002231800
#
# Table name: requests
#
#  id                :integer(4)      not null, primary key
#  request_stream_id :integer(4)      not null
#  path              :string(255)
#  method            :string(255)
#  params            :text
#  created_at        :datetime
#

class Request < ActiveRecord::Base
  belongs_to :request_stream, :counter_cache => true, :class_name => "RequestStream"
  validates_presence_of :request_stream_id, :path, :method
  serialize :params
end
