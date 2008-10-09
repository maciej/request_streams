# Include hook code here
require('request_streams')
require('request')
require('request_stream')

config.to_prepare do
  ActionController::Base.send :include, RequestStreams::ActionControllerExtensions
end