require 'pcs/grading_queue/grading_queue_ws'
require 'pcs/grading_queue/grading_queue_config'
require 'pcs/grading_queue/server_config'



module PCS
  module GradingQueue
    
    
    
    class Initializer
      
      def self.run
        #
        # Initialize the configuration. This is the default configuration.
        # To configure please use the config.rb file.
        # 
        grading_queue_config = GradingQueueConfig.new
        server_config = ServerConfig.new
        
        server_config.app_name = 'GradingQueue'
        server_config.namespace = 'urn:PCS/GradingQueue'
        server_config.address = '0.0.0.0'
        server_config.port = 5004
        server_config.logging_level = Logger::Severity::INFO
        
                
        #
        # GradingQueue configuration
        # 
        grading_queue_config.logger_shift_age = 5
        grading_queue_config.logger_shift_size = 10 * 1024
        grading_queue_config.logging_level = Logger::INFO
        grading_queue_config.logger_datetime_format = '%Y.%m.%d %H:%M:%S'
        
        
        yield(grading_queue_config, server_config) if block_given?
        
        if (grading_queue_config.grading_queue_root.nil?)
          raise "Initializer: Grader root is not set."
        end
        
        
        #
        # Starting the server
        #
        grading_queue_ws = GradingQueueWS.new(grading_queue_config, server_config)
        trap("INT") { grading_queue_ws.shutdown }
        grading_queue_ws.start
        
      end
      
    end
    
    
    
  end
end
