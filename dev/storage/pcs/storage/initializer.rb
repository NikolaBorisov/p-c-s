require 'pcs/storage/storagews'
require 'pcs/storage/storage_config'
require 'pcs/storage/server_config'



module PCS
  module Storage
    
    
    
    class Initializer
      
      def self.run
        
        #
        # Initialize the configuration
        # 
        storage_config = StorageConfig.new
        server_config = ServerConfig.new
        
        #
        # WS Settings
        #
        server_config.app_name = 'Storage'
        server_config.namespace = 'urn:PCS/Storage'
        server_config.address = '0.0.0.0'
        server_config.port = 5002
        server_config.logging_level = Logger::Severity::INFO
        
        #
        # Storage Settings
        # 
        storage_config.db_settings = {
          :adapter => "mysql",
          :host     => "localhost",
          :database => "pcs",
          :username => "pcs",
          :password => "123"
        }
        storage_config.file_server_location = ''
        storage_config.times_to_retry = 5
        storage_config.sleep_on_retry = 0.5
        
        # Storage Logger Settings
        storage_config.logger_shift_age = 5
        storage_config.logger_shift_size = 10 * 1024
        storage_config.logging_level = Logger::INFO
        storage_config.logger_datetime_format = '%Y.%m.%d %H:%M:%S'
        
        yield(storage_config, server_config) if block_given?
        
        if (storage_config.storage_root.nil?)
          raise 'Storage root is not set.'
        end
        
        
        #
        # Starting the server
        #
        storagews = StorageWS.new(storage_config, server_config)
        trap("INT") { storagews.shutdown }
        storagews.start
        
      end
      
    end
    
    
    
  end
end
