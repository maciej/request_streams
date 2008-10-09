#require File.dirname(__FILE__) + '/request_streams/request'
#require File.dirname(__FILE__) + '/request_streams/request_stream'

# RequestStreams
module RequestStreams
  
  module ActionControllerExtensions
    def self.included(base) # :nodoc:
      base.extend ClassMethods
    end
    
    module ClassMethods
      def log_requests(options = {})
        
        if options[:if]
          self.log_requests_condition = options[:if]
          options.delete :if
        end
        if options[:log_params]
          self.log_requests_params = options[:log_params]
          options.delete :log_params
        end
        after_filter :log_request, options
      end # log_requests
      
      # Default value is true
      def log_requests_condition
        read_inheritable_attribute('log_requests_condition')
      end
      
      def log_requests_condition= log_requests_condition
        write_inheritable_attribute('log_requests_condition', log_requests_condition)
      end
      
      def log_requests_params
        read_inheritable_attribute('log_requests_params')
      end
      
      def log_requests_params= log_requests_params
        write_inheritable_attribute('log_requests_params', log_requests_params)
      end
    end # ClassMethods
    
    
    protected
    def log_request
      m = send(self.class.log_requests_condition) if self.class.log_requests_condition
      m = true if self.class.log_requests_condition.nil?
      return if !m
      
      s_rs_id = session[:request_stream_id]
      rs = RequestStream.find_by_id(session[:request_stream_id]) if s_rs_id
      if !s_rs_id || !rs
        # create a new request_stream
        rs = RequestStream.new
        rs.ip_address = request.remote_ip
        rs.last_request_at = Time.now
        rs.user_agent = request.env["HTTP_USER_AGENT"]
        rs.referer = request.env["HTTP_REFERER"]
        rs.user_id = session[:user_id] if session[:user_id]
        rs.save
        session[:request_stream_id] = rs.id
      else
        rs.last_request_at = Time.now
        rs.save
      end
      # In case the user logged in later.
      if rs && rs.user_id.nil?
        rs.user_id = session[:user_id] if session[:user_id]
        rs.save
      end
      
      r = Request.new
      r.path, r.method = request.path, request.method.to_s
      r.request_stream_id = session[:request_stream_id]
      r.params = params if self.class.log_requests_params
      r.save
    end
  end
end