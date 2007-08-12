require 'monitor'
require 'fileutils'
require 'pcs/utils'
require 'pcs/grader/cached_file'



module PCS
  module Grader
    
    
    
    #
    # Simple cache for files. It stores files identified by unique id. The cache
    # is capable of storing files and copying them to specified destination. The
    # cache is thread safe.
    #
    class Cache
      include MonitorMixin
      # TODO: add logic for deleting old files
      
      
      def initialize(cache_root, logger = nil)
        @cache_root = cache_root
        @logger = logger
        @cached_files = {}
        
        initialize_root
        
        super()
      end
      
      
      #
      # Checks if the file is already cached and return true or false accordingly.
      #
      def cached?(file_id)
        synchronize do
          return @cached_files.include?(file_id)
        end
      end
      
      
      #
      # Caches a file identified by unique id.
      #
      def save_file(file_id, source)
        synchronize do
          unless cached?(file_id)
            destination = File.join(@cache_root, Utils.fileid2name(file_id))
            FileUtils.cp(source, destination)
            
            if File.exist?(destination)
              cached_file = CachedFile.new
              cached_file.filename = File.basename(source)
              cached_file.last_copy = DateTime::now
              
              @cached_files[file_id] = cached_file
            else
              message = "Cache: Unable to copy file with id #{file_id}."
              @logger.error(message) if @logger
              raise message
            end
          end
        end
      end
      
      
      #
      # Copies a saved file to a specified destination.
      #
      def copy_file(file_id, destination)
        synchronize do
          if cached?(file_id)
            source = File.join(@cache_root, Utils.fileid2name(file_id))
            FileUtils.cp(source, destination)
            
            if File.exist?(destination)
              @cached_files[file_id].last_copy = DateTime::now
            else
              message = "Cache: Unable to copy file '#{source}' to '#{destination}'."
              @logger.error(message) if @logger
              raise message
            end
          else
            message = "Cache: File with id #{file_id} does not exist in cache."
            @logger.error(message) if @logger
            raise message
          end
        end
      end
      
      
      #
      # Initialized the cache root directory. This includes creating the directory
      # and clearing its contents.
      #
      def initialize_root
        Utils.create_directory(@cache_root)
        Utils.clear_directory(@cache_root)
      end
      
      private :initialize_root
      
    end
    
    
    
  end
end
