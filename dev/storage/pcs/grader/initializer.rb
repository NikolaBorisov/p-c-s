require 'pcs/grader/graderws'
require 'pcs/grader/grader_config'
require 'pcs/grader/server_config'
require 'pcs/grader/storage_config'



module PCS
  module Grader
    
    
    
    class Initializer
      
      def self.run
        #
        # Initialize the configuration. This is the default configuration.
        # To configure please use the config.rb file.
        # 
        grader_config = GraderConfig.new
        server_config = ServerConfig.new
        storage_config = StorageConfig.new
        
        server_config.app_name = 'Grader'
        server_config.namespace = 'urn:PCS/Grader'
        server_config.address = '0.0.0.0'
        server_config.port = 5000
        server_config.logging_level = Logger::Severity::INFO
        
        #
        # Storage configuration
        #
        storage_config.host = 'http://localhost:5002'
        storage_config.namespace = 'urn:PCS/Storage'
        storage_config.times_to_retry = 5
        storage_config.sleep_on_retry = 0.5
        
        #
        # Grader configuration
        # 
        grader_config.user = 'borisof'
        grader_config.grader_address = 'cslab'
        grader_config.logger_shift_age = 5
        grader_config.logger_shift_size = 10 * 1024
        grader_config.logging_level = Logger::INFO
        grader_config.logger_datetime_format = '%Y.%m.%d %H:%M:%S'
        
        
        yield(grader_config, server_config, storage_config) if block_given?
        
        if (grader_config.grader_root.nil?)
          raise "Initializer: Grader root is not set."
        end
        
        
        #
        # Starting the server
        #
        graderws = GraderWS.new(grader_config, server_config, storage_config)
        trap("INT") { graderws.shutdown }
        graderws.start
        
      end
      
    end
    
    
    
  end
end
