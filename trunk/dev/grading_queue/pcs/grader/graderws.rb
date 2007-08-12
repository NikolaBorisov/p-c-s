require 'soap/rpc/standaloneServer'
require 'pcs/grader/grader'



module PCS
  module Grader
    
    
    
    #
    # The web service class. It instantiates a grader module and passes the test requests to it.
    #
    class GraderWS < SOAP::RPC::StandaloneServer
      
      #
      # Constructor. Saves the configuration modules and invokes the super-class constructor.
      #
      def initialize(graderConfig, serverConfig, storageConfig)
        @graderConfig = graderConfig
        @storageConfig = storageConfig
        
        super(serverConfig.app_name, serverConfig.namespace, serverConfig.address, serverConfig.port)
        
        level = serverConfig.logging_level
      end
      
      
      #
      # Creates a grader module and initializes the web service.
      #
      def on_init
        grader = Grader.new(@graderConfig, @storageConfig)
        
        add_method(grader, 'test', 'problem_id', 'submit_id', 'test_id', 'checker_id', 'module_id');
      end
      
    end
    
    
    
  end 
end
