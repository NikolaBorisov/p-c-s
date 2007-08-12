module PCS
  module GradingQueue
    
    
    
    class GradingQueueConfig
      
      attr_accessor :db_settings, :grading_queue_root
      
      # Logger Settings
      attr_accessor :logger_shift_age, :logger_shift_size, :logging_level, :logger_datetime_format
      # Retry Settings
      attr_accessor :times_to_retry, :sleep_on_retry
      
      def initialize
        @logger_directory = 'log'
        @logger_filename = 'grading_queue.log'
      end
      
      
      def logger_root
        return File.join(@grading_queue_root,@logger_directory)
      end
      
      
      def logger_filepath
        return File.join(logger_root,@logger_filename)
      end
      
    end
    
    
    
  end
end
