require 'soap/rpc/standaloneServer'
require 'pcs/grading_queue/grading_queue'



module PCS
  module GradingQueue
    
    
    
    #
    # The web service class. It instantiates a grader module and passes the test requests to it.
    #
    class GradingQueueWS < SOAP::RPC::StandaloneServer
      
      #
      # Constructor. Saves the configuration modules and invokes the super-class constructor.
      #
      def initialize(grading_queue_config, server_config)
        @grading_queue_config = grading_queue_config
        
        super(server_config.app_name, server_config.namespace, server_config.address, server_config.port)
        
        level = server_config.logging_level
      end
      
      
      #
      # Creates a grader module and initializes the web service.
      #
      def on_init
        grading_queue = GradingQueue.new(@grading_queue_config)
        
        add_method(grading_queue, 'test', 'grader_id', 'problem_id', 'submit_id', 'test_id', 'checker_id', 'module_id')
        add_method(grading_queue, 'add_grader', 'grader_address', 'grader_port')
        add_method(grading_queue, 'get_graders')
        add_method(grading_queue, 'delete_grader', 'grader_id')
      end
      
    end
    
    
    
  end 
end
