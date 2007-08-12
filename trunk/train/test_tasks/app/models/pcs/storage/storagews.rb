require 'soap/rpc/standaloneServer'
require 'pcs/storage/storage'



module PCS
  module Storage
    
    
    
    class StorageWS < SOAP::RPC::StandaloneServer
      
      def initialize(storage_config, server_config)
#        puts server_config.class
        @storage_config = storage_config
        super(server_config.app_name, server_config.namespace, server_config.address, server_config.port)
        
        level = server_config.logging_level

#        puts @graderConfig.class
      end
      
      
      def on_init
        storage = Storage.new(@storage_config)
        
        add_method(storage, 'get_submit_files', 'submit_id')
        add_method(storage, 'get_test_files', 'test_id')
        add_method(storage, 'get_module_files', 'module_id')
        add_method(storage, 'get_checker_files', 'checker_id')
        add_method(storage, 'get_problem_info', 'problem_id')
        add_method(storage, 'get_compiler_options', 'submit_id')
        add_method(storage, 'get_checker_compiler_options', 'checker_id')        
        add_method(storage, 'copy_file_to', 'file_id', 'user', 'ip', 'destination', 'port')
        add_method(storage, 'add_file',  'user', 'ip', 'source', 'port')
      end
    
    end
    
  end 
end
