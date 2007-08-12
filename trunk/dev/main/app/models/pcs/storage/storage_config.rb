module PCS
  module Storage
    
    
    
    class StorageConfig
      
      attr_accessor :storage_root, :db_settings, :file_server_location
      
      # Logger Settings
      attr_accessor :logger_shift_age, :logger_shift_size, :logging_level, :logger_datetime_format
      # Retry Settings
      attr_accessor :times_to_retry, :sleep_on_retry
      
      def initialize
        @files_storage_dir = 'files'
        @logger_directory = 'log'
        @logger_filename = 'storage.log'
      end
      
      
      def files_storage_root
        return File.join(@storage_root, @files_storage_dir)
      end
      
      
      def files_storage_root_full_path
        if ( @file_server_location != '' )
          return @file_server_location + ":" + files_storage_root
        else
          return files_storage_root
        end
      end
      
      
      def logger_root
        return File.join(@storage_root,@logger_directory)
      end
      
      
      def logger_filepath
        return File.join(logger_root,@logger_filename)
      end
      
    end
    
    
    
  end
end
